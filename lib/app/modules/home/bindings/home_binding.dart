import 'package:get/get.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';
import 'package:godevi_app/app/modules/notification/controllers/notification_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiProvider());
    Get.put(NotificationController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
