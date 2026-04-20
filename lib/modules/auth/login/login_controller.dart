import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../app/routes/app_routes.dart';
import '../../../data/providers/storage_provider.dart';

class LoginController extends GetxController {
  final AuthRepository authRepo;
  LoginController({required this.authRepo});

  final nikCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final tglLahirCtrl = TextEditingController();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var agreeTerms = false.obs;

  void togglePw() => isPasswordVisible.toggle();
  void toggleTerms() => agreeTerms.toggle();

  final _storage = StorageProvider();

  void loginSuccess(String token, String role) async {
    await _storage.saveToken(token);
    await _storage.saveRole(role);

    if (role == 'admin') {
      Get.offAllNamed('/admin-dashboard');
    } else {
      Get.offAllNamed('/warga-dashboard');
    }
  }

  Future<void> login() async {
    if (nikCtrl.text.trim().isEmpty ||
        passwordCtrl.text.isEmpty ||
        tglLahirCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Semua field wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!agreeTerms.value) {
      Get.snackbar(
        'Perhatian',
        'Anda harus menyetujui Syarat Layanan dan Kebijakan Privasi',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final parts = tglLahirCtrl.text.trim().split('/');
    if (parts.length != 3) {
      Get.snackbar(
        'Perhatian',
        'Format tanggal lahir harus DD/MM/YYYY',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final tanggalLahir = DateTime.tryParse(
      '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}',
    );
    if (tanggalLahir == null) {
      Get.snackbar(
        'Perhatian',
        'Tanggal lahir tidak valid',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    // FIX: hapus parameter nama
    final result = await authRepo.login(
      nikCtrl.text.trim(),
      passwordCtrl.text,
      tanggalLahir,
    );

    isLoading.value = false;

    if (result['success'] == true) {
      final penduduk = result['penduduk'] as PendudukModel;
      final isAdmin = result['isAdmin'] as bool;
      Get.put(penduduk, permanent: true);

      if (isAdmin) {
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else {
        Get.offAllNamed(AppRoutes.wargaDashboard);
      }
    } else {
      Get.snackbar(
        'Login Gagal',
        result['message'] ?? 'Terjadi kesalahan',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // @override
  // void onClose() {
  //   nikCtrl.dispose();
  //   passwordCtrl.dispose();
  //   tglLahirCtrl.dispose();
  //   super.onClose();
  // }
}
