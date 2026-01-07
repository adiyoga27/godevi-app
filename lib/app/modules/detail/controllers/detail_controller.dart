import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/package_model.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';
import 'package:godevi_app/app/routes/app_pages.dart';

class DetailController extends GetxController {
  final PackageModel? package = Get.arguments as PackageModel?;
  final AuthService _authService = Get.find<AuthService>();

  void onBookNow() {
    if (_authService.isLoggedIn.value) {
      if (package != null) {
        Get.toNamed(Routes.BOOKING, arguments: package);
      }
    } else {
      Get.toNamed(Routes.LOGIN);
    }
  }
}
