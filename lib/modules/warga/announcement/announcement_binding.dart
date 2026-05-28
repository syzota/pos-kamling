import 'package:get/get.dart';
import '../../../data/repositories/pengumuman_repository.dart';
import 'announcement_controller.dart';

class AnnouncementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PengumumanRepository());
    Get.lazyPut(() => AnnouncementController(pengumumanRepo: Get.find()));
  }
}
