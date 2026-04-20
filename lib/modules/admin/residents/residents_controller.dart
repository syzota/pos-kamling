import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/supabase_provider.dart';
import '../../../data/repositories/penduduk_repository.dart';
import '../../../app/routes/app_routes.dart';

class ResidentsController extends GetxController {
  final PendudukRepository pendudukRepo;
  ResidentsController({required this.pendudukRepo});

  var residents = <PendudukModel>[].obs;
  var filteredResidents = <PendudukModel>[].obs;
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var searchQuery = ''.obs;
  var selectedResident = Rx<PendudukModel?>(null);

  // Form controllers
  final nikCtrl = TextEditingController();
  final namaCtrl = TextEditingController();
  final tempatLahirCtrl = TextEditingController();
  final umurCtrl = TextEditingController();
  final agamaCtrl = TextEditingController();
  final golonganDarahCtrl = TextEditingController();
  final pendidikanCtrl = TextEditingController();
  final pekerjaanCtrl = TextEditingController();
  final namaAyahIbuCtrl = TextEditingController();
  final disabilitasCtrl = TextEditingController();

  var selectedJenisKelamin = Rx<String?>('Laki-laki');
  var selectedStatusPerkawinan = Rx<String?>('Belum');
  var selectedTanggalLahir = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    loadResidents();
    debounce(
      searchQuery,
      (_) => _applyFilter(),
      time: const Duration(milliseconds: 300),
    );
  }

  @override
  void onClose() {
    nikCtrl.dispose();
    namaCtrl.dispose();
    tempatLahirCtrl.dispose();
    umurCtrl.dispose();
    agamaCtrl.dispose();
    golonganDarahCtrl.dispose();
    pendidikanCtrl.dispose();
    pekerjaanCtrl.dispose();
    namaAyahIbuCtrl.dispose();
    disabilitasCtrl.dispose();
    super.onClose();
  }

  Future<void> loadResidents() async {
    isLoading.value = true;
    try {
      final data = await SupabaseProvider.pendudukTable.select().order('nama');
      residents.value = (data as List)
          .map((e) => PendudukModel.fromJson(e))
          .toList();
      _applyFilter();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data warga: $e',
        backgroundColor: const Color(0xFFFFEDED),
      );
    }
    isLoading.value = false;
  }

  void _applyFilter() {
    final q = searchQuery.value.toLowerCase();
    if (q.isEmpty) {
      filteredResidents.value = residents;
    } else {
      filteredResidents.value = residents.where((r) {
        return (r.nama?.toLowerCase().contains(q) ?? false) ||
            (r.nik?.contains(q) ?? false) ||
            (r.pekerjaan?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
  }

  void onSearch(String val) => searchQuery.value = val;

  void openAdd() {
    selectedResident.value = null;
    _clearForm();
    Get.toNamed(AppRoutes.adminResidentsForm); // ✅
  }

  void openEdit(PendudukModel r) {
    selectedResident.value = r;
    nikCtrl.text = r.nik ?? '';
    namaCtrl.text = r.nama ?? '';
    tempatLahirCtrl.text = r.tempatLahir ?? '';
    umurCtrl.text = r.umur?.toString() ?? '';
    agamaCtrl.text = r.agama ?? '';
    golonganDarahCtrl.text = r.golonganDarah ?? '';
    pendidikanCtrl.text = r.pendidikanTerakhir ?? '';
    pekerjaanCtrl.text = r.pekerjaan ?? '';
    namaAyahIbuCtrl.text = r.namaAyahIbu ?? '';
    disabilitasCtrl.text = r.disabilitas ?? '';
    selectedJenisKelamin.value = r.jenisKelamin ?? 'Laki-laki';
    selectedStatusPerkawinan.value =
        r.statusPerkawinan?.toLowerCase() ?? 'belum';
    selectedTanggalLahir.value = r.tanggalLahir;
    Get.toNamed(AppRoutes.adminResidentsForm); // ✅
  }

  void openDetail(PendudukModel r) {
    selectedResident.value = r;
    Get.toNamed(AppRoutes.adminResidentsDetail); // ✅
  }

  int _hitungUmur(DateTime tanggalLahir) {
    final now = DateTime.now();
    int umur = now.year - tanggalLahir.year;

    if (now.month < tanggalLahir.month ||
        (now.month == tanggalLahir.month && now.day < tanggalLahir.day)) {
      umur--;
    }

    return umur;
  }

  Future<void> saveResident() async {
    if (namaCtrl.text.isEmpty || nikCtrl.text.isEmpty) {
      Get.snackbar('Perhatian', 'Nama dan NIK wajib diisi');
      return;
    }

    isSubmitting.value = true;

    try {
      final nik = nikCtrl.text.trim();

      // 🔥 CEK NIK DUPLIKAT
      final existing = await SupabaseProvider.pendudukTable.select().eq(
        'nik',
        nik,
      );

      if (existing.isNotEmpty && selectedResident.value == null) {
        Get.snackbar(
          'Peringatan',
          'NIK sudah terdaftar, gunakan NIK lain',
          backgroundColor: const Color(0xFFFFF3CD), // kuning warning
          colorText: Colors.black,
        );
        isSubmitting.value = false;
        return;
      }

      final data = {
        'nik': nik,
        'nama': namaCtrl.text.trim(),
        'tempat_lahir': tempatLahirCtrl.text.trim(),
        if (selectedTanggalLahir.value != null)
          'tanggal_lahir': selectedTanggalLahir.value!
              .toIso8601String()
              .split('T')
              .first,
        'umur': selectedTanggalLahir.value != null
            ? _hitungUmur(selectedTanggalLahir.value!)
            : int.tryParse(umurCtrl.text.trim()),
        'jenis_kelamin': selectedJenisKelamin.value,
        'status_perkawinan': selectedStatusPerkawinan.value
            ?.toLowerCase(), // 🔥 FIX
        'agama': agamaCtrl.text.trim(),
        'golongan_darah': golonganDarahCtrl.text.trim(),
        'pendidikan_terakhir': pendidikanCtrl.text.trim(),
        'pekerjaan': pekerjaanCtrl.text.trim(),
        'nama_ayah_ibu': namaAyahIbuCtrl.text.trim(),
        'disabilitas': disabilitasCtrl.text.trim(),
      };

      if (selectedResident.value == null) {
        await SupabaseProvider.pendudukTable.insert(data);

        Get.snackbar(
          'Berhasil',
          'Data warga berhasil ditambahkan',
          backgroundColor: const Color(0xFFE8F5E9),
          colorText: Colors.black,
        );
      } else {
        await SupabaseProvider.pendudukTable
            .update(data)
            .eq('id_penduduk', selectedResident.value!.idPenduduk!);

        Get.snackbar(
          'Berhasil',
          'Data warga berhasil diperbarui',
          backgroundColor: const Color(0xFFE8F5E9),
          colorText: Colors.black,
        );
      }

      Get.offAllNamed(AppRoutes.adminResidents);

      await loadResidents();
      await loadResidents();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan data: $e',
        backgroundColor: const Color(0xFFFFEDED),
      );
    }

    isSubmitting.value = false;
  }

  Future<void> deleteResident(PendudukModel r) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Data Warga'),
        content: Text('Yakin ingin menghapus data ${r.nama}?'),
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
      await SupabaseProvider.pendudukTable.delete().eq(
        'id_penduduk',
        r.idPenduduk!,
      );
      Get.snackbar(
        'Berhasil',
        'Data warga dihapus',
        backgroundColor: const Color(0xFFE8F5E9),
      );
      await loadResidents();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus data: $e',
        backgroundColor: const Color(0xFFFFEDED),
      );
    }
  }

  void _clearForm() {
    umurCtrl.clear();
    nikCtrl.clear();
    namaCtrl.clear();
    tempatLahirCtrl.clear();
    umurCtrl.clear();
    agamaCtrl.clear();
    golonganDarahCtrl.clear();
    pendidikanCtrl.clear();
    pekerjaanCtrl.clear();
    namaAyahIbuCtrl.clear();
    disabilitasCtrl.clear();
    selectedJenisKelamin.value = 'Laki-laki';
    selectedStatusPerkawinan.value = 'Belum';
    selectedTanggalLahir.value = null;
  }

  Future<void> pickTanggalLahir(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedTanggalLahir.value ?? DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      selectedTanggalLahir.value = picked;

      // 🔥 hitung umur otomatis
      final now = DateTime.now();
      int umur = now.year - picked.year;

      if (now.month < picked.month ||
          (now.month == picked.month && now.day < picked.day)) {
        umur--;
      }

      umurCtrl.text = umur.toString(); // ⬅️ ini wajib
    }
  }
}
