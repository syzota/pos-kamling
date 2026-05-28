import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/routes/app_routes.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/supabase_provider.dart';
import '../../../data/repositories/keuangan_repository.dart';

class AdminFinanceController extends GetxController {
  final KeuanganRepository keuanganRepo;
  AdminFinanceController({required this.keuanganRepo});

  var transactions = <KeuanganModel>[].obs;
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var isManualInput = false.obs;

  var totalPemasukan = 0.0.obs;
  var totalPengeluaran = 0.0.obs;
  var saldo = 0.0.obs;

  var selectedJenis = 'pemasukan'.obs;

  final nominalCtrl = TextEditingController();
  final keteranganCtrl = TextEditingController();
  final tanggalCtrl = TextEditingController();

  DateTime? selectedTanggal;

  final _fmt = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

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

  late final TextInputFormatter emojiBlocker =
      TextInputFormatter.withFunction((oldValue, newValue) {
    final cleaned = newValue.text.replaceAll(_invalidPattern, '');
    if (cleaned == newValue.text) return newValue;
    return newValue.copyWith(
      text: cleaned,
      selection: TextSelection.collapsed(offset: cleaned.length),
    );
  });

  String? _validateKeterangan(String value) {
    final t = value.trim();
    if (t.isEmpty) return 'Keterangan wajib diisi';
    if (t.length < 3) return 'Keterangan minimal 3 karakter';
    if (t.length > 200) return 'Keterangan maksimal 200 karakter';
    if (_invalidPattern.hasMatch(t)) {
      return 'Keterangan tidak boleh mengandung emoji atau simbol';
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  @override
  void onClose() {
    nominalCtrl.dispose();
    keteranganCtrl.dispose();
    tanggalCtrl.dispose();
    super.onClose();
  }

  Future<void> loadTransactions() async {
    isLoading.value = true;
    try {
      final data = await SupabaseProvider.keuanganTable
          .select()
          .order('tanggal', ascending: false);
      transactions.value =
          (data as List).map((e) => KeuanganModel.fromJson(e)).toList();
      _recalculate();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data keuangan: $e',
          backgroundColor: const Color(0xFFFFEDED));
    }
    isLoading.value = false;
  }

  void _recalculate() {
    double masuk = 0, keluar = 0;
    for (final t in transactions) {
      if (t.isPemasukan) {
        masuk += t.nominal ?? 0;
      } else {
        keluar += t.nominal ?? 0;
      }
    }
    totalPemasukan.value = masuk;
    totalPengeluaran.value = keluar;
    saldo.value = masuk - keluar;
  }

  void openAddForm() {
    nominalCtrl.clear();
    keteranganCtrl.clear();
    selectedJenis.value = 'pemasukan';
    final now = DateTime.now();
    selectedTanggal = now;
    tanggalCtrl.text = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);
    Get.toNamed(AppRoutes.adminFinanceForm);
  }

  Future<void> saveTransaction() async {
    if (nominalCtrl.text.isEmpty) {
      Get.snackbar('Perhatian', 'Nominal wajib diisi');
      return;
    }
    final nominal = double.tryParse(
      nominalCtrl.text.replaceAll('.', '').replaceAll(',', ''),
    );
    if (nominal == null || nominal < 100) {
      Get.snackbar('Perhatian', 'Nominal minimal Rp 100');
      return;
    }

    if (selectedTanggal == null) {
      Get.snackbar('Perhatian', 'Silakan pilih tanggal & waktu',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final keteranganError = _validateKeterangan(keteranganCtrl.text);
    if (keteranganError != null) {
      Get.snackbar('Perhatian', keteranganError,
          backgroundColor: const Color(0xFFFFF3CD),
          colorText: const Color(0xFF7B5800),
          icon: const Icon(Icons.warning_rounded, color: Color(0xFF7B5800)),
          margin: const EdgeInsets.all(16),
          borderRadius: 12);
      return;
    }

    isSubmitting.value = true;
    try {
      await SupabaseProvider.keuanganTable.insert({
        'jenis': selectedJenis.value,
        'nominal': nominal,
        'keterangan': keteranganCtrl.text.trim(),
        'tanggal': selectedTanggal!.toIso8601String(),
      });

      Get.back();
      Get.snackbar('Berhasil', 'Transaksi berhasil disimpan',
          backgroundColor: const Color(0xFFE8F5E9),
          colorText: const Color(0xFF1B5E20),
          icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF1B5E20)),
          margin: const EdgeInsets.all(16),
          borderRadius: 12);

      await loadTransactions();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan: $e',
          backgroundColor: const Color(0xFFFFEDED));
    }
    isSubmitting.value = false;
  }

  void setTanggal(DateTime date) {
    selectedTanggal = date;
    tanggalCtrl.text = DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  Future<void> deleteTransaction(KeuanganModel t) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Transaksi'),
        content: const Text('Yakin ingin menghapus transaksi ini?'),
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
      await SupabaseProvider.keuanganTable
          .delete()
          .eq('id_keuangan', t.idKeuangan!);
      Get.snackbar('Berhasil', 'Transaksi dihapus',
          backgroundColor: const Color(0xFFE8F5E9),
          colorText: const Color(0xFF1B5E20),
          icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF1B5E20)),
          margin: const EdgeInsets.all(16),
          borderRadius: 12);
      await loadTransactions();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus: $e',
          backgroundColor: const Color(0xFFFFEDED));
    }
  }

  String formatRp(double val) => _fmt.format(val);
  String formatRpFull(double val) => _fmt.format(val);

  Future<void> pickTanggal(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedTanggal ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedTanggal ?? DateTime.now()),
    );

    final time = pickedTime ?? TimeOfDay.now();
    final combined = DateTime(
      picked.year, picked.month, picked.day,
      time.hour, time.minute,
    );
    setTanggal(combined);
  }
}