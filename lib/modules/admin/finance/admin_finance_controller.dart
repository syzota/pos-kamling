import 'package:flutter/material.dart';
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

  // Form fields
  var selectedJenis = 'pemasukan'.obs;

  final nominalCtrl = TextEditingController();
  final keteranganCtrl = TextEditingController();
  final tanggalCtrl = TextEditingController();

  final _fmt = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

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
      final data = await SupabaseProvider.keuanganTable.select().order(
        'tanggal',
        ascending: false,
      );

      transactions.value = (data as List)
          .map((e) => KeuanganModel.fromJson(e))
          .toList();

      _recalculate();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data keuangan: $e',
        backgroundColor: const Color(0xFFFFEDED),
      );
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
    // ✅ VALIDASI NOMINAL
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

    // ✅ VALIDASI TANGGAL
    if (selectedTanggal == null) {
      Get.snackbar(
        'Perhatian',
        'Silakan pilih tanggal & waktu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final tanggal = selectedTanggal!; // 🔥 PAKAI INI

    // ✅ VALIDASI KETERANGAN
    if (keteranganCtrl.text.trim().isEmpty) {
      Get.snackbar('Perhatian', 'Keterangan wajib diisi');
      return;
    }

    isSubmitting.value = true;

    try {
      await SupabaseProvider.keuanganTable.insert({
        'jenis': selectedJenis.value,
        'nominal': nominal,
        'keterangan': keteranganCtrl.text.trim(),
        'tanggal': tanggal.toIso8601String(), // 🔥 FULL DATETIME
      });

      Get.back();
      Get.snackbar(
        'Berhasil',
        'Transaksi berhasil disimpan',
        backgroundColor: const Color(0xFFE8F5E9),
      );

      await loadTransactions();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan: $e',
        backgroundColor: const Color(0xFFFFEDED),
      );
    }

    isSubmitting.value = false;
  }

  DateTime? selectedTanggal;

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
      await SupabaseProvider.keuanganTable.delete().eq(
        'id_keuangan',
        t.idKeuangan!,
      );

      Get.snackbar(
        'Berhasil',
        'Transaksi dihapus',
        backgroundColor: const Color(0xFFE8F5E9),
      );

      await loadTransactions();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus: $e',
        backgroundColor: const Color(0xFFFFEDED),
      );
    }
  }

  String formatRp(double val) => _fmt.format(val);
  String formatRpFull(double val) => _fmt.format(val);
}
