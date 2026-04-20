import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/keuangan_repository.dart';

class WargaFinanceController extends GetxController {
  final KeuanganRepository keuanganRepo;
  WargaFinanceController({required this.keuanganRepo});

  var transactions = <KeuanganModel>[].obs;
  var saldo = 0.0.obs;
  var totalPemasukan = 0.0.obs;
  var totalPengeluaran = 0.0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      transactions.value = await keuanganRepo.getAllKeuangan();
      final s = await keuanganRepo.getSaldoTotal();
      saldo.value = s['saldo'] ?? 0.0;
      totalPemasukan.value = s['pemasukan'] ?? 0.0;
      totalPengeluaran.value = s['pengeluaran'] ?? 0.0;
    } catch (_) {}
    isLoading.value = false;
  }

  String formatRp(double v) {
    if (v >= 1000000) return 'Rp ${(v / 1000000).toStringAsFixed(1)}jt';
    if (v >= 1000) return 'Rp ${(v / 1000).toStringAsFixed(0)}rb';
    return 'Rp ${v.toStringAsFixed(0)}';
  }

  String formatRpFull(double v) {
    final f = v
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp $f';
  }
}
