
import 'package:get/get.dart';
import '../../../data/repositories/penduduk_repository.dart';
import 'security_controller.dart';

class SecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PendudukRepository());
    Get.lazyPut(() => SecurityController(pendudukRepo: Get.find()));
  }
}
