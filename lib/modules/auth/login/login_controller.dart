import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  Future<void> login() async {
    if (nikCtrl.text.trim().isEmpty ||
        passwordCtrl.text.isEmpty ||
        tglLahirCtrl.text.trim().isEmpty) {
      Get.snackbar('Perhatian', 'Semua field wajib diisi');
      return;
    }

    if (!agreeTerms.value) {
      Get.snackbar('Perhatian', 'Harus setuju syarat');
      return;
    }

    // ✅ FIX PARSING
    DateTime? tanggalLahir;
    try {
      tanggalLahir = DateFormat(
        'dd/MM/yyyy',
      ).parseStrict(tglLahirCtrl.text.trim());
    } catch (e) {
      tanggalLahir = null;
    }

    if (tanggalLahir == null) {
      Get.snackbar('Error', 'Format tanggal harus DD/MM/YYYY');
      return;
    }

    isLoading.value = true;

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

      Get.offAllNamed(
        isAdmin ? AppRoutes.adminDashboard : AppRoutes.wargaDashboard,
      );
    } else {
      Get.snackbar('Login Gagal', result['message'] ?? 'Terjadi kesalahan');
    }
  }
}
