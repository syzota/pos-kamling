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

  // ── Form controllers ──
  final nikCtrl = TextEditingController();
  final namaCtrl = TextEditingController();
  final tempatLahirCtrl = TextEditingController();
  final namaAyahIbuCtrl = TextEditingController();

  // ── Reactive dropdowns ──
  var selectedJenisKelamin = Rx<String?>('Laki-laki');
  var selectedStatusPerkawinan = Rx<String?>(null);
  var selectedAgama = Rx<String?>(null);
  var selectedGolonganDarah = Rx<String?>(null);
  var selectedPendidikan = Rx<String?>(null);
  var selectedPekerjaan = Rx<String?>(null);
  var selectedDisabilitas = Rx<String?>(null);
  var selectedTanggalLahir = Rx<DateTime?>(null);

  static const jenisKelaminOptions = ['Laki-laki', 'Perempuan'];

  static const agamaOptions = [
    'Islam', 'Kristen', 'Katolik',
    'Hindu', 'Buddha', 'Konghucu','Lainnya',
  ];

  static const statusPerkawinanOptions = [
    'Belum Kawin', 'Kawin', 'Cerai Hidup', 'Cerai Mati',
  ];

  static const golonganDarahOptions = ['A', 'B', 'AB', 'O', '-'];

  static const pendidikanOptions = [
    'Tidak Sekolah',
    'SD / Sederajat',
    'SMP / Sederajat',
    'SMA / Sederajat',
    'D1 / D2 / D3',
    'S1 / D4',
    'S2',
    'S3',
  ];

  static const pekerjaanOptions = [
    'Belum/Tidak Bekerja',
    'Pelajar/Mahasiswa',
    'Pegawai Negeri Sipil (PNS)',
    'TNI/Polri',
    'Pegawai Swasta',
    'Wiraswasta',
    'Petani/Pekebun',
    'Nelayan',
    'Buruh',
    'Guru/Dosen',
    'Dokter/Tenaga Medis',
    'Pengacara',
    'Akuntan',
    'Arsitek',
    'Programmer/IT',
    'Seniman',
    'Ibu Rumah Tangga',
    'Pensiunan',
    'Lainnya',
  ];

  static const disabilitasOptions = [
    'Tidak Ada',
    'Tunanetra',
    'Tunarungu',
    'Tunawicara',
    'Tunadaksa',
    'Tunagrahita',
    'Lainnya',
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

  static final _nikPattern = RegExp(r'^\d{16}$');
  static final _namaPattern = RegExp(r"^[a-zA-Z\s'.,-]+$");
  static final _tempatLahirPattern = RegExp(r'^[a-zA-Z\s,.-]+$');

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
    namaAyahIbuCtrl.dispose();
    super.onClose();
  }

  Future<void> loadResidents() async {
    isLoading.value = true;
    try {
      final data = await SupabaseProvider.pendudukTable
          .select()
          .order('nama');
      residents.value =
          (data as List).map((e) => PendudukModel.fromJson(e)).toList();
      _applyFilter();
    } catch (e) {
      _snackError('Gagal memuat data warga: $e');
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
    Get.toNamed(AppRoutes.adminResidentsForm);
  }

  void openEdit(PendudukModel r) {
    selectedResident.value = r;
    nikCtrl.text = r.nik ?? '';
    namaCtrl.text = r.nama ?? '';
    tempatLahirCtrl.text = r.tempatLahir ?? '';
    namaAyahIbuCtrl.text = r.namaAyahIbu ?? '';
    selectedTanggalLahir.value = r.tanggalLahir;
    selectedJenisKelamin.value = r.jenisKelamin ?? 'Laki-laki';
    selectedAgama.value = agamaOptions.contains(r.agama) ? r.agama : null;
    selectedGolonganDarah.value =
        golonganDarahOptions.contains(r.golonganDarah) ? r.golonganDarah : null;
    selectedPendidikan.value =
        pendidikanOptions.contains(r.pendidikanTerakhir) ? r.pendidikanTerakhir : null;
    selectedPekerjaan.value =
        pekerjaanOptions.contains(r.pekerjaan) ? r.pekerjaan : null;
    selectedDisabilitas.value =
        disabilitasOptions.contains(r.disabilitas) ? r.disabilitas : 'Tidak Ada';
    selectedStatusPerkawinan.value =
        statusPerkawinanOptions.any(
          (o) => o.toLowerCase() == r.statusPerkawinan?.toLowerCase(),
        )
            ? statusPerkawinanOptions.firstWhere(
                (o) => o.toLowerCase() == r.statusPerkawinan?.toLowerCase(),
              )
            : null;
    Get.toNamed(AppRoutes.adminResidentsForm);
  }

  void openDetail(PendudukModel r) {
    selectedResident.value = r;
    Get.toNamed(AppRoutes.adminResidentsDetail);
  }

  String? _validateNik(String nik) {
    if (nik.trim().isEmpty) return 'NIK wajib diisi';
    if (!_nikPattern.hasMatch(nik.trim())) return 'NIK harus 16 digit angka';
    return null;
  }

  String? _validateNama(String nama) {
    final t = nama.trim();
    if (t.isEmpty) return 'Nama wajib diisi';
    if (t.length < 3) return 'Nama minimal 3 karakter';
    if (t.length > 100) return 'Nama maksimal 100 karakter';
    if (_invalidPattern.hasMatch(t)) return 'Nama tidak boleh mengandung emoji';
    if (!_namaPattern.hasMatch(t)) {
      return 'Nama hanya boleh huruf, spasi, dan tanda baca umum';
    }
    return null;
  }

  String? _validateTempatLahir(String tempat) {
    if (tempat.trim().isEmpty) return null;
    final t = tempat.trim();
    if (_invalidPattern.hasMatch(t)) {
      return 'Tempat lahir tidak boleh mengandung emoji';
    }
    if (!_tempatLahirPattern.hasMatch(t)) {
      return 'Tempat lahir hanya boleh huruf dan tanda baca umum';
    }
    return null;
  }

  String? _validateNamaAyahIbu(String nama) {
    if (nama.trim().isEmpty) return null;
    final t = nama.trim();
    if (_invalidPattern.hasMatch(t)) {
      return 'Nama ayah/ibu tidak boleh mengandung emoji';
    }
    if (!_namaPattern.hasMatch(t)) {
      return 'Nama ayah/ibu hanya boleh huruf dan tanda baca umum';
    }
    return null;
  }

  Future<void> saveResident() async {
    final nikError = _validateNik(nikCtrl.text);
    if (nikError != null) { _snackWarning(nikError); return; }

    final namaError = _validateNama(namaCtrl.text);
    if (namaError != null) { _snackWarning(namaError); return; }

    final tempatError = _validateTempatLahir(tempatLahirCtrl.text);
    if (tempatError != null) { _snackWarning(tempatError); return; }

    final ayahIbuError = _validateNamaAyahIbu(namaAyahIbuCtrl.text);
    if (ayahIbuError != null) { _snackWarning(ayahIbuError); return; }

    if (selectedJenisKelamin.value == null) {
      _snackWarning('Jenis kelamin wajib dipilih'); return;
    }
    if (selectedStatusPerkawinan.value == null) {
      _snackWarning('Status perkawinan wajib dipilih'); return;
    }
    if (selectedAgama.value == null) {
      _snackWarning('Agama wajib dipilih'); return;
    }

    isSubmitting.value = true;

    try {
      final nik = nikCtrl.text.trim();

      final existing = await SupabaseProvider.pendudukTable
          .select()
          .eq('nik', nik);

      final isDuplicate = (existing as List).isNotEmpty &&
          selectedResident.value == null;

      if (isDuplicate) {
        _snackWarning('NIK sudah terdaftar, gunakan NIK lain');
        isSubmitting.value = false;
        return;
      }

      final data = {
        'nik': nik,
        'nama': namaCtrl.text.trim(),
        'tempat_lahir': tempatLahirCtrl.text.trim().isEmpty
            ? null
            : tempatLahirCtrl.text.trim(),
        if (selectedTanggalLahir.value != null)
          'tanggal_lahir': selectedTanggalLahir.value!
              .toIso8601String()
              .split('T')
              .first,
        'umur': selectedTanggalLahir.value != null
            ? _hitungUmur(selectedTanggalLahir.value!)
            : null,
        'jenis_kelamin': selectedJenisKelamin.value,
        'status_perkawinan': selectedStatusPerkawinan.value?.toLowerCase(),
        'agama': selectedAgama.value,
        'golongan_darah': selectedGolonganDarah.value,
        'pendidikan_terakhir': selectedPendidikan.value,
        'pekerjaan': selectedPekerjaan.value,
        'nama_ayah_ibu': namaAyahIbuCtrl.text.trim().isEmpty
            ? null
            : namaAyahIbuCtrl.text.trim(),
        'disabilitas': selectedDisabilitas.value ?? 'Tidak Ada',
      };

      if (selectedResident.value == null) {
        await SupabaseProvider.pendudukTable.insert(data);
        _snackSuccess('Data warga berhasil ditambahkan');
      } else {
        await SupabaseProvider.pendudukTable
            .update(data)
            .eq('id_penduduk', selectedResident.value!.idPenduduk!);
        _snackSuccess('Data warga berhasil diperbarui');
      }

      Get.offAllNamed(AppRoutes.adminResidents);
      await loadResidents();
    } catch (e) {
      _snackError('Gagal menyimpan data: $e');
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
      await SupabaseProvider.pendudukTable
          .delete()
          .eq('id_penduduk', r.idPenduduk!);
      _snackSuccess('Data warga berhasil dihapus');
      await loadResidents();
    } catch (e) {
      _snackError('Gagal menghapus data: $e');
    }
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
    }
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

  void _clearForm() {
    nikCtrl.clear();
    namaCtrl.clear();
    tempatLahirCtrl.clear();
    namaAyahIbuCtrl.clear();
    selectedJenisKelamin.value = 'Laki-laki';
    selectedStatusPerkawinan.value = null;
    selectedAgama.value = null;
    selectedGolonganDarah.value = null;
    selectedPendidikan.value = null;
    selectedPekerjaan.value = null;
    selectedDisabilitas.value = 'Tidak Ada';
    selectedTanggalLahir.value = null;
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