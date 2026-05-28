import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'activities_view.dart';
import '../../../app/routes/app_routes.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/supabase_provider.dart';
import '../../../data/repositories/kegiatan_repository.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/location_service.dart';

class NoEmojiFormatter extends TextInputFormatter {
  static final _blockedPattern = RegExp(
    r'['
    r'\u{1F000}-\u{1FFFF}'
    r'\u{2600}-\u{27BF}'
    r'\u{2300}-\u{23FF}'
    r'\u{2B00}-\u{2BFF}'
    r'\u{FE00}-\u{FE0F}'
    r'\u{E0000}-\u{E007F}'
    r']',
    unicode: true,
  );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final cleaned = newValue.text.replaceAll(_blockedPattern, '');
    if (cleaned == newValue.text) return newValue;
    return newValue.copyWith(
      text: cleaned,
      selection: TextSelection.collapsed(offset: cleaned.length),
    );
  }
}

class ActivitiesController extends GetxController {
  final KegiatanRepository kegiatanRepo;
  ActivitiesController({required this.kegiatanRepo});

  final LocationService _locationService = LocationService();
  var isLoadingLokasi = false.obs;
  var latitudeSelected = Rx<double?>(null);
  var longitudeSelected = Rx<double?>(null);
  var alamatSelected = ''.obs;

  var activities = <KegiatanModel>[].obs;
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var selectedActivity = Rx<KegiatanModel?>(null);

  var selectedImage = Rx<File?>(null);
  final picker = ImagePicker();

  final namaCtrl = TextEditingController();
  final jenisCtrl = TextEditingController();
  final lokasiCtrl = TextEditingController();
  final deskripsiCtrl = TextEditingController();

  var selectedTanggal = DateTime.now().obs;
  var selectedWaktu = const TimeOfDay(hour: 8, minute: 0).obs;

  @override
  void onInit() {
    super.onInit();
    loadActivities();
  }

  @override
  void onClose() {
    namaCtrl.dispose();
    jenisCtrl.dispose();
    lokasiCtrl.dispose();
    deskripsiCtrl.dispose();
    super.onClose();
  }

  Future<void> ambilLokasiOtomatis() async {
    isLoadingLokasi.value = true;
    final position = await _locationService.getLocation();
    if (position == null) {
      isLoadingLokasi.value = false;
      _snackError('Pastikan GPS aktif dan izin lokasi diberikan');
      return;
    }
    final alamat = await _locationService.getAddress(
      position.latitude,
      position.longitude,
    );
    latitudeSelected.value = position.latitude;
    longitudeSelected.value = position.longitude;
    alamatSelected.value = alamat;
    lokasiCtrl.text = alamat;
    isLoadingLokasi.value = false;
  }

  void hapusLokasi() {
    latitudeSelected.value = null;
    longitudeSelected.value = null;
    alamatSelected.value = '';
    lokasiCtrl.clear();
  }

  Future<void> loadActivities() async {
    isLoading.value = true;
    try {
      final data = await SupabaseProvider.kegiatanTable
          .select()
          .order('tanggal', ascending: false);
      activities.value =
          (data as List).map((e) => KegiatanModel.fromJson(e)).toList();
    } catch (e) {
      _snackError('Gagal memuat data kegiatan: $e');
    }
    isLoading.value = false;
  }

  Future<String?> uploadImage() async {
    if (selectedImage.value == null) return null;
    try {
      final file = selectedImage.value!;
      final userId =
          SupabaseProvider.client.auth.currentUser?.id ?? 'guest';
      final fileName =
          '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await SupabaseProvider.client.storage
          .from('kegiatan')
          .upload(fileName, file);
      return SupabaseProvider.client.storage
          .from('kegiatan')
          .getPublicUrl(fileName);
    } catch (e) {
      _snackError('Upload gambar gagal: $e');
      return null;
    }
  }

  void openAdd() {
    selectedActivity.value = null;
    _clearForm();
    Get.to(() => ActivityFormView());
  }

  void openEdit(KegiatanModel k) {
    selectedActivity.value = k;
    namaCtrl.text = k.namaKegiatan ?? '';
    jenisCtrl.text = k.jenisKegiatan ?? '';
    lokasiCtrl.text = k.lokasi ?? '';
    deskripsiCtrl.text = k.deskripsi ?? '';
    selectedTanggal.value = k.tanggal ?? DateTime.now();
    latitudeSelected.value = k.latitude;
    longitudeSelected.value = k.longitude;
    alamatSelected.value = k.lokasi ?? '';
    if (k.waktu != null) {
      final parts = k.waktu!.split(':');
      if (parts.length >= 2) {
        selectedWaktu.value = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 8,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      }
    }
    Get.to(() => ActivityFormView());
  }

