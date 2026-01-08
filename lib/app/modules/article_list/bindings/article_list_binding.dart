import 'package:get/get.dart';
import 'package:godevi_app/app/modules/article_list/controllers/article_list_controller.dart';

class ArticleListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArticleListController>(() => ArticleListController());
  }
}
