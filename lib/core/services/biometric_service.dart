import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

enum AppBiometricType { fingerprint, none }

class BiometricResult {
  final bool success;
  final String? errorMessage;
  final String? errorCode;

  const BiometricResult({
    required this.success,
    this.errorMessage,
    this.errorCode,
  });

  factory BiometricResult.success() => const BiometricResult(success: true);
  factory BiometricResult.failed(String message, {String? code}) =>
      BiometricResult(success: false, errorMessage: message, errorCode: code);
}

enum BiometricDeviceStatus { available, notEnrolled, notSupported }

class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  factory BiometricService() => _instance;
  BiometricService._internal();

  final LocalAuthentication _auth = LocalAuthentication();

  Future<BiometricDeviceStatus> getDeviceStatus() async {
    try {
      final isSupported = await _auth.isDeviceSupported();
      if (!isSupported) return BiometricDeviceStatus.notSupported;

      final canCheck = await _auth.canCheckBiometrics;
      if (!canCheck) return BiometricDeviceStatus.notSupported;

      final available = await _auth.getAvailableBiometrics();

      final hasFingerprint = available.contains(BiometricType.fingerprint) ||
          available.contains(BiometricType.strong) ||
          available.contains(BiometricType.weak);

      if (!hasFingerprint) return BiometricDeviceStatus.notEnrolled;

      return BiometricDeviceStatus.available;
    } catch (_) {
      return BiometricDeviceStatus.notSupported;
    }
  }

  Future<bool> isAvailable() async {
    final status = await getDeviceStatus();
    return status == BiometricDeviceStatus.available;
  }

  Future<List<AppBiometricType>> getAvailableTypes() async {
    try {
      final available = await _auth.getAvailableBiometrics();

      final hasFingerprint = available.contains(BiometricType.fingerprint) ||
          available.contains(BiometricType.strong) ||
          available.contains(BiometricType.weak);

      return hasFingerprint
          ? [AppBiometricType.fingerprint]
          : [AppBiometricType.none];
    } catch (_) {
      return [AppBiometricType.none];
    }
  }

  Future<AppBiometricType> getPrimaryType() async {
    final types = await getAvailableTypes();
    if (types.contains(AppBiometricType.fingerprint)) {
      return AppBiometricType.fingerprint;
    }
    return AppBiometricType.none;
  }

  String getTypeLabel(AppBiometricType type) {
    switch (type) {
      case AppBiometricType.fingerprint:
        return 'Sidik Jari';
      case AppBiometricType.none:
        return 'Biometrik';
    }
  }

  String getTypeIcon(AppBiometricType type) {
    switch (type) {
      case AppBiometricType.fingerprint:
        return '👆';
      case AppBiometricType.none:
        return '🔒';
    }
  }

  Future<String> getShortLabel() async {
    final type = await getPrimaryType();
    switch (type) {
      case AppBiometricType.fingerprint:
        return 'Sidik Jari';
      case AppBiometricType.none:
        return 'Tidak tersedia';
    }
  }

  Future<String> getStatusMessage() async {
    final status = await getDeviceStatus();
    switch (status) {
      case BiometricDeviceStatus.available:
        return 'Login dengan sidik jari';
      case BiometricDeviceStatus.notEnrolled:
        return 'Daftarkan fingerprint di Pengaturan perangkat';
      case BiometricDeviceStatus.notSupported:
        return 'Tidak didukung perangkat ini';
    }
  }

  Future<BiometricResult> authenticate({
    String reason = 'Verifikasi identitas Anda',
  }) async {
    try {
      final ok = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      return ok
          ? BiometricResult.success()
          : BiometricResult.failed('Verifikasi dibatalkan');
    } on PlatformException catch (e) {
      String msg;
      switch (e.code) {
        case auth_error.notAvailable:
          msg = 'Fingerprint tidak tersedia di perangkat ini';
          break;
        case auth_error.notEnrolled:
          msg = 'Belum ada fingerprint terdaftar.\n'
              'Daftarkan sidik jari di Pengaturan perangkat.';
          break;
        case auth_error.lockedOut:
        case auth_error.permanentlyLockedOut:
          msg = 'Terlalu banyak percobaan gagal. Coba lagi nanti.';
          break;
        case auth_error.passcodeNotSet:
          msg = 'Kunci layar perangkat belum diatur';
          break;
        default:
          msg = 'Verifikasi gagal: ${e.message ?? e.code}';
      }
      return BiometricResult.failed(msg, code: e.code);
    } catch (e) {
      return BiometricResult.failed(e.toString());
    }
  }
}