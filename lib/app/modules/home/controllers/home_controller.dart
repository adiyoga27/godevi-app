import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/homestay_model.dart';
import 'package:godevi_app/app/data/models/package_model.dart';
import 'package:godevi_app/app/data/models/slider_model.dart';
import 'package:godevi_app/app/data/models/village_model.dart';
import 'package:godevi_app/app/data/models/article_model.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';
import 'package:godevi_app/app/modules/home/controllers/home_repository.dart';

class HomeController extends GetxController {
  final HomeRepository repository = HomeRepository(Get.put(ApiProvider()));

  final sliders = <SliderModel>[].obs;
  final popularVillages = <VillageModel>[].obs;
  final bestPackages = <PackageModel>[].obs;
  final bestHomestays = <HomestayModel>[].obs;
  final articles = <ArticleModel>[].obs;

  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        repository.getSliders(),
        repository.getPopularVillages(),
        repository.getBestTours(),
        repository.getBestHomestays(),
        repository.getArticles(),
      ]);

      sliders.assignAll(results[0] as List<SliderModel>);
      popularVillages.assignAll(results[1] as List<VillageModel>);
      bestPackages.assignAll(results[2] as List<PackageModel>);
      bestHomestays.assignAll(results[3] as List<HomestayModel>);
      articles.assignAll(results[4] as List<ArticleModel>);
    } catch (e) {
      print("Error fetching home data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToProfile() {
    final authService = Get.find<AuthService>();
    if (authService.isLoggedIn.value) {
      Get.toNamed('/profile');
    } else {
      Get.toNamed('/login');
    }
  }

  void navigateToBooking() {
    final authService = Get.find<AuthService>();
    if (authService.isLoggedIn.value) {
      Get.toNamed('/reservation');
    } else {
      Get.toNamed('/login');
    }
  }
}
