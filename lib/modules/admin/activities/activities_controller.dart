import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'activities_view.dart';
import '../../../app/routes/app_routes.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/supabase_provider.dart';
import '../../../data/repositories/kegiatan_repository.dart';
import '../../../core/constants/app_constants.dart';

class ActivitiesController extends GetxController {
  final KegiatanRepository kegiatanRepo;
  ActivitiesController({required this.kegiatanRepo});

  var activities = <KegiatanModel>[].obs;
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var selectedActivity = Rx<KegiatanModel?>(null);

  // ✅ IMAGE
  var selectedImage = Rx<File?>(null);
  final picker = ImagePicker();

  // FORM
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

  // ================= LOAD DATA =================
  Future<void> loadActivities() async {
    isLoading.value = true;
    try {
      final data = await SupabaseProvider.kegiatanTable.select().order(
        'tanggal',
        ascending: false,
      );

      activities.value = (data as List)
          .map((e) => KegiatanModel.fromJson(e))
          .toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data kegiatan: $e',
        backgroundColor: const Color(0xFFFFEDED),
      );
    }
    isLoading.value = false;
  }

  // ================= IMAGE =================
  Future<String?> uploadImage() async {
    if (selectedImage.value == null) return null;

    try {
      final file = selectedImage.value!;
      final userId = SupabaseProvider.client.auth.currentUser?.id ?? 'guest';

      final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await SupabaseProvider.client.storage
          .from('kegiatan')
          .upload(fileName, file);

      final imageUrl = SupabaseProvider.client.storage
          .from('kegiatan')
          .getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      Get.snackbar('Error', 'Upload gambar gagal: $e');
      return null;
    }
  }

  // ================= NAVIGATION =================
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
    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  // ================= PICK DATE TIME =================
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

  // ================= SAVE =================
  Future<void> saveActivity() async {
    isSubmitting.value = true;

    final waktuStr =
        '${selectedWaktu.value.hour.toString().padLeft(2, '0')}:${selectedWaktu.value.minute.toString().padLeft(2, '0')}:00';

    try {
      String? imageUrl;

      // ✅ Upload hanya kalau ada gambar baru
      if (selectedImage.value != null) {
        imageUrl = await uploadImage();
      }

      // ✅ Kalau edit & tidak upload → pakai foto lama
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
        'foto': imageUrl, // ✅ tetap masuk walaupun null (opsional)
      };
      ("UPLOAD IMAGE: $imageUrl");

      if (selectedActivity.value == null) {
        await SupabaseProvider.kegiatanTable.insert(data);

        Get.snackbar(
          'Berhasil',
          'Kegiatan berhasil ditambahkan',
          backgroundColor: const Color(0xFFE8F5E9),
        );
      } else {
        await SupabaseProvider.kegiatanTable
            .update(data)
            .eq('id_kegiatan', selectedActivity.value!.idKegiatan!);

        Get.snackbar(
          'Berhasil',
          'Kegiatan berhasil diperbarui',
          backgroundColor: const Color(0xFFE8F5E9),
        );
      }

      Get.back();
      await loadActivities();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan: $e',
        backgroundColor: const Color(0xFFFFEDED),
      );
    }

    isSubmitting.value = false;
  }

  // ================= DELETE =================
  Future<void> deleteActivity(KegiatanModel k) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Kegiatan'),
        content: Text('Yakin ingin menghapus "${k.namaKegiatan}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await SupabaseProvider.kegiatanTable.delete().eq(
        'id_kegiatan',
        k.idKegiatan!,
      );

      Get.snackbar(
        'Berhasil',
        'Kegiatan dihapus',
        backgroundColor: const Color(0xFFE8F5E9),
      );

      await loadActivities();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus: $e',
        backgroundColor: const Color(0xFFFFEDED),
      );
    }
  }

  // ================= RESET =================
  void _clearForm() {
    namaCtrl.clear();
    jenisCtrl.clear();
    lokasiCtrl.clear();
    deskripsiCtrl.clear();
    selectedTanggal.value = DateTime.now();
    selectedWaktu.value = const TimeOfDay(hour: 8, minute: 0);
    selectedImage.value = null;
  }

  // ================= COLOR =================
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
}
