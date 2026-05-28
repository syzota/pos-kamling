import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/session_service.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/supabase_provider.dart';
import '../../../data/repositories/auth_repository.dart';

class LoginController extends GetxController {
  final AuthRepository authRepo;
  LoginController({required this.authRepo});

  final nikCtrl      = TextEditingController();
  final passwordCtrl = TextEditingController();
  final tglLahirCtrl = TextEditingController();

  final _biometric = BiometricService();
  final _session   = SessionService();
  final _notif     = NotificationService();

  final isLoading         = false.obs;
  final isPasswordVisible = false.obs;
  final showFingerprintButton = false.obs;

  void togglePw() => isPasswordVisible.toggle();

  @override
  void onInit() {
    super.onInit();
    _initBiometric();
  }

  Future<void> _initBiometric() async {
    final hasSession = _session.loggedUser != null;
    if (!hasSession) {
      showFingerprintButton.value = false;
      return;
    }

    final settingEnabled = _session.biometricEnabled;
    final isLoggedOut    = _session.isExplicitlyLoggedOut;
    final hwAvailable    = await _biometric.isAvailable();

    showFingerprintButton.value =
        settingEnabled && !isLoggedOut && hwAvailable;
  }

  Future<void> _saveFcmToken(int idPenduduk) async {
    try {
      final token = await _notif.getToken();
      if (token == null) return;

      await SupabaseProvider.client
          .from('penduduk')
          .update({'fcm_token': token})
          .eq('id_penduduk', idPenduduk);

    } catch (_) {
      
    }
  }

  Future<void> loginWithFingerprint() async {
    if (_session.loggedUser == null) {
      _showError('Silakan login manual terlebih dahulu');
      return;
    }

    final available = await _biometric.isAvailable();
    if (!available) {
      _showError('Sidik Jari tidak tersedia di perangkat ini');
      return;
    }

    final result = await _biometric.authenticate(
      reason: 'Login dengan Sidik Jari',
    );

    if (!result.success) {
      _showError(result.errorMessage ?? 'Verifikasi gagal');
      return;
    }

    final session = _session.loggedUser;
    if (session == null) {
      _showError('Sesi tidak ditemukan. Login manual dulu.');
      return;
    }

    try {
      final penduduk = await authRepo.getPendudukByNik(session['nik']);
      if (penduduk == null) {
        _showError('Data tidak ditemukan');
        return;
      }

      if (Get.isRegistered<PendudukModel>()) {
        Get.delete<PendudukModel>(force: true);
      }
      Get.put<PendudukModel>(penduduk, permanent: true);

      await _session.setExplicitlyLoggedOut(false);

      if (penduduk.idPenduduk != null) {
        await _saveFcmToken(penduduk.idPenduduk!);
      }

      final isAdmin = session['is_admin'] == true;
      Get.offAllNamed(
        isAdmin ? AppRoutes.adminDashboard : AppRoutes.wargaDashboard,
      );
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> login() async {
    final nik      = nikCtrl.text.trim();
    final password = passwordCtrl.text;
    final tglText  = tglLahirCtrl.text.trim();

    if (nik.isEmpty || password.isEmpty || tglText.isEmpty) {
      _showError('Semua field wajib diisi');
      return;
    }

    DateTime? tanggalLahir;
    try {
      tanggalLahir = DateFormat('dd/MM/yyyy').parseStrict(tglText);
    } catch (_) {
      _showError('Format tanggal harus DD/MM/YYYY');
      return;
    }

    isLoading.value = true;
    try {
      final result = await authRepo.login(nik, password, tanggalLahir);

      if (result['success'] == true) {
        final penduduk = result['penduduk'] as PendudukModel;
        final isAdmin  = result['isAdmin']  as bool;

        if (Get.isRegistered<PendudukModel>()) {
          Get.delete<PendudukModel>(force: true);
        }
        Get.put(penduduk, permanent: true);

        await _session.saveLoggedUser(
          nik        : penduduk.nik ?? '',
          nama       : penduduk.nama ?? '',
          isAdmin    : isAdmin,
          idPenduduk : penduduk.idPenduduk,
          fotoUrl    : penduduk.fotoUrl,
        );

        await _session.setExplicitlyLoggedOut(false);

        if (penduduk.idPenduduk != null) {
          await _saveFcmToken(penduduk.idPenduduk!);
        }

        Get.offAllNamed(
          isAdmin ? AppRoutes.adminDashboard : AppRoutes.wargaDashboard,
        );
      } else {
        _showError(result['message'] ?? 'Terjadi kesalahan');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String msg) => Get.snackbar(
        'Login', msg,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

  @override
  void onClose() {
    nikCtrl.dispose();
    passwordCtrl.dispose();
    tglLahirCtrl.dispose();
    super.onClose();
  }
}