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

    httpClient.addResponseModifier((request, response) {
      print('\x1B[33m[API Response] ${request.method} ${request.url}\x1B[0m');
      print('\x1B[33mStatus: ${response.statusCode}\x1B[0m');
      print('\x1B[33mBody: ${response.bodyString}\x1B[0m');
      return response;
    });

    super.onInit();
  }

  // Auth
  Future<Response> login(String email, String password) {
    final form = FormData({'email': email, 'password': password});
    return post('/auth/login', form);
  }

  Future<Response> resetPassword(String passwordNew, String passwordConfirm) {
    final form = FormData({
      'password_new': passwordNew,
      'password_confirm': passwordConfirm,
    });
    return post('/v2/auth/reset-password', form);
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
  Future<Response> getVillages({int page = 1}) =>
      get('/v2/villages', query: {'page': '$page'});
  Future<Response> getVillageTours(String slug) =>
      get('/v2/villages/tour/$slug');
  Future<Response> getArticles() => get('/v2/articles');
  Future<Response> getTours() => get('/v2/tours');
  Future<Response> getEvents() => get('/v2/events');
  Future<Response> getHomestays() => get('/v2/homestay');

  // Transactions
  Future<Response> getUnpaidTransactions(String email) =>
      get('/transaction/unpaid/$email');
  Future<Response> getPaidTransactions(String email) =>
      get('/transaction/paid/$email');
  Future<Response> getTransactionDetail(String type, String uuid) =>
      get('/transaction-detail/$type/$uuid');
  Future<Response> getCancelTransactions(String email) =>
      get('/transaction/cancel/$email');
  Future<Response> checkoutEvent(Map<String, dynamic> data) =>
      post('/v2/checkout/event', FormData(data));
  Future<Response> checkoutHomestay(Map<String, dynamic> data) =>
      post('/v2/checkout/homestay', FormData(data));
  Future<Response> checkoutTour(Map<String, dynamic> data) =>
      post('/v2/checkout/tour', FormData(data));

  // Social login (Google/Facebook)
  // Sends provider data to backend for authentication
  Future<Response> socialLogin({
    required String provider,
    required String providerId,
    required String name,
    required String email,
  }) {
    final form = FormData({
      'provider': provider,
      'provider_id': providerId,
      'name': name,
      'email': email,
    });
    // Use full URL to avoid baseUrl mismatch
    return post('/auth/login-sosmed', form);
  }

  // Search
  Future<Response> search(String keyword) => get('/v2/search/$keyword');

  // Detail by slug
  Future<Response> getTourBySlug(String slug) => get('/v2/tours/$slug');
  Future<Response> getEventBySlug(String slug) => get('/v2/events/$slug');
  Future<Response> getHomestayBySlug(String slug) => get('/v2/homestay/$slug');
}
