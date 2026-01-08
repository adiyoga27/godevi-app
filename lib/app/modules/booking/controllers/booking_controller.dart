import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/package_model.dart';
import 'package:intl/intl.dart';

import 'package:godevi_app/app/data/providers/api_provider.dart';
import 'package:godevi_app/app/routes/app_pages.dart';
import 'package:godevi_app/app/modules/reservation/views/payment_webview.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';
import 'package:godevi_app/app/modules/main/controllers/main_controller.dart';

class BookingController extends GetxController {
  final PackageModel? package = Get.arguments as PackageModel?;
  final AuthService _authService = Get.find<AuthService>();

  bool get isEvent {
    if (package == null) return false;
    print(
      "DEBUG: Checking isEvent. Type: ${package!.type}, Category: ${package!.categoryName}",
    );
    return (package!.type?.toLowerCase() == 'event') ||
        (package!.categoryName?.toLowerCase().contains('event') ?? false);
  }

  bool get isHomestay {
    if (package == null) return false;
    print(
      "DEBUG: Checking isHomestay. Type: ${package!.type}, Category: ${package!.categoryName}",
    );
    return (package!.type?.toLowerCase() == 'homestay') ||
        (package!.categoryName?.toLowerCase().contains('homestay') ?? false);
  }

  bool get isTour {
    if (package == null) return false;
    print(
      "DEBUG: Checking isTour. Type: ${package!.type}, Category: ${package!.categoryName}",
    );
    return (package!.type?.toLowerCase() == 'tour') ||
        (package!.categoryName?.toLowerCase().contains('tour') ?? false);
  }

  // Customer Info
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final gender = 'Male'.obs;

  // Booking Info
  final paxController = TextEditingController(text: '1');
  final dateController = TextEditingController();
  final pickupLocationController = TextEditingController();
  final hotelNameController = TextEditingController();
  final noteController = TextEditingController();

  final includePickup = false.obs;
  DateTime? selectedDate;

  // Calculated
  final totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();

    // Pre-fill user data
    if (_authService.isLoggedIn.value && _authService.user.value != null) {
      final user = _authService.user.value!;
      nameController.text = user.name ?? '';
      emailController.text = user.email ?? '';
      addressController.text = user.address ?? '';
      phoneController.text = user.phone ?? '';
    }

    if (package != null) {
      calculateTotal();
    }
    // Listen to pax changes
    paxController.addListener(calculateTotal);
  }

  void calculateTotal() {
    if (package == null) return;

    int pax = int.tryParse(paxController.text) ?? 0;

    // Determine base price (discounted or normal)
    double basePrice = 0;
    if (package!.disc != null && package!.disc! > 0) {
      basePrice = package!.disc!.toDouble();
    } else {
      basePrice = (package!.price ?? 0).toDouble();
    }

    totalPrice.value = basePrice * pax;
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    phoneController.dispose();
    paxController.dispose();
    dateController.dispose();
    pickupLocationController.dispose();
    hotelNameController.dispose();
    noteController.dispose();
    super.onClose();
  }

  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final RxBool isLoading = false.obs;

  void submitBooking() async {
    if (package == null) return;

    // Validate inputs
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        addressController.text.isEmpty ||
        paxController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    isLoading.value = true;

    try {
      final data = {
        'customer_name': nameController.text,
        'customer_email': emailController.text,
        'customer_phone': phoneController.text,
        'customer_address': addressController.text,
        'qty': paxController.text,
        'special_note': noteController.text.isEmpty ? '-' : noteController.text,
      };

      Response response;

      // Determine checkout type based on package info
      if (isEvent) {
        data['event_id'] = package!.id.toString();
        response = await _apiProvider.checkoutEvent(data);
      } else if (isHomestay) {
        if (dateController.text.isEmpty) {
          Get.snackbar("Error", "Please select check-in date");
          isLoading.value = false;
          return;
        }
        data['homestay_id'] = package!.id.toString();
        data['check_in'] = dateController.text;
        response = await _apiProvider.checkoutHomestay(data);
      } else {
        // Fallback: Assume it's a Tour if not Event or Homestay
        print("DEBUG: defaulted to Tour checkout.");
        if (dateController.text.isEmpty) {
          Get.snackbar("Error", "Please select check-in date");
          isLoading.value = false;
          return;
        }
        data['tour_id'] = package!.id.toString();
        data['check_in'] = dateController.text;
        response = await _apiProvider.checkoutTour(data);
      }

      if (response.statusCode == 200 && response.body['status'] == true) {
        final responseData = response.body['data'];
        final String? linkPayment = responseData['link_payment'];

        if (linkPayment != null) {
          // 1. Reset stack to Home (Main View)
          await Get.offAllNamed(Routes.HOME);

          // 2. Force initialization of MainController and set index to Reservation (1)
          try {
            final mainController = Get.find<MainController>();
            mainController.currentIndex.value = 1;
          } catch (e) {
            print("Error initializing MainController: $e");
          }

          // 3. Open Payment Page
          Get.to(() => PaymentWebView(url: linkPayment));
        } else {
          Get.snackbar("Success", "Booking Success but no payment link found.");
          await Get.offAllNamed(Routes.HOME);
          try {
            final mainController = Get.find<MainController>();
            mainController.currentIndex.value = 1;
          } catch (_) {}
        }
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Checkout Failed");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
