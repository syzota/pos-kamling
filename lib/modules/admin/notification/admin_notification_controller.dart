import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/notification_service.dart';

class AdminNotificationController extends GetxController {
  final _supabase = Supabase.instance.client;
  final _notifSvc = NotificationService();

  final isLoading      = false.obs;
  final notifications  = <Map<String, dynamic>>[].obs;
  final selectedFilter = 'semua'.obs;

  final titleCtrl    = TextEditingController();
  final bodyCtrl     = TextEditingController();
  final isSending    = false.obs;
  final selectedType = 'pengumuman'.obs;

  final types = const [
    {'value': 'pengumuman', 'label': 'Pengumuman'},
    {'value': 'kegiatan',   'label': 'Kegiatan'},
    {'value': 'keuangan',   'label': 'Keuangan'},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    bodyCtrl.dispose();
    super.onClose();
  }

  Future<void> sendNotification() async {
    final title = titleCtrl.text.trim();
    final body  = bodyCtrl.text.trim();

    if (title.isEmpty || body.isEmpty) {
      _error('Judul dan isi wajib diisi');
      return;
    }

    isSending.value = true;
    try {
      switch (selectedType.value) {
        case 'pengumuman':
          await _supabase.from('pengumuman').insert({
            'judul'   : title,
            'isi'     : body,
            'kategori': 'Umum',
            'tanggal' : DateTime.now().toIso8601String(),
          });
          break;

        case 'kegiatan':
          await _supabase.from('kegiatan').insert({
            'nama_kegiatan': title,
            'deskripsi'    : body,
            'tanggal'      : DateTime.now().toIso8601String(),
          });
          break;

        case 'keuangan':
          await _supabase.from('keuangan').insert({
            'jenis'      : 'pemasukan',
            'keterangan' : body,
            'nominal'    : 0,
            'tanggal'    : DateTime.now().toIso8601String(),
          });
          break;

        default:
          await _supabase.from('notifikasi').insert({
            'judul'     : title,
            'isi'       : body,
            'tipe'      : selectedType.value,
            'is_read'   : false,
            'created_at': DateTime.now().toIso8601String(),
          });
      }

      _success('Notifikasi berhasil dikirim ke warga');
      _resetForm();
      await fetchNotifications();
    } catch (e) {
      _error(e.toString());
    } finally {
      isSending.value = false;
    }
  }

  Future<void> loadNotifications() => fetchNotifications();

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final response = await _supabase
          .from('notifikasi')
          .select()
          .order('created_at', ascending: false);

      notifications.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      _error('Tidak bisa ambil data: $e');
      notifications.clear();
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter.value == 'semua') return notifications;
    return notifications
        .where((n) => notificationCategory(n) == selectedFilter.value)
        .toList();
  }

  void setFilter(String value) => selectedFilter.value = value;

  int  get unreadCount => notifications.where((n) => n['is_read'] == false).length;
  bool get hasUnread   => unreadCount > 0;

  Future<void> markAsRead(Map<String, dynamic> notif) async {
    if (notif['is_read'] == true) return;

    final id       = _getNotifId(notif);
    final idColumn = _getIdColumn(notif);
    if (id == null) return;

    final index = notifications.indexWhere((n) => _getNotifId(n) == id);
    if (index == -1) return;

    final backup = Map<String, dynamic>.from(notifications[index]);
    notifications[index]['is_read'] = true;
    notifications.refresh();

    try {
      final res = await _supabase
          .from('notifikasi')
          .update({'is_read': true})
          .eq(idColumn, id)
          .select();

      if (res.isEmpty) throw Exception('Update tidak kena row');
    } catch (e) {
      notifications[index] = backup;
      notifications.refresh();
      _error('Update gagal: $e');
    }
  }

  Future<void> markAllAsRead() async {
    if (!hasUnread) return;

    final backup = List<Map<String, dynamic>>.from(notifications);
    for (var n in notifications) {
      n['is_read'] = true;
    }
    notifications.refresh();

    try {
      await _supabase
          .from('notifikasi')
          .update({'is_read': true})
          .eq('is_read', false);
    } catch (e) {
      notifications.value = backup;
      _error('Tidak bisa update semua notifikasi');
    }
  }

  dynamic _getNotifId(Map<String, dynamic> notif) =>
      notif['id'] ?? notif['id_notifikasi'] ?? notif['notif_id'] ?? notif['uuid'];

  String _getIdColumn(Map<String, dynamic> notif) {
    if (notif.containsKey('id'))            return 'id';
    if (notif.containsKey('id_notifikasi')) return 'id_notifikasi';
    if (notif.containsKey('notif_id'))      return 'notif_id';
    if (notif.containsKey('uuid'))          return 'uuid';
    throw Exception('Kolom ID tidak ditemukan');
  }

  String notificationCategory(Map notif) {
    final type = (notif['tipe'] ?? '').toString().toLowerCase();
    if (type.contains('pengumuman')) return 'pengumuman';
    if (type.contains('surat'))      return 'surat';
    return 'sistem';
  }

  String categoryLabel(String type) {
    switch (type) {
      case 'surat':      return 'Surat';
      case 'pengumuman': return 'Pengumuman';
      default:           return 'Sistem';
    }
  }

  String formatTimestamp(String? date) {
    if (date == null) return '-';
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return '-';
    final diff = DateTime.now().difference(parsed.toLocal());
    if (diff.inMinutes < 1)  return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24)   return '${diff.inHours} jam lalu';
    if (diff.inDays < 7)     return '${diff.inDays} hari lalu';
    return '${parsed.day.toString().padLeft(2, '0')}/'
        '${parsed.month.toString().padLeft(2, '0')}/'
        '${parsed.year}';
  }

  void laporPesanMasuk(String pesan) =>
      _notifSvc.showLocalNotification(title: 'Info Admin', body: pesan);

  void _resetForm() {
    titleCtrl.clear();
    bodyCtrl.clear();
    selectedType.value = 'pengumuman';
  }

  void _success(String msg) => Get.snackbar(
        'Berhasil', msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF43A047),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );

  void _error(String msg) => Get.snackbar(
        'Gagal', msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE53935),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
}