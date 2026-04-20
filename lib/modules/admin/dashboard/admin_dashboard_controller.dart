import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/penduduk_repository.dart';
import '../../../data/repositories/surat_repository.dart';
import '../../../data/repositories/keuangan_repository.dart';
import '../../../data/repositories/pengumuman_repository.dart';
import '../../../app/routes/app_routes.dart';

class AdminDashboardController extends GetxController {
  final PendudukRepository pendudukRepo;
  final SuratRepository suratRepo;
  final KeuanganRepository keuanganRepo;
  final PengumumanRepository pengumumanRepo;

  AdminDashboardController({
    required this.pendudukRepo,
    required this.suratRepo,
    required this.keuanganRepo,
    required this.pengumumanRepo,
  });

  var totalWarga = 0.obs;
  var pendingSurat = <SuratModel>[].obs;
  var recentTransaksi = <KeuanganModel>[].obs;
  var recentPengumuman = <PengumumanModel>[].obs;
  var saldo = 0.0.obs;
  var isLoading = false.obs;

  PenggunaModel? get pengguna {
    try {
      return Get.find<PenggunaModel>();
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      totalWarga.value = await pendudukRepo.getTotalPenduduk();
      pendingSurat.value = await suratRepo.getPendingSurat();
      recentTransaksi.value = (await keuanganRepo.getAllKeuangan())
          .take(5)
          .toList();
      recentPengumuman.value = (await pengumumanRepo.getAllPengumuman())
          .take(3)
          .toList();
      final s = await keuanganRepo.getSaldoTotal();
      saldo.value = s['saldo'] ?? 0.0;
    } catch (_) {}
    isLoading.value = false;
  }

  void navigateTo(int index) {
    final routes = [
      AppRoutes.adminDashboard,
      AppRoutes.adminResidents,
      AppRoutes.adminLetters,
      AppRoutes.adminFinance,
      AppRoutes.adminActivities,
      AppRoutes.adminAnnouncement,
    ];
    if (index < routes.length) Get.offAllNamed(routes[index]);
  }

  void logout() {
    Get.deleteAll();
    Get.offAllNamed(AppRoutes.login);
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
