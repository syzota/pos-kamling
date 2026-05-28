import 'package:get/get.dart';
import '../../../data/repositories/kegiatan_repository.dart';
import 'activities_controller.dart';

class ActivitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => KegiatanRepository());
    Get.lazyPut(() => ActivitiesController(kegiatanRepo: Get.find()));
  }
}
