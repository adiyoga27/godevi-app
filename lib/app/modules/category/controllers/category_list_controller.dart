import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/article_model.dart';
import 'package:godevi_app/app/data/models/event_model.dart';
import 'package:godevi_app/app/data/models/homestay_model.dart';
import 'package:godevi_app/app/data/models/package_model.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CategoryListController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();

  final RxList<dynamic> items = <dynamic>[].obs;
  final RxBool isLoading = true.obs;

  late String categoryType;
  final RxString title = "".obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    categoryType = args['type'];
    title.value = args['title'];
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

  Future<void> fetchNearbyTours() async {
    isLoading.value = true;
    try {
      // 1. Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Permission Denied', 'Location permission is required.');
          isLoading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Denied',
          'Location permissions are permanently denied, we cannot request permissions.',
        );
        isLoading.value = false;
        return;
      }

      // 2. Get Position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get Address Name
      String locationName = "Current Location";
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          print("DEBUG PLACEMARK: $place"); // Debugging

          List<String> parts = [];

          // Prioritize Administrative Area (Province)
          if (place.administrativeArea != null &&
              place.administrativeArea!.isNotEmpty) {
            parts.add(place.administrativeArea!);
          }

          // Then SubAdministrative Area (Regency/City)
          if (place.subAdministrativeArea != null &&
              place.subAdministrativeArea!.isNotEmpty) {
            parts.add(place.subAdministrativeArea!);
          }

          // Fallback: Locality (District) -> SubLocality -> Name
          if (parts.isEmpty) {
            if (place.locality != null && place.locality!.isNotEmpty) {
              parts.add(place.locality!);
            } else if (place.subLocality != null &&
                place.subLocality!.isNotEmpty) {
              parts.add(place.subLocality!);
            } else if (place.name != null && place.name!.isNotEmpty) {
              parts.add(place.name!);
            }
          }

          if (parts.isNotEmpty) {
            locationName = parts.join(", ");
          }
        }
      } catch (e) {
        print("Error getting placemark: $e");
      }

      // Update Toolbar Title
      title.value = "Tour $locationName";

      // 3. Call API
      Response response = await apiProvider.getNearbyTours(
        position.latitude,
        position.longitude,
      );

      if (!response.status.hasError) {
        items.assignAll(
          (response.body['data'] as List)
              .map((e) => PackageModel.fromJson(e))
              .toList(),
        );
      } else {
        Get.snackbar("Error", "Failed to fetch nearby tours");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
