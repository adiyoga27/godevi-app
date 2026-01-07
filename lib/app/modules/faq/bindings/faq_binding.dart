import 'package:get/get.dart';
import 'package:godevi_app/app/modules/faq/controllers/faq_controller.dart';

class FaqBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaqController>(() => FaqController());
  }
}
