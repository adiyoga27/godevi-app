import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';

class ChangePasswordController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  void changePassword() async {
    final newPass = newPasswordController.text;
    final confirmPass = confirmPasswordController.text;

    if (newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    if (newPass != confirmPass) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiProvider.resetPassword(newPass, confirmPass);
      isLoading.value = false;

      final responseBody = response.body;
      print('Response Body Type: ${responseBody.runtimeType}');
      print('Response Body: $responseBody');

      if (response.statusCode == 200) {
        // dynamic parsing
        final status = responseBody is Map ? responseBody['status'] : false;
        final message = responseBody is Map
            ? responseBody['message']
            : 'Success';

        print('Parsed Status: $status (${status.runtimeType})');

        if (status == true) {
          print('Entering success block');
          Get.snackbar(
            'Success',
            message ?? 'Password changed successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          await Future.delayed(const Duration(seconds: 2));
          Get.back();
        } else {
          print('Entering error block');
          Get.snackbar(
            'Error',
            message ?? 'Failed to change password',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar('Error', 'Server Error: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      print('Error changing password: $e');
      Get.snackbar('Error', 'An error occurred');
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
