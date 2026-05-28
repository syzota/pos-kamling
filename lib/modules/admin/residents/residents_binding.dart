import 'package:get/get.dart';
import '../../../data/repositories/penduduk_repository.dart';
import 'residents_controller.dart';

class ResidentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PendudukRepository());
    Get.lazyPut(() => ResidentsController(pendudukRepo: Get.find()));
  }
}
