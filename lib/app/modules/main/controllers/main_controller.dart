import 'package:get/get.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';

class MainController extends GetxController {
  final currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if initialIndex is passed in arguments
    if (Get.arguments != null && Get.arguments is Map) {
      if (Get.arguments['initialIndex'] != null) {
        currentIndex.value = Get.arguments['initialIndex'];
      }
    }
  }

  void changePage(int index) {
    if (index == 1 || index == 2) {
      final authService = Get.find<AuthService>();
      if (!authService.isLoggedIn.value) {
        Get.toNamed('/login');
        return;
      }
    }
    currentIndex.value = index;
  }
}
