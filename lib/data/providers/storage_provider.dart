import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageProvider {
  static final StorageProvider _instance = StorageProvider._internal();
  factory StorageProvider() => _instance;
  StorageProvider._internal();

  final _secure = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> saveToken(String token) =>
      _secure.write(key: 'auth_token', value: token);

  Future<String?> getToken() => _secure.read(key: 'auth_token');

  Future<void> saveRole(String role) =>
      _secure.write(key: 'user_role', value: role);

  Future<String?> getRole() => _secure.read(key: 'user_role');

  Future<bool> write(String key, dynamic value) async {
    final p = await prefs;
    if (value == null) return p.remove(key);
    if (value is bool) return p.setBool(key, value);
    if (value is int) return p.setInt(key, value);
    if (value is double) return p.setDouble(key, value);
    if (value is String) return p.setString(key, value);
    if (value is List<String>) return p.setStringList(key, value);
    return p.setString(key, jsonEncode(value));
  }

  T? read<T>(String key) {
    if (_prefs == null) return null;
    final value = _prefs!.get(key);
    if (value == null) return null;

    if (T.toString().contains('Map')) {
      try {
        if (value is String) {
          return jsonDecode(value) as T;
        }
      } catch (_) {
        return null;
      }
    }

    return value as T?;
  }

  Future<bool> remove(String key) async {
    final p = await prefs;
    return p.remove(key);
  }

  Future<void> clearAll() async {
    await _secure.deleteAll();
    final p = await prefs;
    final keysToKeep = {'app_theme_mode', 'biometric_enabled'};
    final allKeys = p.getKeys().toList();
    for (final k in allKeys) {
      if (!keysToKeep.contains(k)) {
        await p.remove(k);
      }
    }
  }

  Future<void> clearAllForce() async {
    await _secure.deleteAll();
    final p = await prefs;
    await p.clear();
  }
}
