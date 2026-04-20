import 'package:get/get.dart';
import '../../../data/repositories/pengumuman_repository.dart';
import '../../../data/repositories/kegiatan_repository.dart';
import 'warga_dashboard_controller.dart';

class WargaDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PengumumanRepository());
    Get.lazyPut(() => KegiatanRepository());
    Get.lazyPut(() => WargaDashboardController(pengumumanRepo: Get.find(), kegiatanRepo: Get.find()));
  }
}