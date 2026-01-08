import 'package:get/get.dart';
import 'package:godevi_app/app/modules/reservation/controllers/transaction_detail_controller.dart';
import 'package:godevi_app/app/modules/reservation/controllers/reservation_controller.dart';

class TransactionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionDetailController>(
      () => TransactionDetailController(),
    );
    Get.lazyPut<ReservationController>(() => ReservationController());
  }
}
