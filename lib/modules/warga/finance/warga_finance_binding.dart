import 'package:get/get.dart';
import '../../../data/repositories/keuangan_repository.dart';
import 'warga_finance_controller.dart';

class WargaFinanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => KeuanganRepository());
    Get.lazyPut(() => WargaFinanceController(keuanganRepo: Get.find()));
  }
}
