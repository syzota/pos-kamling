import 'package:get/get.dart';
import '../../../data/repositories/kegiatan_repository.dart';
import 'calendar_controller.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => KegiatanRepository());
    Get.lazyPut(() => CalendarController(kegiatanRepo: Get.find()));
  }
}