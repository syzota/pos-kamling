import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../core/services/session_service.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/penduduk_repository.dart';

class EditProfileController extends GetxController {
  final PendudukRepository pendudukRepo;
  EditProfileController({required this.pendudukRepo});

  final _session = SessionService();
  bool get isAdmin => _session.isAdmin;

  final namaCtrl = TextEditingController();
  final nikCtrl = TextEditingController();
  final tempatLahirCtrl = TextEditingController();
  final tanggalLahirCtrl = TextEditingController();
  final alamatCtrl = TextEditingController();
  final teleponCtrl = TextEditingController();
  final namaAyahIbuCtrl = TextEditingController();

  final jenisKelaminRx = RxnString();
  final agamaRx = RxnString();
  final statusPerkawinanRx = RxnString();
  final golonganDarahRx = RxnString();
  final pendidikanTerakhirRx = RxnString();
  final pekerjaanRx = RxnString();
  final disabilitasRx = RxnString();
  final tanggalLahirRx = Rxn<DateTime>();

  final isSubmitting = false.obs;

  static const jenisKelaminOptions = ['Laki-laki', 'Perempuan'];
  static const agamaOptions = [
    'Islam', 'Kristen', 'Katolik', 'Hindu', 'Buddha', 'Konghucu', 'Lainnya',
  ];
  static const statusPerkawinanOptions = [
    'Belum Kawin', 'Kawin', 'Cerai Hidup', 'Cerai Mati',
  ];
  static const golonganDarahOptions = ['A', 'B', 'AB', 'O', '-'];
  static const pendidikanOptions = [
    'Tidak Sekolah', 'SD / Sederajat', 'SMP / Sederajat',
    'SMA / Sederajat', 'D1 / D2 / D3', 'S1 / D4', 'S2', 'S3',
  ];
  static const pekerjaanOptions = [
    'Belum/Tidak Bekerja', 'Pelajar/Mahasiswa', 'Pegawai Negeri Sipil (PNS)',
    'TNI/Polri', 'Pegawai Swasta', 'Wiraswasta', 'Petani/Pekebun',
    'Nelayan', 'Buruh', 'Guru/Dosen', 'Dokter/Tenaga Medis',
    'Pengacara', 'Akuntan', 'Arsitek', 'Programmer/IT',
    'Seniman', 'Ibu Rumah Tangga', 'Pensiunan', 'Lainnya',
  ];
  static const disabilitasOptions = [
    'Tidak Ada', 'Tunanetra', 'Tunarungu', 'Tunawicara',
    'Tunadaksa', 'Tunagrahita', 'Lainnya',
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

  static final _namaPattern = RegExp(r"^[a-zA-Z\s'.,-]+$");
  static final _tempatPattern = RegExp(r'^[a-zA-Z\s,.-]+$');
  static final _alamatPattern = RegExp(r'^[a-zA-Z0-9\s,.\-/]+$');

  late final TextInputFormatter emojiBlocker =
      TextInputFormatter.withFunction((oldValue, newValue) {
    final cleaned = newValue.text.replaceAll(_invalidPattern, '');
    if (cleaned == newValue.text) return newValue;
    return newValue.copyWith(
      text: cleaned,
      selection: TextSelection.collapsed(offset: cleaned.length),
    );
  });

  String? _validateNama(String value) {
    final t = value.trim();
    if (t.isEmpty) return 'Nama tidak boleh kosong';
    if (t.length < 3) return 'Nama minimal 3 karakter';
    if (t.length > 100) return 'Nama maksimal 100 karakter';
    if (_invalidPattern.hasMatch(t)) return 'Nama tidak boleh mengandung emoji atau simbol';
    if (!_namaPattern.hasMatch(t)) return 'Nama hanya boleh huruf dan tanda baca umum';
    return null;
  }

  String? _validateTempatLahir(String value) {
    if (value.trim().isEmpty) return null;
    final t = value.trim();
    if (_invalidPattern.hasMatch(t)) return 'Tempat lahir tidak boleh mengandung emoji';
    if (!_tempatPattern.hasMatch(t)) return 'Tempat lahir hanya boleh huruf dan tanda baca umum';
    return null;
  }

  String? _validateAlamat(String value) {
    if (value.trim().isEmpty) return null;
    final t = value.trim();
    if (_invalidPattern.hasMatch(t)) return 'Alamat tidak boleh mengandung emoji atau simbol';
    if (t.length > 300) return 'Alamat maksimal 300 karakter';
    return null;
  }

  String? _validateNamaAyahIbu(String value) {
    if (value.trim().isEmpty) return null;
    final t = value.trim();
    if (_invalidPattern.hasMatch(t)) return 'Nama ayah/ibu tidak boleh mengandung emoji';
    if (!_namaPattern.hasMatch(t)) return 'Nama ayah/ibu hanya boleh huruf dan tanda baca umum';
    return null;
  }

  String? _validateTelepon(String value) {
    if (value.trim().isEmpty) return null;
    final t = value.trim();
    final digitsOnly = t.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 6) return 'Nomor telepon minimal 6 angka';
    if (digitsOnly.length > 15) return 'Nomor telepon maksimal 15 angka';
    if (!RegExp(r'^(\+62|62|0)[0-9]{5,14}$').hasMatch(t)) {
      return 'Format tidak valid (contoh: 08xxxxxxxxxx)';
    }
    return null;
  }

