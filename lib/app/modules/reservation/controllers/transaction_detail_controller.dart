import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/transaction_model.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';

class TransactionDetailController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final RxBool isLoading = true.obs;
  final Rx<TransactionModel?> transaction = Rx<TransactionModel?>(null);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      final String? apiUrl = args['api_url'];
      if (apiUrl != null) {
        fetchTransactionDetailByUrl(apiUrl);
        return;
      }

      final String? uuid = args['uuid'];
      final String? type = args['type'];
      if (uuid != null && type != null) {
        fetchTransactionDetail(type, uuid);
      } else {
        // Handle error: Invalid arguments
        isLoading.value = false;
        Get.snackbar("Error", "Invalid transaction details");
      }
    } else {
      isLoading.value = false;
    }
  }

  Future<void> fetchTransactionDetail(String type, String uuid) async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.getTransactionDetail(type, uuid);
      _handleResponse(response, type);
    } catch (e) {
      print("Error fetching detail: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTransactionDetailByUrl(String url) async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.get(url);
      // We don't know type, try to infer or pass generic?
      // TransactionModel.fromJson requires type.
      // If url is like /transaction-detail/event/..., inference:
      String type = 'tour'; // Default fallback
      if (url.contains('/event/')) type = 'event';
      if (url.contains('/homestay/')) type = 'homestay';

      _handleResponse(response, type);
    } catch (e) {
      print("Error fetching detail by url: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  void _handleResponse(Response response, String type) {
    if (response.statusCode == 200) {
      final data = response.body['data'] ?? response.body;
      transaction.value = TransactionModel.fromJson(data, type: type);
    } else {
      Get.snackbar("Error", "Failed to detailed transaction");
    }
  }
}
