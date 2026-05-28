
import 'package:get/get.dart';
import '../../../data/repositories/penduduk_repository.dart';
import 'edit_profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PendudukRepository());
    Get.lazyPut(() => EditProfileController(pendudukRepo: Get.find()));
  }
}