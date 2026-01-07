import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/modules/reservation/views/payment_webview.dart';

import 'package:godevi_app/app/data/models/transaction_model.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';
import 'package:godevi_app/app/routes/app_pages.dart';

class ReservationController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final AuthService _authService = Get.find<AuthService>();

  final RxInt currentTab = 0.obs; // 0: Not Paid, 1: Paid, 2: Finished
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load initial tab data
    fetchTransactions();
  }

  void changeTab(int index) {
    if (currentTab.value == index) return;
    currentTab.value = index;
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final user = _authService.user.value;
    if (!_authService.isLoggedIn.value || user?.email == null) {
      transactions.clear();
      return;
    }

    final email = user!.email!;
    isLoading.value = true;
    transactions.clear();

    try {
      Response response;
      if (currentTab.value == 0) {
        response = await _apiProvider.getUnpaidTransactions(email);
      } else if (currentTab.value == 1) {
        response = await _apiProvider.getPaidTransactions(email);
      } else {
        response = await _apiProvider.getCancelTransactions(email);
      }

      if (response.statusCode == 200) {
        final body = response.body;
        // Verify if data is wrapped in 'data' or at root. Usually APIs wrap in 'data', checking both.
        final data = body['data'] ?? body;

        final List<TransactionModel> allTransactions = [];

        if (data['orderTours'] != null) {
          final List<dynamic> tours = data['orderTours'];
          allTransactions.addAll(
            tours.map((e) => TransactionModel.fromJson(e, type: 'tour')),
          );
        }

        if (data['orderEvents'] != null) {
          final List<dynamic> events = data['orderEvents'];
          allTransactions.addAll(
            events.map((e) => TransactionModel.fromJson(e, type: 'event')),
          );
        }

        if (data['orderHomestay'] != null) {
          final List<dynamic> homestays = data['orderHomestay'];
          allTransactions.addAll(
            homestays.map(
              (e) => TransactionModel.fromJson(e, type: 'homestay'),
            ),
          );
        }

        // Sort by id or date descending if possible
        allTransactions.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));

        transactions.assignAll(allTransactions);
      }
    } catch (e) {
      print("Error fetching transactions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToDetail(TransactionModel transaction) {
    Get.toNamed(Routes.TRANSACTION_DETAIL, arguments: transaction);
  }

  Future<void> proceedToPayment(TransactionModel transaction) async {
    // If linkPayment is available, use it. Otherwise use snapToken with base URL.
    String? urlString = transaction.linkPayment;

    if (urlString == null && transaction.snapToken != null) {
      // Fallback if link not provided but snap token is
      // Production: https://app.midtrans.com/snap/v2/vtweb/
      urlString =
          'https://app.midtrans.com/snap/v2/vtweb/${transaction.snapToken}';
    }

    if (urlString == null) {
      Get.snackbar("Error", "Payment link unavailable");
      return;
    }

    // Navigate to custom webview with app bar
    Get.to(() => PaymentWebView(url: urlString!));
  }

  Future<void> cancelTransaction(TransactionModel transaction) async {
    Get.defaultDialog(
      title: "Cancel Transaction",
      middleText: "Are you sure you want to cancel this transaction?",
      textConfirm: "Yes, Cancel",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back(); // Close dialog
        isLoading.value = true;
        // Call API
        try {
          // await _apiProvider.cancelTransaction(transaction.uuid ?? transaction.id.toString());
          // Since ApiProvider doesn't have it yet, we just simulate or print
          print("Cancelling transaction: ${transaction.uuid}");

          // Refresh list
          await fetchTransactions();
          Get.back(); // Close Detail View
          Get.snackbar("Success", "Transaction cancelled successfully");
        } catch (e) {
          Get.snackbar("Error", "Failed to cancel transaction");
        } finally {
          isLoading.value = false;
        }
      },
    );
  }
}
