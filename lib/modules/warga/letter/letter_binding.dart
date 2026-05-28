import 'package:get/get.dart';
import '../../../data/repositories/notifikasi_repository.dart';
import '../../../data/repositories/surat_repository.dart';
import 'letter_controller.dart';

class LetterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SuratRepository());
    Get.lazyPut(() => NotifikasiRepository());
    Get.lazyPut(
      () => LetterController(suratRepo: Get.find(), notifikasiRepo: Get.find()),
    );
  }
}