  PendudukModel? _penduduk;
  PendudukModel? get penduduk => _penduduk;

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<PendudukModel>()) {
      _penduduk = Get.find<PendudukModel>();
    }
    _populateForm();
  }

  void _populateForm() {
    final p = penduduk;
    if (p == null) return;

    namaCtrl.text = p.nama ?? '';
    nikCtrl.text = p.nik ?? '';
    tempatLahirCtrl.text = p.tempatLahir ?? '';
    alamatCtrl.text = p.alamat ?? '';
    teleponCtrl.text = p.nomorTelepon ?? '';
    namaAyahIbuCtrl.text = p.namaAyahIbu ?? '';

    if (p.tanggalLahir != null) {
      tanggalLahirRx.value = p.tanggalLahir;
      tanggalLahirCtrl.text = DateFormat('dd/MM/yyyy').format(p.tanggalLahir!);
    }

    if (jenisKelaminOptions.contains(p.jenisKelamin)) jenisKelaminRx.value = p.jenisKelamin;
    if (agamaOptions.contains(p.agama)) agamaRx.value = p.agama;
    if (statusPerkawinanOptions.contains(p.statusPerkawinan)) statusPerkawinanRx.value = p.statusPerkawinan;
    if (golonganDarahOptions.contains(p.golonganDarah)) golonganDarahRx.value = p.golonganDarah;
    if (pendidikanOptions.contains(p.pendidikanTerakhir)) pendidikanTerakhirRx.value = p.pendidikanTerakhir;
    if (pekerjaanOptions.contains(p.pekerjaan)) {
      pekerjaanRx.value = p.pekerjaan;
    } else if (p.pekerjaan != null) {
      pekerjaanRx.value = 'Lainnya';
    }
    disabilitasRx.value = disabilitasOptions.contains(p.disabilitas)
        ? p.disabilitas
        : 'Tidak Ada';
  }

  bool get canEditNik => isAdmin;
  bool get canEditNama => isAdmin;
  bool get canEditTempatLahir => isAdmin;
  bool get canEditTanggalLahir => isAdmin;
  bool get canEditJenisKelamin => isAdmin;
  bool get canEditGolonganDarah => isAdmin;
  bool get canEditAlamat => true;
  bool get canEditPekerjaan => true;
  bool get canEditAgama => true;
  bool get canEditTelepon => true;
  bool get canEditStatusPerkawinan => true;
  bool get canEditPendidikan => true;
  bool get canEditNamaAyahIbu => true;
  bool get canEditDisabilitas => true;

  Future<void> pickTanggalLahir(BuildContext context) async {
    if (!canEditTanggalLahir) return;
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalLahirRx.value ?? DateTime(1990),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      tanggalLahirRx.value = picked;
      tanggalLahirCtrl.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Future<void> simpan() async {
    final p = penduduk;
    if (p == null) return;

    // ── Validasi semua field teks ──
    final namaError = _validateNama(namaCtrl.text);
    if (namaError != null) { _error(namaError); return; }

    if (canEditNik && nikCtrl.text.trim().length != 16) {
      _error('NIK harus 16 digit'); return;
    }

    final tempatError = _validateTempatLahir(tempatLahirCtrl.text);
    if (tempatError != null) { _error(tempatError); return; }

    final alamatError = _validateAlamat(alamatCtrl.text);
    if (alamatError != null) { _error(alamatError); return; }

    final teleponError = _validateTelepon(teleponCtrl.text);
    if (teleponError != null) { _error(teleponError); return; }

    final ayahIbuError = _validateNamaAyahIbu(namaAyahIbuCtrl.text);
    if (ayahIbuError != null) { _error(ayahIbuError); return; }

    try {
      isSubmitting.value = true;

      final updated = p.copyWith(
        nama: canEditNama ? namaCtrl.text.trim() : p.nama,
        nik: canEditNik ? nikCtrl.text.trim() : p.nik,
        tempatLahir: canEditTempatLahir ? _trimOrNull(tempatLahirCtrl.text) : p.tempatLahir,
        tanggalLahir: canEditTanggalLahir ? tanggalLahirRx.value : p.tanggalLahir,
        jenisKelamin: canEditJenisKelamin ? jenisKelaminRx.value : p.jenisKelamin,
        golonganDarah: canEditGolonganDarah ? golonganDarahRx.value : p.golonganDarah,
        alamat: _trimOrNull(alamatCtrl.text),
        pekerjaan: pekerjaanRx.value,
        agama: agamaRx.value,
        nomorTelepon: _trimOrNull(teleponCtrl.text),
        statusPerkawinan: statusPerkawinanRx.value,
        pendidikanTerakhir: pendidikanTerakhirRx.value,
        namaAyahIbu: _trimOrNull(namaAyahIbuCtrl.text),
        disabilitas: disabilitasRx.value ?? 'Tidak Ada',
      );

      final result = await pendudukRepo.updatePenduduk(updated);

      if (result['success'] == true) {
        if (Get.isRegistered<PendudukModel>()) {
          Get.delete<PendudukModel>(force: true);
        }
        Get.put(updated, permanent: true);
        Get.back();
        Get.snackbar(
          'Berhasil', 'Profil berhasil diperbarui',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFE8F5E9),
          colorText: const Color(0xFF1B5E20),
          icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF1B5E20)),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        _error(result['message'] ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      _error(e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  String? _trimOrNull(String text) {
    final t = text.trim();
    return t.isEmpty ? null : t;
  }

  void _error(String msg) => Get.snackbar(
    'Gagal', msg,
    snackPosition: SnackPosition.TOP,
    backgroundColor: const Color(0xFFE53935),
    colorText: Colors.white,
    icon: const Icon(Icons.error_rounded, color: Colors.white),
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
  );

  @override
  void onClose() {
    namaCtrl.dispose();
    nikCtrl.dispose();
    tempatLahirCtrl.dispose();
    tanggalLahirCtrl.dispose();
    alamatCtrl.dispose();
    teleponCtrl.dispose();
    namaAyahIbuCtrl.dispose();
    super.onClose();
  }
}