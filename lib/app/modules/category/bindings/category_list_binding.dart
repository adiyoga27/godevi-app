import 'package:get/get.dart';
import 'package:godevi_app/app/modules/category/controllers/category_list_controller.dart';

class CategoryListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryListController>(() => CategoryListController());
  }
}
