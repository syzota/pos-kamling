import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/models.dart';
import '../../../data/repositories/notifikasi_repository.dart';
import '../../../data/repositories/surat_repository.dart';

class AdminLettersController extends GetxController {
  final SuratRepository suratRepo;
  final NotifikasiRepository notifikasiRepo;

  AdminLettersController({
    required this.suratRepo,
    required this.notifikasiRepo,
  });

  var suratList = <SuratModel>[].obs;
  var isLoading = false.obs;
  var uploadingSuratId = RxnInt();
  var filterStatus = 'semua'.obs;

  List<SuratModel> get filteredSurat {
    if (filterStatus.value == 'semua') return suratList;

    return suratList.where((s) {
      if (filterStatus.value == 'diajukan') return s.status == 'diajukan';
      if (filterStatus.value == 'diproses') return s.status == 'diproses';
      if (filterStatus.value == 'disetujui') return s.status == 'disetujui';
      if (filterStatus.value == 'ditolak') return s.status == 'ditolak';
      return false;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadSurat();
  }

  Future<void> loadSurat() async {
    isLoading.value = true;
    try {
      final data = await suratRepo.getAllSurat();
      suratList.assignAll(data);
    } catch (_) {
      Get.snackbar("Error", "Gagal memuat data");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(int idSurat, String status) async {
    SuratModel? targetSurat = suratList.firstWhereOrNull(
      (e) => e.idSurat == idSurat,
    );

    final result = await suratRepo.updateStatusSurat(idSurat, status);

    if (result['success'] == true) {
      if (targetSurat?.idPenduduk != null) {
        await notifikasiRepo.createNotification(
          idPenduduk: targetSurat!.idPenduduk!,
          judul: _notificationTitleForStatus(status),
          isi: _notificationMessageForStatus(targetSurat, status),
          tipe: _notificationTypeForStatus(status),
        );
      }

      Get.snackbar(
        'Sukses',
        'Status surat diperbarui',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadSurat();
    } else {
      Get.snackbar(
        'Gagal',
        result['message'] ?? 'Terjadi kesalahan',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> approveWithFile({
    required int idSurat,
    required String fileName,
    String? filePath,
    Uint8List? fileBytes,
  }) async {
    try {
      uploadingSuratId.value = idSurat;

      final supabase = Supabase.instance.client;
      final storageFileName =
          'surat_${idSurat}_${DateTime.now().millisecondsSinceEpoch}.pdf';

      if (kIsWeb) {
        if (fileBytes == null || fileBytes.isEmpty) {
          throw Exception('Data file PDF tidak tersedia untuk web');
        }

        await supabase.storage
            .from('surat')
            .uploadBinary(
              storageFileName,
              fileBytes,
              fileOptions: const FileOptions(
                contentType: 'application/pdf',
                upsert: true,
              ),
            )
            .timeout(const Duration(seconds: 45));
      } else {
        if (filePath == null || filePath.isEmpty) {
          throw Exception('Path file PDF tidak tersedia di perangkat');
        }

        final file = File(filePath);

        if (!file.existsSync()) {
          throw Exception('File tidak ditemukan di penyimpanan perangkat');
        }

        await supabase.storage
            .from('surat')
            .upload(
              storageFileName,
              file,
              fileOptions: const FileOptions(
                contentType: 'application/pdf',
                upsert: true,
              ),
            )
            .timeout(const Duration(seconds: 45));
      }

      final fileUrl = supabase.storage
          .from('surat')
          .getPublicUrl(storageFileName);

      await supabase
          .from('surat')
          .update({
            'status': 'disetujui',
            'file_url': fileUrl,
            'tanggal_selesai': DateTime.now().toIso8601String(),
          })
          .eq('id_surat', idSurat)
          .timeout(const Duration(seconds: 20));

      final targetSurat = suratList.firstWhereOrNull(
        (e) => e.idSurat == idSurat,
      );

      if (targetSurat?.idPenduduk != null) {
        await notifikasiRepo.createNotification(
          idPenduduk: targetSurat!.idPenduduk!,
          judul: _notificationTitleForStatus('disetujui'),
          isi: _notificationMessageForStatus(targetSurat, 'disetujui'),
          tipe: _notificationTypeForStatus('disetujui'),
        );
      }

      Get.snackbar(
        "Berhasil",
        "Surat selesai dan PDF berhasil dikirim ke warga",
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadSurat();
    } on TimeoutException {
      Get.snackbar(
        "Error",
        "Upload file terlalu lama. Periksa koneksi internet lalu coba lagi.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal upload file: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      uploadingSuratId.value = null;
    }
  }

  void setFilter(String f) => filterStatus.value = f;

  bool isUploadingFor(int idSurat) => uploadingSuratId.value == idSurat;

  String _notificationTitleForStatus(String status) {
    switch (status) {
      case 'disetujui':
        return 'Surat disetujui';
      case 'ditolak':
        return 'Surat ditolak';
      case 'diproses':
        return 'Surat sedang diproses';
      default:
        return 'Status surat diperbarui';
    }
  }

  String _notificationTypeForStatus(String status) {
    switch (status) {
      case 'disetujui':
        return 'surat_disetujui';
      case 'ditolak':
        return 'surat_ditolak';
      case 'diproses':
        return 'surat_diproses';
      default:
        return 'surat_update';
    }
  }

  String _notificationMessageForStatus(SuratModel surat, String status) {
    final jenisSurat = surat.jenisSurat ?? 'surat Anda';

    switch (status) {
      case 'disetujui':
        return '$jenisSurat telah disetujui. File PDF surat sudah tersedia untuk warga.';
      case 'ditolak':
        return '$jenisSurat ditolak. Hubungi admin RT.';
      case 'diproses':
        return '$jenisSurat sedang diproses.';
      default:
        return 'Status $jenisSurat diperbarui menjadi $status.';
    }
  }
}
