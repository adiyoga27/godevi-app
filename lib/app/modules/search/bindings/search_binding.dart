import 'package:get/get.dart';
import 'package:godevi_app/app/modules/search/controllers/search_controller.dart'
    as app;

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<app.SearchController>(() => app.SearchController());
  }
}
