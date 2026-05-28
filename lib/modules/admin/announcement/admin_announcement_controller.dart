import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/notifikasi_repository.dart';
import '../../../data/repositories/pengumuman_repository.dart';
import '../../../data/providers/supabase_provider.dart';

class AnnouncementModel {
  final String id;
  final String judul;
  final String isi;
  final String kategori;
  final DateTime? createdAt;

  AnnouncementModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    this.createdAt,
  });
}

class AdminAnnouncementController extends GetxController {
  final PengumumanRepository pengumumanRepo;
  final NotifikasiRepository notifikasiRepo;

  AdminAnnouncementController({
    required this.pengumumanRepo,
    required this.notifikasiRepo,
  });

  final isLoading = false.obs;
  final announcements = <AnnouncementModel>[].obs;
  final selectedFilter = 'Semua'.obs;

  final judulController = TextEditingController();
  final isiController = TextEditingController();
  final selectedKategori = 'Umum'.obs;

  final List<String> kategoriList = [
    'Semua',
    'Umum',
    'Kesehatan',
    'Keamanan',
    'Kegiatan',
    'Keuangan',
    'Darurat',
  ];

  static final _invalidPattern = RegExp(
    r'['
    r'\u{1F000}-\u{1FFFF}'
    r'\u{2600}-\u{27BF}'
    r'\u{2300}-\u{23FF}'
    r'\u{2B00}-\u{2BFF}'
    r'\u{FE00}-\u{FE0F}'
    r'\u{E0000}-\u{E007F}'
    r'\u{200B}-\u{200F}'
    r'\u{FEFF}'
    r']',
    unicode: true,
  );

  late final TextInputFormatter _emojiBlocker =
      TextInputFormatter.withFunction((oldValue, newValue) {
    final cleaned = newValue.text.replaceAll(_invalidPattern, '');
    if (cleaned == newValue.text) return newValue;
    return newValue.copyWith(
      text: cleaned,
      selection: TextSelection.collapsed(offset: cleaned.length),
    );
  });

  String? _validateField(
    String value,
    String fieldName, {
    int minLength = 10,
    int maxLength = 500,
  }) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '$fieldName wajib diisi';
    if (trimmed.length < minLength) return '$fieldName minimal $minLength karakter';
    if (trimmed.length > maxLength) return '$fieldName maksimal $maxLength karakter';
    if (_invalidPattern.hasMatch(trimmed)) {
      return '$fieldName tidak boleh mengandung emoji atau simbol';
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    loadAnnouncements();
  }

  @override
  void onClose() {
    judulController.dispose();
    isiController.dispose();
    super.onClose();
  }

  Future<void> loadAnnouncements() async {
    try {
      isLoading.value = true;
      final items = await pengumumanRepo.getAllPengumuman();
      announcements.assignAll(items.map(_map).toList());
    } catch (e) {
      announcements.clear();
      _snack("Error", e.toString(), false);
    } finally {
      isLoading.value = false;
    }
  }

  List<AnnouncementModel> get filteredAnnouncements {
    if (selectedFilter.value == 'Semua') return announcements;
    return announcements.where((a) {
      return a.kategori.toLowerCase() == selectedFilter.value.toLowerCase();
    }).toList();
  }

  void openCreate() {
    _resetForm();
    Get.bottomSheet(
      _buildFormSheet(title: "Buat Pengumuman", onSave: tambahPengumuman),
      isScrollControlled: true,
    );
  }

