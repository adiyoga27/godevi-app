import 'package:get/get.dart';
import 'package:godevi_app/app/modules/village_list/controllers/village_list_controller.dart';

class VillageListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VillageListController>(() => VillageListController());
  }
}
