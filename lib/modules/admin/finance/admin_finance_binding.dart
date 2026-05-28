import 'package:get/get.dart';
import '../../../data/repositories/keuangan_repository.dart';
import 'admin_finance_controller.dart';

class AdminFinanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => KeuanganRepository());
    Get.lazyPut(() => AdminFinanceController(keuanganRepo: Get.find()));
  }
}
