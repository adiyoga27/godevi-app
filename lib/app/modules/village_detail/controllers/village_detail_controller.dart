import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/package_model.dart';
import 'package:godevi_app/app/data/models/village_model.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';

class VillageDetailController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final village = Rxn<VillageModel>();
  final recommendedPackages = <PackageModel>[].obs;
  final isLoadingPackages = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is VillageModel) {
      village.value = Get.arguments as VillageModel;
      fetchRecommendedPackages();
    }
  }

  void fetchRecommendedPackages() async {
    if (village.value?.villageName == null) return;

    isLoadingPackages.value = true;
    try {
      // Create slug from name: "Colol Village" -> "colol-village"
      String slug = village.value!.villageName!
          .toLowerCase()
          .replaceAll(' ', '-')
          .replaceAll(RegExp(r'[^a-z0-9-]'), ''); // Remove special chars

      // Handle edge case where name might have extra spaces "Catur  Village" -> "catur--village" -> "catur-village"
      slug = slug.replaceAll(RegExp(r'-+'), '-');

      print('Fetching tours for slug: $slug');

      final response = await _apiProvider.getVillageTours(slug);
      final body = response.body;

      if (response.statusCode == 200 && body is Map<String, dynamic>) {
        if (body['status'] == true && body['data'] != null) {
          final List data = body['data'];
          recommendedPackages.assignAll(
            data.map((e) => PackageModel.fromJson(e)).toList(),
          );
        }
      }
    } catch (e) {
      print('Error fetching recommended packages: $e');
    } finally {
      isLoadingPackages.value = false;
    }
  }
}