  void openEdit(AnnouncementModel item) {
    judulController.text = item.judul;
    isiController.text = item.isi;
    selectedKategori.value = item.kategori;

    Get.bottomSheet(
      _buildFormSheet(
        title: "Edit Pengumuman",
        onSave: () => editPengumuman(item.id),
        saveLabel: "Simpan Perubahan",
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildFormSheet({
    required String title,
    required VoidCallback onSave,
    String saveLabel = "Simpan",
  }) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: judulController,
              maxLength: 100,
              inputFormatters: [_emojiBlocker],
              decoration: const InputDecoration(
                labelText: "Judul (min. 10 karakter)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title_rounded),
                counterText: '',
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: isiController,
              maxLines: 4,
              maxLength: 1000,
              inputFormatters: [_emojiBlocker],
              decoration: const InputDecoration(
                labelText: "Isi Pengumuman (min. 10 karakter)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes_rounded),
              ),
            ),
            const SizedBox(height: 12),

            Obx(() => DropdownButtonFormField<String>(
              value: selectedKategori.value,
              items: kategoriList
                  .where((k) => k != 'Semua')
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (val) {
                if (val != null) selectedKategori.value = val;
              },
              decoration: const InputDecoration(
                labelText: "Kategori",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category_rounded),
              ),
            )),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onSave,
                icon: const Icon(Icons.check_rounded),
                label: Text(saveLabel),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> tambahPengumuman() async {
    final judulError = _validateField(
      judulController.text, 'Judul', minLength: 10, maxLength: 100,
    );
    if (judulError != null) { _snack('Gagal', judulError, false); return; }

    final isiError = _validateField(
      isiController.text, 'Isi pengumuman', minLength: 10, maxLength: 1000,
    );
    if (isiError != null) { _snack('Gagal', isiError, false); return; }

    try {
      isLoading.value = true;
      final newData = PengumumanModel(
        judul: judulController.text.trim(),
        isi: isiController.text.trim(),
        kategori: selectedKategori.value,
      );
      final result = await pengumumanRepo.createPengumuman(newData);
      if (result['success'] == true) {
        await notifikasiRepo.createNotificationForAllUsers(
          judul: "Pengumuman baru",
          isi: 'Pengumuman: ${newData.judul ?? ''}',
          tipe: "pengumuman",
        );
      await _sendPushNotification(
        title: '📢 Pengumuman Baru',
        body: newData.judul ?? '',
        type: 'pengumuman',
      );
        await loadAnnouncements();
        _resetForm();
        Get.back();
        _snack("Berhasil", "Pengumuman dibuat", true);
      } else {
        _snack("Gagal", result['message'], false);
      }
    } catch (e) {
      _snack("Error", e.toString(), false);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editPengumuman(String id) async {
    final judulError = _validateField(
      judulController.text, 'Judul', minLength: 10, maxLength: 100,
    );
    if (judulError != null) { _snack('Gagal', judulError, false); return; }

    final isiError = _validateField(
      isiController.text, 'Isi pengumuman', minLength: 10, maxLength: 1000,
    );
    if (isiError != null) { _snack('Gagal', isiError, false); return; }

    try {
      isLoading.value = true;
      final updatedData = PengumumanModel(
        idPengumuman: int.tryParse(id),
        judul: judulController.text.trim(),
        isi: isiController.text.trim(),
        kategori: selectedKategori.value,
      );
      final result = await pengumumanRepo.updatePengumuman(updatedData);
      if (result['success'] == true) {
        await loadAnnouncements();
        _resetForm();
        Get.back();
        _snack("Berhasil", "Pengumuman diperbarui", true);
      } else {
        _snack("Gagal", result['message'], false);
      }
    } catch (e) {
      _snack("Error", e.toString(), false);
    } finally {
      isLoading.value = false;
    }
  }

  void hapusPengumuman(String id) {
    Get.defaultDialog(
      title: "Hapus",
      middleText: "Yakin ingin menghapus pengumuman ini?",
      textConfirm: "Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        Get.back();
        try {
          isLoading.value = true;
          final result = await pengumumanRepo.deletePengumuman(int.parse(id));
          if (result['success'] == true) {
            announcements.removeWhere((a) => a.id == id);
            _snack("Berhasil", "Berhasil dihapus", true);
          } else {
            _snack("Gagal", result['message'], false);
          }
        } catch (e) {
          _snack("Error", e.toString(), false);
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  void _resetForm() {
    judulController.clear();
    isiController.clear();
    selectedKategori.value = 'Umum';
  }

  void _snack(String title, String msg, bool success) {
    Get.snackbar(
      title, msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: success ? const Color(0xFF43A047) : const Color(0xFFE53935),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  AnnouncementModel _map(PengumumanModel item) {
    return AnnouncementModel(
      id: (item.idPengumuman ?? '').toString(),
      judul: item.judul ?? '',
      isi: item.isi ?? '',
      kategori: item.kategori ?? 'Umum',
      createdAt: item.createdAt,
    );
  }

  Future<void> _sendPushNotification({
    required String title,
    required String body,
    required String type,
  }) async {
    try {
      await SupabaseProvider.client.functions.invoke(
        'send-notification',
        body: {
          'title': title,
          'body': body,
          'data': {'type': type},
        },
      );
    } catch (_) {
      
    }
}
}