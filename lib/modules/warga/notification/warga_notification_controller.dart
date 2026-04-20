import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/notifikasi_repository.dart';
import '../../../data/repositories/pengumuman_repository.dart';
import '../../../data/repositories/surat_repository.dart';
import '../../../core/services/notification_service.dart';

class WargaNotificationController extends GetxController {
  final NotifikasiRepository notifikasiRepo;
  final SuratRepository suratRepo;
  final PengumumanRepository
  pengumumanRepo; // ⚠ masih injected (biar struktur tidak berubah)
  final _notifService = NotificationService();

  void laporPesanMasuk(String pesan) {
    // Logic khusus warga, misalnya muncul notif saat ada pengumuman baru
    _notifService.showLocalNotification(title: "Info Warga Baru", body: pesan);
  }

  WargaNotificationController({
    required this.notifikasiRepo,
    required this.suratRepo,
    required this.pengumumanRepo,
  });

  var isLoading = false.obs;
  var notifikasi = <NotifikasiModel>[].obs;
  var selectedFilter = 'semua'.obs;

  PendudukModel? get penduduk {
    try {
      return Get.find<PendudukModel>();
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  List<NotifikasiModel> get filteredNotifications {
    if (selectedFilter.value == 'semua') {
      return notifikasi;
    }
    return notifikasi
        .where((item) => notificationCategory(item) == selectedFilter.value)
        .toList();
  }

  int get unreadCount => notifikasi.where((item) => !item.isRead).length;
  bool get hasUnread => unreadCount > 0;

  Future<void> loadNotifications() async {
    final currentPenduduk = penduduk;

    if (currentPenduduk == null || currentPenduduk.idPenduduk == null) {
      notifikasi.clear();
      return;
    }

    isLoading.value = true;

    try {
      final storedNotifications = await _safeLoadStoredNotifications(
        currentPenduduk.idPenduduk!,
      );

      final suratNotifications = await _safeLoadSuratNotifications(
        currentPenduduk.idPenduduk!,
      );

      final merged = _mergeNotifications([
        ...storedNotifications,
        ...suratNotifications,
      ]);

      merged.sort(
        (a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
      );

      notifikasi.value = merged;
    } catch (e) {
      notifikasi.clear();
    } finally {
      isLoading.value = false; // 🔥 lebih aman
    }
  }

  void setFilter(String value) {
    selectedFilter.value = value;
  }

  Future<void> markAsRead(NotifikasiModel item) async {
    if (item.isRead) return;

    final index = notifikasi.indexWhere(
      (element) =>
          element.idNotifikasi == item.idNotifikasi &&
          element.createdAt == item.createdAt &&
          element.judul == item.judul,
    );

    if (index == -1) return;

    notifikasi[index] = NotifikasiModel(
      idNotifikasi: item.idNotifikasi,
      idPenduduk: item.idPenduduk,
      judul: item.judul,
      isi: item.isi,
      tipe: item.tipe,
      isRead: true,
      createdAt: item.createdAt,
    );

    notifikasi.refresh();

    if (item.idNotifikasi == null) return;

    final result = await notifikasiRepo.markAsRead(item.idNotifikasi!);

    if (result['success'] != true) {
      notifikasi[index] = item;
      notifikasi.refresh();
    }
  }

  Future<void> markAllAsRead() async {
    final currentPenduduk = penduduk;

    if (currentPenduduk?.idPenduduk == null || !hasUnread) return;

    final previous = List<NotifikasiModel>.from(notifikasi);

    notifikasi.value = previous
        .map(
          (item) => NotifikasiModel(
            idNotifikasi: item.idNotifikasi,
            idPenduduk: item.idPenduduk,
            judul: item.judul,
            isi: item.isi,
            tipe: item.tipe,
            isRead: true,
            createdAt: item.createdAt,
          ),
        )
        .toList();

    final hasStoredNotifications = previous.any(
      (item) => item.idNotifikasi != null && !item.isRead,
    );

    if (!hasStoredNotifications) return;

    final result = await notifikasiRepo.markAllAsRead(
      currentPenduduk!.idPenduduk!,
    );

    if (result['success'] != true) {
      notifikasi.value = previous;
    }
  }

  String notificationCategory(NotifikasiModel item) {
    final tipe = item.tipe?.toLowerCase() ?? '';

    if (tipe.contains('pengumuman')) return 'pengumuman';
    if (tipe.contains('surat')) return 'surat';

    return 'sistem';
  }

  String categoryLabel(String category) {
    switch (category) {
      case 'pengumuman':
        return 'Pengumuman';
      case 'surat':
        return 'Surat';
      default:
        return 'Sistem';
    }
  }

  String formatTimestamp(DateTime? dateTime) {
    if (dateTime == null) return '-';

    final now = DateTime.now();
    final local = dateTime.toLocal();
    final diff = now.difference(local);

    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';

    return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}';
  }

  Future<List<NotifikasiModel>> _safeLoadStoredNotifications(
    int idPenduduk,
  ) async {
    try {
      return await notifikasiRepo.getNotifikasiByPenduduk(idPenduduk);
    } catch (_) {
      return [];
    }
  }

  Future<List<NotifikasiModel>> _safeLoadSuratNotifications(
    int idPenduduk,
  ) async {
    try {
      final suratItems = await suratRepo.getSuratByPenduduk(idPenduduk);
      return suratItems.map(_buildSuratNotification).toList();
    } catch (_) {
      return [];
    }
  }

  NotifikasiModel _buildSuratNotification(SuratModel surat) {
    final jenisSurat = surat.jenisSurat ?? 'surat';

    switch (jenisSurat) {
      case 'disetujui':
        return NotifikasiModel(
          idPenduduk: surat.idPenduduk,
          judul: 'Surat disetujui',
          isi:
              '$jenisSurat telah disetujui. Silakan cek ke admin RT untuk proses lanjutan atau pengambilan dokumen.',
          tipe: 'surat_disetujui',
          isRead: false,
          createdAt: surat.tanggalSelesai ?? surat.tanggalPengajuan,
        );

      case 'ditolak':
        return NotifikasiModel(
          idPenduduk: surat.idPenduduk,
          judul: 'Surat ditolak',
          isi:
              '$jenisSurat belum dapat diproses dan telah ditolak. Silakan hubungi admin RT untuk mengetahui detailnya.',
          tipe: 'surat_ditolak',
          isRead: false,
          createdAt: surat.tanggalSelesai ?? surat.tanggalPengajuan,
        );

      case 'diproses':
        return NotifikasiModel(
          idPenduduk: surat.idPenduduk,
          judul: 'Surat sedang diproses',
          isi:
              '$jenisSurat sedang diproses oleh admin RT. Kami akan memberi kabar lagi setelah ada hasil akhir.',
          tipe: 'surat_diproses',
          isRead: false,
          createdAt: surat.tanggalPengajuan,
        );

      default:
        return NotifikasiModel(
          idPenduduk: surat.idPenduduk,
          judul: 'Pengajuan surat berhasil',
          isi:
              'Permohonan $jenisSurat sudah dikirim dan sedang menunggu verifikasi dari Pak RT.',
          tipe: 'surat_pengajuan',
          isRead: false,
          createdAt: surat.tanggalPengajuan,
        );
    }
  }

  List<NotifikasiModel> _mergeNotifications(List<NotifikasiModel> items) {
    final merged = <NotifikasiModel>[];
    final seenKeys = <String>{};

    for (final item in items) {
      // 🔥 lebih kuat (hindari tabrakan notif sama)
      final key =
          '${item.tipe}|${item.judul}|${item.isi}|${item.createdAt?.toIso8601String()}';

      if (seenKeys.add(key)) {
        merged.add(item);
      }
    }

    return merged;
  }
}
