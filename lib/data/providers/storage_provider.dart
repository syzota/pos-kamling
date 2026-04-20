// lib/data/providers/storage_provider.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageProvider {
  // Inisialisasi storage
  final _storage = const FlutterSecureStorage();

  // Simpan Token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Ambil Token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Simpan Role (Admin atau Warga)
  Future<void> saveRole(String role) async {
    await _storage.write(key: 'user_role', value: role);
  }

  // Ambil Role
  Future<String?> getRole() async {
    return await _storage.read(key: 'user_role');
  }

  // Logout (Hapus semua data)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
