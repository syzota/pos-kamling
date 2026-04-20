import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRepository());
    Get.lazyPut<LoginController>(
      () => LoginController(authRepo: Get.find()),
      fenix: true, // 🔥 WAJIB
    );
  }
}