  void openDetail(KegiatanModel k) {
    selectedActivity.value = k;
    Get.toNamed(AppRoutes.adminActivitiesDetail);
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) selectedImage.value = File(picked.path);
  }

  Future<void> pickTanggal(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedTanggal.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) selectedTanggal.value = picked;
  }

  Future<void> pickWaktu(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedWaktu.value,
    );
    if (picked != null) selectedWaktu.value = picked;
  }

  static final _invalidCharsPattern = RegExp(
    r'['
    r'\u{1F000}-\u{1FFFF}'
    r'\u{2600}-\u{27BF}'
    r'\u{2300}-\u{23FF}'
    r'\u{2B00}-\u{2BFF}'
    r'\u{FE00}-\u{FE0F}'
    r'\u{E0000}-\u{E007F}'
    r']',
    unicode: true,
  );

  bool _containsInvalidChars(String text) =>
      _invalidCharsPattern.hasMatch(text);

  String? validateNoEmoji(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }
    if (value.trim().length < 3) {
      return '$fieldName minimal 3 karakter';
    }
    if (_containsInvalidChars(value)) {
      return '$fieldName tidak boleh mengandung emoji atau simbol';
    }
    return null;
  }

  Future<void> saveActivity() async {
    final fields = {
      'Nama kegiatan': namaCtrl.text,
      'Jenis kegiatan': jenisCtrl.text,
      'Lokasi': lokasiCtrl.text,
    };

    for (final entry in fields.entries) {
      if (entry.value.trim().isEmpty) {
        _snackWarning('${entry.key} wajib diisi');
        return;
      }
      if (_containsInvalidChars(entry.value)) {
        _snackWarning('${entry.key} tidak boleh mengandung emoji atau simbol');
        return;
      }
    }

    if (_containsInvalidChars(lokasiCtrl.text)) {
      _snackWarning('Lokasi tidak boleh mengandung emoji atau simbol');
      return;
    }

    if (deskripsiCtrl.text.trim().isNotEmpty) {
      if (_containsInvalidChars(deskripsiCtrl.text)) {
        _snackWarning('Deskripsi tidak boleh mengandung emoji atau simbol');
        return;
      }
      if (deskripsiCtrl.text.trim().length > 500) {
        _snackWarning('Deskripsi maksimal 500 karakter');
        return;
      }
    }

    isSubmitting.value = true;

    final waktuStr =
        '${selectedWaktu.value.hour.toString().padLeft(2, '0')}:'
        '${selectedWaktu.value.minute.toString().padLeft(2, '0')}:00';

    try {
      String? imageUrl;
      if (selectedImage.value != null) {
        imageUrl = await uploadImage();
        if (imageUrl == null) {
          isSubmitting.value = false;
          _snackError('Foto gagal diupload');
          return;
        }
      }
      if (imageUrl == null && selectedActivity.value != null) {
        imageUrl = selectedActivity.value!.foto;
      }

      final data = {
        'nama_kegiatan': namaCtrl.text.trim(),
        'jenis_kegiatan': jenisCtrl.text.trim(),
        'tanggal': selectedTanggal.value.toIso8601String().split('T').first,
        'waktu': waktuStr,
        'lokasi': lokasiCtrl.text.trim(),
        'deskripsi': deskripsiCtrl.text.trim(),
        'foto': imageUrl,
        if (latitudeSelected.value != null)
          'latitude': latitudeSelected.value,
        if (longitudeSelected.value != null)
          'longitude': longitudeSelected.value,
      };

      final isEdit = selectedActivity.value != null;

      if (!isEdit) {
        await SupabaseProvider.kegiatanTable.insert(data);
      } else {
        await SupabaseProvider.kegiatanTable
            .update(data)
            .eq('id_kegiatan', selectedActivity.value!.idKegiatan!);
      }

      Get.back();
      await loadActivities();
      _clearForm();
      Get.offNamed(AppRoutes.adminActivities);

      Future.delayed(const Duration(milliseconds: 300), () {
        if (!isEdit) {
          _snackSuccess('Kegiatan berhasil ditambahkan');
        } else {
          _snackSuccess('Kegiatan berhasil diperbarui');
        }
      });
    } catch (e) {
      _snackError('Gagal menyimpan: $e');
    }

    isSubmitting.value = false;
  }

  Future<void> deleteActivity(KegiatanModel k) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Hapus Kegiatan'),
        content: Text('Yakin ingin menghapus "${k.namaKegiatan}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await SupabaseProvider.kegiatanTable
          .delete()
          .eq('id_kegiatan', k.idKegiatan!);
      await loadActivities();
      _snackSuccess('Kegiatan berhasil dihapus');
    } catch (e) {
      _snackError('Gagal menghapus: $e');
    }
  }

  void _clearForm() {
    namaCtrl.clear();
    jenisCtrl.clear();
    lokasiCtrl.clear();
    deskripsiCtrl.clear();
    selectedTanggal.value = DateTime.now();
    selectedWaktu.value = const TimeOfDay(hour: 8, minute: 0);
    selectedImage.value = null;
    selectedActivity.value = null;
    latitudeSelected.value = null;
    longitudeSelected.value = null;
    alamatSelected.value = '';
  }

  Color colorForJenis(String? jenis) {
    if (jenis == null) return AppColors.primary;
    final j = jenis.toLowerCase();
    if (j.contains('sosial') || j.contains('gotong')) {
      return AppColors.tertiary;
    }
    if (j.contains('keamanan') || j.contains('ronda')) {
      return AppColors.error;
    }
    if (j.contains('rapat') || j.contains('musyawarah')) {
      return const Color(0xFFFF9800);
    }
    return AppColors.primary;
  }

  void _snackSuccess(String msg) {
    Get.snackbar(
      'Berhasil', msg,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFE8F5E9),
      colorText: const Color(0xFF1B5E20),
      icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF1B5E20)),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  void _snackError(String msg) {
    Get.snackbar(
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

  void _snackWarning(String msg) {
    Get.snackbar(
      'Perhatian', msg,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFFFF3CD),
      colorText: const Color(0xFF7B5800),
      icon: const Icon(Icons.warning_rounded, color: Color(0xFF7B5800)),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }
}