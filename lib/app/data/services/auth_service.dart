import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:godevi_app/app/data/models/user_model.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService extends GetxService {
  final isLoggedIn = false.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  String get token => user.value?.token ?? '';
  final _box = GetStorage();

  Future<AuthService> init() async {
    final userData = _box.read('user');
    if (userData != null) {
      try {
        user.value = UserModel.fromJson(userData);

        isLoggedIn.value = true;
      } catch (e) {
        print('Error reading user data: $e');
        _box.remove('user');
      }
    }
    return this;
  }

  void login(UserModel newUser) {
    user.value = newUser;
    isLoggedIn.value = true;
    _box.write('user', newUser.toJson());
  }

  void saveToken(String token) {
    _box.write('auth_token', token);
  }

  Future<void> logout() async {
    user.value = null;
    isLoggedIn.value = false;
    _box.remove('user');
    _box.remove('auth_token');

    // Sign out from social providers
    try {
      await FacebookAuth.instance.logOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      print('Error signing out from social providers: $e');
    }
  }
}
