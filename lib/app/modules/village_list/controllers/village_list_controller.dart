import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/village_model.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';

class VillageListController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final villages = <VillageModel>[].obs;
  final isLoading = true.obs;
  final isLoadingMore = false.obs;

  // Pagination
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchVillages();
    setupScrollListener();
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  Future<void> fetchVillages() async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.getVillages(page: 1);
      final body = response.body;

      if (response.statusCode == 200 && body is Map<String, dynamic>) {
        final villageResponse = VillageResponse.fromJson(body);
        if (villageResponse.status == true) {
          villages.assignAll(villageResponse.data ?? []);

          if (villageResponse.pagination != null) {
            currentPage.value = villageResponse.pagination!.currentPage ?? 1;
            lastPage.value = villageResponse.pagination!.totalPages ?? 1;
          }
        }
      } else {
        Get.snackbar('Error', 'Failed to load villages');
      }
    } catch (e) {
      print('Error fetching villages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || currentPage.value >= lastPage.value) return;

    isLoadingMore.value = true;
    try {
      final nextPage = currentPage.value + 1;
      final response = await _apiProvider.getVillages(page: nextPage);
      final body = response.body;

      if (response.statusCode == 200 && body is Map<String, dynamic>) {
        final villageResponse = VillageResponse.fromJson(body);
        if (villageResponse.status == true && villageResponse.data != null) {
          villages.addAll(villageResponse.data!);

          if (villageResponse.pagination != null) {
            currentPage.value =
                villageResponse.pagination!.currentPage ?? nextPage;
            lastPage.value =
                villageResponse.pagination!.totalPages ?? lastPage.value;
          }
        }
      }
    } catch (e) {
      print('Error loading more villages: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
