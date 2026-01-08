import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/user_model.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';

class LoginController extends GetxController {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  final AuthService _authService = Get.find<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Warning",
        "Username / password is empty",
        backgroundColor: Colors.amber,
        colorText: Colors.black,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await apiProvider.login(
        emailController.text,
        passwordController.text,
      );

      if (response.statusCode == 200 && response.body['status'] == true) {
        final userData = response.body['data'];
        final user = UserModel.fromJson(userData);
        _authService.login(user); // Pass UserModel

        Get.back();
        Get.snackbar(
          "Success",
          "Login Successful",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          response.body['message'] ?? "Login Failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
