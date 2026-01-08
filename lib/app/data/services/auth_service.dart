import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:godevi_app/app/data/models/user_model.dart';

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

  void logout() {
    user.value = null;
    isLoggedIn.value = false;
    _box.remove('user');
    _box.remove('auth_token');
  }
}
