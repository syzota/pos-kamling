import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/notifikasi_repository.dart';
import '../../../data/repositories/surat_repository.dart';

class LetterController extends GetxController {
  final SuratRepository suratRepo;
  final NotifikasiRepository notifikasiRepo;

  LetterController({required this.suratRepo, required this.notifikasiRepo});

  var riwayatSurat = <SuratModel>[].obs;
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var selectedJenisSurat = ''.obs;
  var processingSuratIds = <int>[].obs;
  final keperluanCtrl = TextEditingController();

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
    loadRiwayat();
  }

  Future<void> loadRiwayat() async {
    if (penduduk == null) return;
    isLoading.value = true;
    try {
      riwayatSurat.value = await suratRepo.getSuratByPenduduk(
        penduduk!.idPenduduk!,
      );
    } catch (_) {}
    isLoading.value = false;
  }

  Future<void> ajukanSurat() async {
    if (selectedJenisSurat.value.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Pilih jenis surat terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (keperluanCtrl.text.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Keperluan wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (penduduk == null) {
      Get.snackbar(
        'Error',
        'Data penduduk tidak ditemukan',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    isSubmitting.value = true;
    final result = await suratRepo.ajukanSurat(
      idPenduduk: penduduk!.idPenduduk!,
      jenisSurat: selectedJenisSurat.value,
      keperluan: keperluanCtrl.text,
    );
    isSubmitting.value = false;
    if (result['success'] == true) {
      await notifikasiRepo.createNotification(
        idPenduduk: penduduk!.idPenduduk!,
        judul: 'Pengajuan surat berhasil',
        isi:
            'Permohonan ${selectedJenisSurat.value} sudah dikirim dan sedang menunggu verifikasi dari Pak RT.',
        tipe: 'surat_pengajuan',
      );
      Get.snackbar(
        'Sukses',
        'Surat berhasil diajukan!',
        snackPosition: SnackPosition.BOTTOM,
      );
      keperluanCtrl.clear();
      selectedJenisSurat.value = '';
      loadRiwayat();
    } else {
      Get.snackbar(
        'Gagal',
        result['message'] ?? 'Terjadi kesalahan',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  bool canReceiveSurat(SuratModel surat) =>
      surat.status == 'disetujui' &&
      (surat.fileUrl?.trim().isNotEmpty ?? false) &&
      surat.idSurat != null;

  bool isProcessingSurat(int idSurat) => processingSuratIds.contains(idSurat);

  Future<void> terimaSurat(SuratModel surat) async {
    if (!canReceiveSurat(surat)) {
      Get.snackbar(
        'Info',
        'File surat belum tersedia untuk diunduh',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final confirmed =
        await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Terima Surat'),
            content: Text(
              'Surat ${surat.jenisSurat ?? ''} sudah disetujui. Lanjutkan untuk menerima dan membuka file PDF?',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Terima'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    await downloadSurat(
      surat,
      successMessage: 'Surat diterima. File PDF sedang dibuka.',
    );
  }

  Future<void> downloadSurat(SuratModel surat, {String? successMessage}) async {
    if (surat.idSurat == null) return;

    final fileUrl = surat.fileUrl?.trim();
    if (fileUrl == null || fileUrl.isEmpty) {
      Get.snackbar(
        'Info',
        'File surat belum tersedia untuk diunduh',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    processingSuratIds.add(surat.idSurat!);

    try {
      final uri = Uri.tryParse(fileUrl);
      if (uri == null) {
        throw Exception('URL file surat tidak valid');
      }

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw Exception('File PDF tidak dapat dibuka');
      }

      if (successMessage != null) {
        Get.snackbar(
          'Sukses',
          successMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Tidak bisa membuka file surat: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      processingSuratIds.remove(surat.idSurat!);
    }
  }

  @override
  void onClose() {
    keperluanCtrl.dispose();
    super.onClose();
  }
}
