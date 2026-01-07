import 'package:get/get.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';
import 'package:godevi_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  get user => _authService.user.value;

  void logout() {
    _authService.logout();
    Get.offAllNamed(Routes.HOME);
  }
}
