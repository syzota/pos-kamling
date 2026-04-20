import 'package:get/get.dart';
import '../../../data/repositories/penduduk_repository.dart';
import 'warga_profile_controller.dart';

class WargaProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PendudukRepository());
    Get.lazyPut(() => WargaProfileController(pendudukRepo: Get.find()));
  }
}
