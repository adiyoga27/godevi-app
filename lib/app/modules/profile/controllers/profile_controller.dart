import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/user_model.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';
import 'package:godevi_app/app/routes/app_pages.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  UserModel? get user => _authService.user.value;

  final isLoading = false.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    if (!_authService.isLoggedIn.value) return;
    try {
      final response = await _apiProvider.getProfile();
      if (response.statusCode == 200 && response.body['status'] == true) {
        final userData = response.body['data'];
        final updatedUser = UserModel.fromJson(userData);
        // Preserve token if not returned by profile APi
        updatedUser.token = _authService.token;
        _authService.saveUser(updatedUser);
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String country,
    required String address,
  }) async {
    isLoading.value = true;
    try {
      final Map<String, String> data = {
        'name': name,
        'phone': phone,
        'country': country,
        'address': address,
      };

      final response = await _apiProvider.updateProfile(
        data,
        selectedImage.value,
      );

      if (response.statusCode == 200 && response.body['status'] == true) {
        Get.snackbar("Success", "Profile updated successfully");
        await fetchProfile(); // Refresh data
        Get.back(); // Close Edit Page
      } else {
        Get.snackbar(
          "Error",
          response.body['message'] ?? "Failed to update profile",
        );
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.HOME);
  }
}
