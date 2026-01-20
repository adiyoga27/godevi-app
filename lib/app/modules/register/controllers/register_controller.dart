import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';

class RegisterController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  final RxBool isTermsAgreed = false.obs;
  final RxBool isLoading = false.obs;

  Future<void> register() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        'Warning',
        'Please fill all field',
        backgroundColor: Colors.amber,
        colorText: Colors.black,
      );
      return;
    }

    if (passwordController.text != repeatPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!isTermsAgreed.value) {
      Get.snackbar(
        'Error',
        'Please agree to terms of service',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiProvider.register({
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'confirmation_password': repeatPasswordController.text,
      });

      if (response.status.hasError) {
        Get.snackbar(
          'Error',
          response.bodyString ?? 'Registration failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Success',
          'Registration successful. Please login.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Get.back(); // Go back to login
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
