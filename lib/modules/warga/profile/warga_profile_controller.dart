import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/penduduk_repository.dart';

class WargaProfileController extends GetxController {
  final PendudukRepository pendudukRepo;
  WargaProfileController({required this.pendudukRepo});

  final oldPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  var isSubmitting = false.obs;

  PendudukModel? get penduduk {
    try {
      return Get.find<PendudukModel>();
    } catch (_) {
      return null;
    }
  }

  Future<void> changePassword() async {
    final currentPenduduk = penduduk;
    if (currentPenduduk == null) {
      Get.snackbar('Gagal', 'Data pengguna tidak ditemukan.');
      return;
    }

    final oldPassword = oldPasswordCtrl.text.trim();
    final newPassword = newPasswordCtrl.text.trim();
    final confirmPassword = confirmPasswordCtrl.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Gagal', 'Semua kolom password harus diisi.');
      return;
    }
    if (currentPenduduk.password != null &&
        currentPenduduk.password != oldPassword) {
      Get.snackbar('Gagal', 'Password lama tidak cocok.');
      return;
    }
    if (newPassword != confirmPassword) {
      Get.snackbar('Gagal', 'Password baru dan konfirmasi tidak sama.');
      return;
    }
    if (newPassword.length < 6) {
      Get.snackbar('Gagal', 'Password baru minimal 6 karakter.');
      return;
    }

    isSubmitting.value = true;
    try {
      final result = await pendudukRepo.updatePendudukPassword(
        currentPenduduk.idPenduduk!,
        newPassword,
      );
      if (result['success'] == true) {
        final updated = result['penduduk'] as PendudukModel;
        if (Get.isRegistered<PendudukModel>()) {
          Get.delete<PendudukModel>(force: true);
        }
        Get.put(updated, permanent: true);
        oldPasswordCtrl.clear();
        newPasswordCtrl.clear();
        confirmPasswordCtrl.clear();
        Get.back();
        Get.snackbar('Berhasil', 'Password berhasil diperbarui.');
      } else {
        Get.snackbar(
          'Gagal',
          result['message'] ?? 'Terjadi kesalahan saat memperbarui password.',
        );
      }
    } catch (e) {
      Get.snackbar('Gagal', 'Terjadi kesalahan: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    oldPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
