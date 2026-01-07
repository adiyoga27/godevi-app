import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/package_model.dart';
import 'package:intl/intl.dart';

class BookingController extends GetxController {
  final PackageModel? package = Get.arguments as PackageModel?;

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

  void submitBooking() {
    // Validate inputs
    // Call API (Future implementation)
    Get.snackbar("Success", "Booking submitted! (Simulation)");
  }
}
