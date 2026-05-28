import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../app/routes/app_routes.dart';
import '../../core/services/session_service.dart';
import '../../data/models/models.dart';
import '../../data/providers/storage_provider.dart';
import '../../data/providers/supabase_provider.dart';
import '../../data/repositories/penduduk_repository.dart';

class ProfileController extends GetxController {
  final PendudukRepository pendudukRepo;
  ProfileController({required this.pendudukRepo});

  final _session = SessionService();
  final _storage = StorageProvider();
  final _picker  = ImagePicker();

  final pendudukRx       = Rxn<PendudukModel>();
  final photoFileRx      = Rxn<File>();
  final isLoading        = false.obs;
  final isUploadingPhoto = false.obs;

  PendudukModel? get penduduk => pendudukRx.value;
  bool   get isAdmin      => _session.isAdmin;
  String get displayName  =>
      penduduk?.nama ?? _session.loggedUser?['nama']?.toString() ?? 'User';
  String get displayNik   => penduduk?.nik ?? '-';
  String get roleLabel    => isAdmin ? 'Administrator' : 'Warga';

  @override
  void onInit() {
    super.onInit();
    _loadFromGet();
    _loadCachedPhoto();
  }

  void _loadFromGet() {
    if (Get.isRegistered<PendudukModel>()) {
      pendudukRx.value = Get.find<PendudukModel>();
    }
  }

  Future<void> _loadCachedPhoto() async {
    if (kIsWeb) return;
    final id = penduduk?.idPenduduk;
    if (id == null) return;
    final path = _storage.read<String>('profile_photo_$id');
    if (path == null) return;
    try {
      final f = File(path);
      if (f.existsSync()) photoFileRx.value = f;
    } catch (_) {}
  }

  Future<void> refresh() async {
    final id = penduduk?.idPenduduk;
    if (id == null) return;
    isLoading.value = true;
    try {
      final fresh = await pendudukRepo.getPendudukById(id);
      if (fresh != null) {
        if (Get.isRegistered<PendudukModel>()) {
          Get.delete<PendudukModel>(force: true);
        }
        Get.put(fresh, permanent: true);
        pendudukRx.value = fresh;
        photoFileRx.value = null;
      }
    } catch (_) {} finally {
      isLoading.value = false;
    }
  }

  Future<void> pickFromCamera()  => _pickPhoto(ImageSource.camera);
  Future<void> pickFromGallery() => _pickPhoto(ImageSource.gallery);

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );
      if (picked == null) return;
      if (kIsWeb) return;

      final tempDir  = await getTemporaryDirectory();
      final ext      = picked.path.split('.').last.toLowerCase();
      final fileName =
          'profile_temp_${DateTime.now().millisecondsSinceEpoch}.$ext';
      final tempFile = File('${tempDir.path}/$fileName');
      await File(picked.path).copy(tempFile.path);

      photoFileRx.value      = tempFile;
      isUploadingPhoto.value = true;

      final url = await _uploadFoto(tempFile);

      if (url != null) {
        await _saveFotoUrl(url);
        final id = penduduk?.idPenduduk;
        if (id != null) {
          await _storage.write('profile_photo_$id', tempFile.path);
        }
        _snackSuccess('Foto profil berhasil diperbarui');
      } else {
        photoFileRx.value = null;
        _snackError('Upload foto gagal, coba lagi');
      }
    } catch (e) {
      photoFileRx.value = null;
      _snackError('Tidak bisa memuat foto: $e');
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  Future<String?> _uploadFoto(File file) async {
    try {
      final id = penduduk?.idPenduduk;
      if (id == null) return null;

      final ext      = file.path.split('.').last.toLowerCase();
      final fileName = 'profile_$id.$ext';

      try {
        await SupabaseProvider.client.storage
            .from('profil')
            .upload(fileName, file);
      } catch (_) {
        await SupabaseProvider.client.storage
            .from('profil')
            .update(fileName, file);
      }

      final url = SupabaseProvider.client.storage
          .from('profil')
          .getPublicUrl(fileName);

      return '$url?t=${DateTime.now().millisecondsSinceEpoch}';
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveFotoUrl(String url) async {
    try {
      final id = penduduk?.idPenduduk;
      if (id == null) return;

      await SupabaseProvider.pendudukTable
          .update({'foto_url': url})
          .eq('id_penduduk', id);

      final updated = penduduk?.copyWith(fotoUrl: url);
      if (updated != null) {
        if (Get.isRegistered<PendudukModel>()) {
          Get.delete<PendudukModel>(force: true);
        }
        Get.put(updated, permanent: true);
        pendudukRx.value = updated;
      }
    } catch (_) {}
  }

  void goToEditProfile()          => Get.toNamed(AppRoutes.editProfile);
  void goToSecurity()             => Get.toNamed(AppRoutes.security);
  void goToNotificationSettings() => Get.toNamed(
        isAdmin ? AppRoutes.adminNotification : AppRoutes.wargaNotification,
      );
  void goToManageResidents()      => Get.toNamed(AppRoutes.adminResidents);
  void goToManageAnnouncement()   => Get.toNamed(AppRoutes.adminAnnouncement);

  Future<void> logout() async {
    await _session.setExplicitlyLoggedOut(true);
    await _session.clearSession();

    if (Get.isRegistered<PendudukModel>()) {
      Get.delete<PendudukModel>(force: true);
    }

    Get.offAllNamed(AppRoutes.login);
  }

  void _snackSuccess(String msg) => Get.snackbar(
        'Berhasil', msg,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFE8F5E9),
        colorText: const Color(0xFF1B5E20),
        icon: const Icon(Icons.check_circle_rounded,
            color: Color(0xFF1B5E20)),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );

  void _snackError(String msg) => Get.snackbar(
        'Gagal', msg,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFFFEDED),
        colorText: const Color(0xFFB71C1C),
        icon: const Icon(Icons.error_rounded, color: Color(0xFFB71C1C)),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
}