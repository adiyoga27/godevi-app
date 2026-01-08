import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';
import 'package:godevi_app/app/data/models/user_model.dart';
import 'package:godevi_app/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final AuthService _authService = Get.find<AuthService>();

  // Debug log observable
  final RxList<String> debugLogs = <String>[].obs;

  // Show debug error with yellow snackbar
  void _showDebugError(String title, String message) {
    debugLogs.add('[$title] $message');
    print('\x1B[33m[DEBUG] $title: $message\x1B[0m'); // Yellow in console
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.amber.shade700,
      colorText: Colors.black,
      duration: const Duration(seconds: 5),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      icon: const Icon(Icons.warning_amber_rounded, color: Colors.black),
    );
  }

  // Google Sign-In
  Future<void> signInWithGoogle() async {
    try {
      debugLogs.add('[Google] Starting sign-in...');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        _showDebugError('Google', 'Sign-in cancelled by user');
        return;
      }
      debugLogs.add('[Google] User: ${googleUser.email}');
      final String providerId = googleUser.id;
      final String name = googleUser.displayName ?? '';
      final String email = googleUser.email;

      await _socialLogin('google', providerId, name, email);
    } catch (e, stackTrace) {
      _showDebugError(
        'Google Error',
        '$e\n\nStack: ${stackTrace.toString().split('\n').take(5).join('\n')}',
      );
    }
  }

  // Facebook Sign-In
  Future<void> signInWithFacebook() async {
    try {
      debugLogs.add('[Facebook] Starting sign-in...');
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) {
        _showDebugError(
          'Facebook',
          'Login failed: ${result.status.name} - ${result.message ?? 'No message'}',
        );
        return;
      }
      debugLogs.add('[Facebook] Login success, fetching user data...');
      final userData = await FacebookAuth.instance.getUserData();
      final String providerId = userData['id']?.toString() ?? '';
      final String name = userData['name'] ?? '';
      final String email = userData['email'] ?? '';

      debugLogs.add('[Facebook] User: $email');
      await _socialLogin('facebook', providerId, name, email);
    } catch (e, stackTrace) {
      _showDebugError(
        'Facebook Error',
        '$e\n\nStack: ${stackTrace.toString().split('\n').take(5).join('\n')}',
      );
    }
  }

  Future<void> _socialLogin(
    String provider,
    String providerId,
    String name,
    String email,
  ) async {
    try {
      debugLogs.add('[API] Calling socialLogin for $provider...');
      debugLogs.add(
        '[API] Form Data: provider=$provider, provider_id=$providerId, name=$name, email=$email',
      );
      print('\x1B[33m[DEBUG] POST Form Data:\x1B[0m');
      print('\x1B[33m  provider: $provider\x1B[0m');
      print('\x1B[33m  provider_id: $providerId\x1B[0m');
      print('\x1B[33m  name: $name\x1B[0m');
      print('\x1B[33m  email: $email\x1B[0m');
      final response = await _apiProvider.socialLogin(
        provider: provider,
        providerId: providerId,
        name: name,
        email: email,
      );
      debugLogs.add('[API] Response: ${response.statusCode}');
      debugLogs.add('[API] Response Body: ${response.body}');
      print('\x1B[33m[DEBUG] API Response: ${response.statusCode}\x1B[0m');
      print('\x1B[33m[DEBUG] Response Body: ${response.body}\x1B[0m');

      if (response.statusCode == 200 && response.body['status'] == true) {
        final data = response.body['data'];
        final token = data['token'];

        // Create UserModel from response data
        // Check if data has a nested 'user' object or is the user object itself
        Map<String, dynamic> userMap = data;
        if (data['user'] != null && data['user'] is Map<String, dynamic>) {
          userMap = data['user'];
          // Ensure token is preserved if it was at the top level
          userMap['token'] ??= token;
        } else {
          // Ensure token is present if flat structure
          userMap['token'] ??= token;
        }

        final userData = UserModel.fromJson(userMap);

        // Ensure critical fields are set from social login if missing in API
        if (userData.email == null || userData.email!.isEmpty)
          userData.email = email;
        if (userData.name == null || userData.name!.isEmpty)
          userData.name = name;

        _authService.login(
          userData,
        ); // This saves user AND sets isLoggedIn = true

        debugLogs.add('[API] Login success, user saved, navigating home...');
        print(
          '\x1B[32m[DEBUG] Auth saved successfully! isLoggedIn: ${_authService.isLoggedIn.value}\x1B[0m',
        );
        Get.offAllNamed(Routes.HOME);
      } else {
        _showDebugError(
          'API Error',
          'Status: ${response.statusCode}\nMessage: ${response.body['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e, stackTrace) {
      _showDebugError(
        'API Error',
        '$e\n\nStack: ${stackTrace.toString().split('\n').take(5).join('\n')}',
      );
    }
  }

  // Get all debug logs as formatted string
  String getDebugLogsText() {
    return debugLogs.join('\n');
  }

  // Clear debug logs
  void clearDebugLogs() {
    debugLogs.clear();
  }
}
