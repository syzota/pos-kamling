import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/biometric_service.dart' as bio;
import '../../../core/services/session_service.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/penduduk_repository.dart';

class SecurityController extends GetxController {
  final PendudukRepository pendudukRepo;
  SecurityController({required this.pendudukRepo});

  final _biometric = bio.BiometricService();
  final _session = SessionService();

  final isBiometricAvailable = false.obs;
  final isBiometricEnabled = false.obs;
  final biometricSubtitle = 'Memuat...'.obs;

  final rememberLogin = true.obs;

  final oldPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final isSubmitting = false.obs;
  final showOld = false.obs;
  final showNew = false.obs;
  final showConfirm = false.obs;

  Future<PendudukModel?> getPenduduk() async {
    try {
      final session = _session.loggedUser;
      if (session == null) return null;
      final idPenduduk = session['id_penduduk'];
      if (idPenduduk == null) return null;
      return await pendudukRepo.getPendudukById(idPenduduk);
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    rememberLogin.value = _session.rememberLogin;

    isBiometricEnabled.value = _session.biometricEnabled;

    final status = await _biometric.getDeviceStatus();

    switch (status) {
      case bio.BiometricDeviceStatus.available:
        isBiometricAvailable.value = true;
        biometricSubtitle.value = isBiometricEnabled.value
            ? 'Aktif — login dengan sidik jari'
            : 'Login dengan sidik jari';
        break;

      case bio.BiometricDeviceStatus.notEnrolled:
        isBiometricAvailable.value = false;
        biometricSubtitle.value =
            'Daftarkan fingerprint di Pengaturan terlebih dahulu';
        break;

      case bio.BiometricDeviceStatus.notSupported:
        isBiometricAvailable.value = false;
        biometricSubtitle.value = 'Tidak didukung perangkat ini';
        break;
    }
  }

  Future<void> toggleFingerprint(bool value) async {
    if (!isBiometricAvailable.value) return;

    final result = await _biometric.authenticate(
      reason: value
          ? 'Verifikasi untuk mengaktifkan login Fingerprint'
          : 'Verifikasi untuk menonaktifkan login Fingerprint',
    );

    if (!result.success) {
      Get.snackbar(
        'Gagal',
        result.errorMessage ?? 'Verifikasi gagal',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isBiometricEnabled.value = value;
    await _session.setBiometricEnabled(value);

    biometricSubtitle.value = value
        ? 'Aktif — login dengan sidik jari'
        : 'Login dengan sidik jari';

    _success('Fingerprint ${value ? "diaktifkan" : "dinonaktifkan"}');
  }

  Future<void> toggleRememberLogin(bool value) async {
    rememberLogin.value = value;
    await _session.setRememberLogin(value);
  }

  Future<void> changePassword({required bool requireOldPassword}) async {
    final p = await getPenduduk();
    if (p == null) {
      _error('Data pengguna tidak ditemukan');
      return;
    }

    final oldPwd = oldPasswordCtrl.text.trim();
    final newPwd = newPasswordCtrl.text.trim();
    final confirm = confirmPasswordCtrl.text.trim();

    if ((requireOldPassword && oldPwd.isEmpty) ||
        newPwd.isEmpty ||
        confirm.isEmpty) {
      _error('Semua field wajib diisi');
      return;
    }
    if (requireOldPassword && p.password != null && p.password != oldPwd) {
      _error('Password lama tidak cocok');
      return;
    }
    if (newPwd.length < 6) {
      _error('Password minimal 6 karakter');
      return;
    }
    if (newPwd != confirm) {
      _error('Konfirmasi password tidak sama');
      return;
    }

    try {
      isSubmitting.value = true;
      final result = await pendudukRepo.updatePendudukPassword(
        p.idPenduduk!,
        newPwd,
      );

      if (result['success'] == true) {
        final updated = result['penduduk'] as PendudukModel;
        if (Get.isRegistered<PendudukModel>()) {
          Get.delete<PendudukModel>(force: true);
        }
        Get.put(updated, permanent: true);
        _resetForm();
        Get.back();
        _success('Password berhasil diperbarui');
      } else {
        _error(result['message'] ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      _error(e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  void _resetForm() {
    oldPasswordCtrl.clear();
    newPasswordCtrl.clear();
    confirmPasswordCtrl.clear();
    showOld.value = false;
    showNew.value = false;
    showConfirm.value = false;
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

  @override
  void onClose() {
    oldPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}