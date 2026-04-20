import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/notification_service.dart';

class AdminNotificationController extends GetxController {
  final supabase = Supabase.instance.client;
  var isLoading = false.obs;
  var notifications = <Map<String, dynamic>>[].obs;
  var selectedFilter = 'semua'.obs;
  final _notifService = NotificationService();

  void laporPesanMasuk(String pesan) {
    _notifService.showLocalNotification(title: "Info Admin", body: pesan);
  }

  @override
  void onInit() {
    super.onInit();

    loadNotifications();
  }

  // ================= LOAD =================

  Future<void> loadNotifications() async {
    await fetchNotifications();
  }

  // ================= FETCH =================

  Future<void> fetchNotifications() async {
    isLoading.value = true;

    try {
      final response = await supabase
          .from('notifikasi')
          .select()
          .order('created_at', ascending: false);

      final data = List<Map<String, dynamic>>.from(response);

      // DEBUG

      if (data.isNotEmpty) {
        print('🔥 SAMPLE DATA: ${data.first}');
      }

      notifications.value = data;
    } catch (e) {
      Get.snackbar('Gagal', 'Tidak bisa ambil data: $e');

      notifications.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // ================= FILTER =================

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter.value == 'semua') return notifications;

    return notifications
        .where((n) => notificationCategory(n) == selectedFilter.value)
        .toList();
  }

  void setFilter(String value) {
    selectedFilter.value = value;
  }

  // ================= UNREAD =================

  int get unreadCount =>
      notifications.where((n) => n['is_read'] == false).length;

  bool get hasUnread => unreadCount > 0;

  // ================= HELPER ID =================

  dynamic getNotifId(Map<String, dynamic> notif) {
    return notif['id'] ??
        notif['id_notifikasi'] ??
        notif['notif_id'] ??
        notif['uuid'];
  }

  String getIdColumn(Map<String, dynamic> notif) {
    if (notif.containsKey('id')) return 'id';

    if (notif.containsKey('id_notifikasi')) return 'id_notifikasi';

    if (notif.containsKey('notif_id')) return 'notif_id';

    if (notif.containsKey('uuid')) return 'uuid';

    throw Exception('Kolom ID tidak ditemukan');
  }

  // ================= MARK AS READ =================

  Future<void> markAsRead(Map<String, dynamic> notif) async {
    if (notif['is_read'] == true) return;

    final id = getNotifId(notif);

    if (id == null) {
      print('❌ ID NULL: $notif');

      return;
    }

    final idColumn = getIdColumn(notif);

    final index = notifications.indexWhere((n) => getNotifId(n) == id);

    if (index == -1) {
      print('❌ ID tidak ditemukan di list');

      return;
    }

    print('🔥 Klik notif ID: $id');

    print('🔥 Kolom ID: $idColumn');

    final old = Map<String, dynamic>.from(notifications[index]);

    // ✅ optimistic update

    notifications[index]['is_read'] = true;

    notifications.refresh();

    try {
      final res = await supabase
          .from('notifikasi')
          .update({'is_read': true})
          .eq(idColumn, id)
          .select();

      print('🔥 RESULT UPDATE: $res');

      if (res.isEmpty) {
        throw Exception('Update tidak kena row');
      }
    } catch (e) {
      print('❌ ERROR UPDATE: $e');

      // rollback

      notifications[index] = old;

      notifications.refresh();

      Get.snackbar('Gagal', 'Update gagal: $e');
    }
  }

  // ================= MARK ALL =================

  Future<void> markAllAsRead() async {
    if (!hasUnread) return;

    final previous = List<Map<String, dynamic>>.from(notifications);

    // optimistic

    for (var n in notifications) {
      n['is_read'] = true;
    }

    notifications.refresh();

    try {
      await supabase
          .from('notifikasi')
          .update({'is_read': true})
          .eq('is_read', false);
    } catch (e) {
      notifications.value = previous;

      Get.snackbar('Gagal', 'Tidak bisa update semua notifikasi');
    }
  }

  // ================= CATEGORY =================

  String notificationCategory(Map notif) {
    final type = (notif['tipe'] ?? '').toString().toLowerCase();

    if (type.contains('pengumuman')) return 'pengumuman';

    if (type.contains('surat')) return 'surat';

    return 'sistem';
  }

  String categoryLabel(String type) {
    switch (type) {
      case 'surat':
        return 'Surat';

      case 'pengumuman':
        return 'Pengumuman';

      default:
        return 'Sistem';
    }
  }

  // ================= FORMAT TIME =================

  String formatTimestamp(String? date) {
    if (date == null) return '-';

    final parsed = DateTime.tryParse(date);

    if (parsed == null) return '-';

    final now = DateTime.now();

    final diff = now.difference(parsed.toLocal());

    if (diff.inMinutes < 1) return 'Baru saja';

    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';

    if (diff.inHours < 24) return '${diff.inHours} jam lalu';

    if (diff.inDays < 7) return '${diff.inDays} hari lalu';

    return '${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year}';
  }
}
