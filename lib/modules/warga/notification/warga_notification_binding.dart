import 'package:get/get.dart';
import '../../../data/repositories/notifikasi_repository.dart';
import '../../../data/repositories/pengumuman_repository.dart';
import '../../../data/repositories/surat_repository.dart';
import 'warga_notification_controller.dart';

class WargaNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotifikasiRepository());
    Get.lazyPut(() => SuratRepository());
    Get.lazyPut(() => PengumumanRepository());
    Get.lazyPut(
      () => WargaNotificationController(
        notifikasiRepo: Get.find(),
        suratRepo: Get.find(),
        pengumumanRepo: Get.find(),
      ),
    );
  }
}
