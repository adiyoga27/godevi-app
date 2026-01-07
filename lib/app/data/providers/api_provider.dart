import 'package:get/get.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';

class ApiProvider extends GetConnect {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    httpClient.baseUrl = 'https://godestinationvillage.com/api';
    httpClient.timeout = const Duration(seconds: 30);

    httpClient.addRequestModifier<void>((request) {
      if (_authService.isLoggedIn.value) {
        request.headers['Authorization'] = 'Bearer ${_authService.token}';
      }
      request.headers['Accept'] = 'application/json';
      return request;
    });

    super.onInit();
  }

  // Auth
  Future<Response> login(String email, String password) {
    final form = FormData({'email': email, 'password': password});
    return post('/auth/login', form);
  }

  Future<Response> register(Map<String, dynamic> data) =>
      post('/auth/registration', data);

  // Home
  Future<Response> getSliders() => get('/v2/sliders');
  Future<Response> getPopularVillages() => get('/v2/popular-villages');
  Future<Response> getBestHomestays() => get('/v2/best-homestay');
  Future<Response> getBestTours() => get('/v2/best-tours');

  // Menus
  // Menus
  Future<Response> getVillages() => get('/v2/villages');
  Future<Response> getArticles() => get('/v2/articles');
  Future<Response> getTours() => get('/v2/tours');
  Future<Response> getEvents() => get('/v2/events');
  Future<Response> getHomestays() => get('/v2/homestay');
}
