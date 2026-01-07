import 'package:get/get.dart';
import 'package:godevi_app/app/modules/booking/controllers/booking_controller.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingController>(() => BookingController());
  }
}
