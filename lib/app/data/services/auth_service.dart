import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/user_model.dart';

class AuthService extends GetxService {
  final isLoggedIn = false.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  String get token => user.value?.token ?? '';

  Future<AuthService> init() async {
    // TODO: Implement persistence with GetStorage
    return this;
  }

  void login(UserModel newUser) {
    user.value = newUser;
    isLoggedIn.value = true;
  }

  void logout() {
    user.value = null;
    isLoggedIn.value = false;
  }
}
