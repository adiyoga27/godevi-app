import 'package:get/get.dart';
import 'package:godevi_app/app/modules/reservation/controllers/reservation_controller.dart';

class ReservationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReservationController>(() => ReservationController());
  }
}
