import 'package:get/get.dart';
import 'package:godevi_app/app/modules/login/controllers/login_controller.dart';
import 'package:godevi_app/app/modules/auth/controllers/auth_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
