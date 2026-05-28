
import 'package:get/get.dart';
import '../../data/repositories/penduduk_repository.dart';
import 'profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PendudukRepository>(() => PendudukRepository());
    Get.lazyPut<ProfileController>(
      () => ProfileController(pendudukRepo: Get.find<PendudukRepository>()),
    );
  }
}