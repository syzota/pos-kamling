import 'package:get/get.dart';
import '../../../data/repositories/penduduk_repository.dart';
import '../../../data/repositories/surat_repository.dart';
import '../../../data/repositories/keuangan_repository.dart';
import '../../../data/repositories/pengumuman_repository.dart';
import 'admin_dashboard_controller.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PendudukRepository());
    Get.lazyPut(() => SuratRepository());
    Get.lazyPut(() => KeuanganRepository());
    Get.lazyPut(() => PengumumanRepository());
    Get.lazyPut(
      () => AdminDashboardController(
        pendudukRepo: Get.find(),
        suratRepo: Get.find(),
        keuanganRepo: Get.find(),
        pengumumanRepo: Get.find(),
      ),
    );
  }
}
