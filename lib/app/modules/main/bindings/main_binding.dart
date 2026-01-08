import 'package:get/get.dart';
import 'package:godevi_app/app/modules/home/controllers/home_controller.dart';
import 'package:godevi_app/app/modules/main/controllers/main_controller.dart';
import 'package:godevi_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:godevi_app/app/modules/reservation/controllers/reservation_controller.dart';
import 'package:godevi_app/app/modules/notification/controllers/notification_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ReservationController>(() => ReservationController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}
