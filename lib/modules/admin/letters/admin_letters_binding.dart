import 'package:get/get.dart';
import '../../../data/repositories/notifikasi_repository.dart';
import '../../../data/repositories/surat_repository.dart';
import 'admin_letters_controller.dart';

class AdminLettersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SuratRepository());
    Get.lazyPut(() => NotifikasiRepository());
    Get.lazyPut(
      () => AdminLettersController(
        suratRepo: Get.find(),
        notifikasiRepo: Get.find(),
      ),
    );
  }
}
