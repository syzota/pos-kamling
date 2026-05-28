import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/pengumuman_repository.dart';
import '../../../data/repositories/kegiatan_repository.dart';
import '../../../app/routes/app_routes.dart';

class WargaDashboardController extends GetxController {
  final PengumumanRepository pengumumanRepo;
  final KegiatanRepository kegiatanRepo;
  WargaDashboardController({
    required this.pengumumanRepo,
    required this.kegiatanRepo,
  });

  var pengumuman = <PengumumanModel>[].obs;
  var upcomingKegiatan = <KegiatanModel>[].obs;
  var isLoading = false.obs;
  
  PenggunaModel? get pengguna {
    try {
      return Get.find<PenggunaModel>();
    } catch (_) {
      return null;
    }
  }

  PendudukModel? get penduduk {
    try {
      return Get.find<PendudukModel>();
    } catch (_) {
      return null;
    }
  }

  String get namaWarga => penduduk?.nama ?? pengguna?.username ?? 'Warga';

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      pengumuman.value = await pengumumanRepo.getAllPengumuman();
      upcomingKegiatan.value = await kegiatanRepo.getUpcomingKegiatan();
    } catch (_) {}
    isLoading.value = false;
  }

  void navigateTo(int index) {
    final routes = [
      AppRoutes.wargaDashboard,
      AppRoutes.wargaCalendar,
      AppRoutes.wargaLetter,
      AppRoutes.wargaFinance,
      AppRoutes.wargaAnnouncement,
    ];
    if (index >= 0 && index < routes.length) {
      Get.offNamed(routes[index]);
    }
  }

  void logout() {
    Get.deleteAll();
    Get.offAllNamed(AppRoutes.login);
  }
}
