import 'package:get/get.dart';
import '../../../data/repositories/penduduk_repository.dart';
import 'admin_profile_controller.dart';

class AdminProfileBinding extends Bindings {
  @override
  void dependencies() {
    // inject repository dulu
    Get.lazyPut<PendudukRepository>(() => PendudukRepository());

    // inject controller + ambil repo dari Get
    Get.lazyPut<AdminProfileController>(
      () =>
          AdminProfileController(pendudukRepo: Get.find<PendudukRepository>()),
    );
  }
}
