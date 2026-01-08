import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/search_result_model.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';

class SearchController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final RxString searchQuery = ''.obs;
  final RxList<SearchResultModel> searchResults = <SearchResultModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> search(String keyword) async {
    if (keyword.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    searchQuery.value = keyword;
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('\x1B[33m[Search] Searching for: $keyword\x1B[0m');
      final response = await _apiProvider.search(keyword);

      print('\x1B[33m[Search] Response: ${response.statusCode}\x1B[0m');
      print('\x1B[33m[Search] Body: ${response.body}\x1B[0m');

      if (response.statusCode == 200 && response.body['status'] == true) {
        final List<dynamic> data = response.body['data'] ?? [];
        searchResults.value = data
            .map((item) => SearchResultModel.fromJson(item))
            .toList();
        print('\x1B[32m[Search] Found ${searchResults.length} results\x1B[0m');
      } else {
        errorMessage.value = response.body['message'] ?? 'Search failed';
        searchResults.clear();
      }
    } catch (e) {
      print('\x1B[31m[Search] Error: $e\x1B[0m');
      errorMessage.value = 'Error: $e';
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
    errorMessage.value = '';
  }
}
