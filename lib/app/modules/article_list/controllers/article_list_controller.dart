import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/article_model.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';
import 'package:godevi_app/app/modules/home/controllers/home_repository.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';

class ArticleListController extends GetxController {
  final HomeRepository _repository = HomeRepository(Get.find<ApiProvider>());

  final articles = <ArticleModel>[].obs;
  final popularArticles = <ArticleModel>[].obs;
  final isLoading = true.obs;
  final keyword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Check arguments for initial keyword if any
    if (Get.arguments != null && Get.arguments is String) {
      keyword.value = Get.arguments;
    }
    fetchPopularArticles();
    fetchArticles();
  }

  void search(String query) {
    keyword.value = query;
    fetchArticles();
  }

  Future<void> fetchPopularArticles() async {
    try {
      final result = await _repository.getPopularArticles();
      popularArticles.assignAll(result);
    } catch (e) {
      print("Error fetching popular articles: $e");
    }
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

  void toggleLike(ArticleModel article) async {
    final authService = Get.find<AuthService>();
    if (!authService.isLoggedIn.value) {
      Get.toNamed('/login');
      return;
    }

    final userId = authService.user.value?.id;
    if (userId == null) return;

    // Optimistic update for `articles` list
    final index = articles.indexWhere((e) => e.id == article.id);
    if (index != -1) {
      var current = articles[index];
      List<int> newLikes = List.from(current.likedBy ?? []);
      if (newLikes.contains(userId)) {
        newLikes.remove(userId);
      } else {
        newLikes.add(userId);
      }
      articles[index] = current.copyWith(likedBy: newLikes);
    }

    // Optimistic update for `popularArticles` list
    final popIndex = popularArticles.indexWhere((e) => e.id == article.id);
    if (popIndex != -1) {
      var current = popularArticles[popIndex];
      List<int> newLikes = List.from(current.likedBy ?? []);
      if (newLikes.contains(userId)) {
        newLikes.remove(userId);
      } else {
        newLikes.add(userId);
      }
      popularArticles[popIndex] = current.copyWith(likedBy: newLikes);
    }

    try {
      await Get.find<ApiProvider>().likeArticle(article.slug ?? '');
    } catch (e) {
      print("Error liking article: $e");
    }
  }
}
