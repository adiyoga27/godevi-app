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
      if (response.statusCode == 200) {
        final data = response.body['data'] ?? response.body;
        transaction.value = TransactionModel.fromJson(data, type: type);
      } else {
        Get.snackbar("Error", "Failed to detailed transaction");
      }
    } catch (e) {
      print("Error fetching detail: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}
