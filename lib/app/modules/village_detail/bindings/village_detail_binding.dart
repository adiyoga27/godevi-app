import 'package:get/get.dart';
import 'package:godevi_app/app/modules/village_detail/controllers/village_detail_controller.dart';

class VillageDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VillageDetailController>(() => VillageDetailController());
  }
}
