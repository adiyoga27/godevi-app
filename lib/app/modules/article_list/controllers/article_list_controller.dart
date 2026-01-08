import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/article_model.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';
import 'package:godevi_app/app/modules/home/controllers/home_repository.dart';

class ArticleListController extends GetxController {
  final HomeRepository _repository = HomeRepository(Get.find<ApiProvider>());

  final articles = <ArticleModel>[].obs;
  final isLoading = true.obs;
  final keyword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Check arguments for initial keyword if any
    if (Get.arguments != null && Get.arguments is String) {
      keyword.value = Get.arguments;
    }
    fetchArticles();
  }

  void search(String query) {
    keyword.value = query;
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    isLoading.value = true;
    try {
      final result = await _repository.getArticles(keyword: keyword.value);
      articles.assignAll(result);
    } catch (e) {
      print("Error fetching articles: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToDetail(ArticleModel article) {
    Get.toNamed('/article-detail', arguments: article);
  }
}
