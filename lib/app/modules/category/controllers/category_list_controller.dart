import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/article_model.dart';
import 'package:godevi_app/app/data/models/event_model.dart';
import 'package:godevi_app/app/data/models/homestay_model.dart';
import 'package:godevi_app/app/data/models/package_model.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';

class CategoryListController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();

  final RxList<dynamic> items = <dynamic>[].obs;
  final RxBool isLoading = true.obs;

  late String categoryType;
  late String title;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    categoryType = args['type'];
    title = args['title'];
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      Response response;
      switch (categoryType) {
        case 'tour':
          response = await apiProvider.getTours();
          if (!response.status.hasError) {
            items.assignAll(
              (response.body['data'] as List)
                  .map((e) => PackageModel.fromJson(e))
                  .toList(),
            );
          }
          break;
        case 'event':
          response = await apiProvider.getEvents();
          if (!response.status.hasError) {
            items.assignAll(
              (response.body['data'] as List)
                  .map((e) => EventModel.fromJson(e))
                  .toList(),
            );
          }
          break;
        case 'homestay':
          response = await apiProvider.getHomestays();
          if (!response.status.hasError) {
            items.assignAll(
              (response.body['data'] as List)
                  .map((e) => HomestayModel.fromJson(e))
                  .toList(),
            );
          }
          break;
        case 'article':
          response = await apiProvider.getArticles();
          if (!response.status.hasError) {
            items.assignAll(
              (response.body['data'] as List)
                  .map((e) => ArticleModel.fromJson(e))
                  .toList(),
            );
          }
          break;
      }
    } catch (e) {
      print('Error fetching category data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
