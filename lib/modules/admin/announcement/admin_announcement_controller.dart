import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/notifikasi_repository.dart';
import '../../../data/repositories/pengumuman_repository.dart';

class AnnouncementModel {
  final String id;
  final String judul;
  final String isi;
  final String kategori;
  final DateTime? tanggal;

  AnnouncementModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    this.tanggal,
  });
}

class AdminAnnouncementController extends GetxController {
  final PengumumanRepository pengumumanRepo;
  final NotifikasiRepository notifikasiRepo;

  AdminAnnouncementController({
    required this.pengumumanRepo,
    required this.notifikasiRepo,
  });

  // ───── STATE ─────
  final isLoading = false.obs;
  final announcements = <AnnouncementModel>[].obs;

  final selectedFilter = 'Semua'.obs;

  // ───── FORM ─────
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

  // ───── LOAD ─────
  Future<void> loadAnnouncements() async {
    try {
      isLoading.value = true;

      final items = await pengumumanRepo.getAllPengumuman();

      for (var i in items) {
        print("DEBUG TANGGAL: ${i.createdAt}");
        print("DEBUG RAW ITEM: $i");
      }

      announcements.assignAll(items.map(_map).toList());
    } catch (e) {
      announcements.clear();
      _snack("Error", e.toString(), false);
    } finally {
      isLoading.value = false;
    }
  }

  // ───── FILTER ─────
  List<AnnouncementModel> get filteredAnnouncements {
    if (selectedFilter.value == 'Semua') return announcements;

    return announcements.where((a) {
      return a.kategori.toLowerCase() == selectedFilter.value.toLowerCase();
    }).toList();
  }

  // ───── OPEN CREATE ─────
  void openCreate() {
    _resetForm();
    Get.bottomSheet(
      _buildFormSheet(title: "Buat Pengumuman", onSave: tambahPengumuman),
      isScrollControlled: true,
    );
  }

  // ───── OPEN EDIT ─────
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

  // ───── SHARED FORM SHEET ─────
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
            // drag handle
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
              decoration: const InputDecoration(
                labelText: "Judul",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: isiController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Isi Pengumuman",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            Obx(() {
              return DropdownButtonFormField<String>(
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
                ),
              );
            }),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: onSave, child: Text(saveLabel)),
            ),
          ],
        ),
      ),
    );
  }

  // ───── CREATE ─────
  Future<void> tambahPengumuman() async {
    if (judulController.text.trim().isEmpty ||
        isiController.text.trim().isEmpty) {
      _snack("Gagal", "Judul dan isi wajib diisi", false);
      return;
    }

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

  // ───── EDIT ─────
  Future<void> editPengumuman(String id) async {
    if (judulController.text.trim().isEmpty ||
        isiController.text.trim().isEmpty) {
      _snack("Gagal", "Judul dan isi wajib diisi", false);
      return;
    }

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

  // ───── DELETE ─────
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

  // ───── RESET ─────
  void _resetForm() {
    judulController.clear();
    isiController.clear();
    selectedKategori.value = 'Umum';
  }

  // ───── SNACK ─────
  void _snack(String title, String msg, bool success) {
    Get.snackbar(
      title,
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: success
          ? const Color(0xFF43A047)
          : const Color(0xFFE53935),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  // ───── MAPPER ─────
  AnnouncementModel _map(PengumumanModel item) {
    return AnnouncementModel(
      id: (item.idPengumuman ?? '').toString(),
      judul: item.judul ?? '',
      isi: item.isi ?? '',
      kategori: item.kategori ?? 'Umum',
      tanggal: item.createdAt,
    );
  }
}
