import 'package:get/get.dart';
import '../../../data/repositories/notifikasi_repository.dart';
import '../../../data/repositories/pengumuman_repository.dart';
import 'admin_announcement_controller.dart';

class AdminAnnouncementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PengumumanRepository());
    Get.lazyPut(() => NotifikasiRepository());
    Get.lazyPut<AdminAnnouncementController>(
      () => AdminAnnouncementController(
        pengumumanRepo: Get.find(),
        notifikasiRepo: Get.find(),
      ),
    );
  }
}
