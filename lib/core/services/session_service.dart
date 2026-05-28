import '../../data/providers/storage_provider.dart';

class SessionService {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  final _storage = StorageProvider();

  static const _kLoggedUser    = 'logged_user';
  static const _kRememberLogin = 'remember_login';

  String _keyBiometric(String nik)  => 'biometric_$nik';
  String _keyFingerprint(String nik) => 'fingerprint_$nik';
  String _keyLoggedOut(String nik)   => 'logged_out_$nik';

  Future<void> saveLoggedUser({
    required String nik,
    required String nama,
    required bool isAdmin,
    int? idPenduduk,
    String? fotoUrl,
  }) async {
    await _storage.write(_kLoggedUser, {
      'nik': nik,
      'nama': nama,
      'is_admin': isAdmin,
      'id_penduduk': idPenduduk,
      'foto_url': fotoUrl,
    });
  }

  Map<String, dynamic>? get loggedUser =>
      _storage.read<Map<String, dynamic>>(_kLoggedUser);

  bool get hasSession => loggedUser != null;
  bool get isAdmin    => loggedUser?['is_admin'] == true;
  String get _currentNik => loggedUser?['nik'] ?? '';

  bool get biometricEnabled =>
      _storage.read<bool>(_keyBiometric(_currentNik)) ?? false;

  Future<void> setBiometricEnabled(bool value) =>
      _storage.write(_keyBiometric(_currentNik), value);

  bool get fingerprintEnabled =>
      _storage.read<bool>(_keyFingerprint(_currentNik)) ?? false;

  Future<void> setFingerprintEnabled(bool value) =>
      _storage.write(_keyFingerprint(_currentNik), value);

  bool get isExplicitlyLoggedOut =>
      _storage.read<bool>(_keyLoggedOut(_currentNik)) ?? false;

  Future<void> setExplicitlyLoggedOut(bool value) =>
      _storage.write(_keyLoggedOut(_currentNik), value);

  bool get rememberLogin =>
      _storage.read<bool>(_kRememberLogin) ?? true;

  Future<void> setRememberLogin(bool value) =>
      _storage.write(_kRememberLogin, value);

  Future<void> clearSession() async {
    await _storage.clearAll();
  }
}