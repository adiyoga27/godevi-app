import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:intl/intl.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If no package is passed, maybe show error or go back
    if (controller.package == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking')),
        body: const Center(child: Text("No package selected")),
      );
    }

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Confirmation'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Package Summary
            // Package Details Header
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                controller.package?.defaultImg ?? '',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.isEvent
                            ? "Event Name"
                            : controller.isHomestay
                            ? "Homestay Name"
                            : "Tour Packages Name",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.package?.name ?? 'Package Name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Type",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        controller.package?.categoryName ?? '-',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currencyFormatter.format(
                        (controller.package?.disc != null &&
                                controller.package!.disc! > 0)
                            ? controller.package!.disc
                            : controller.package!.price ?? 0,
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Or primary color if preferred
                      ),
                    ),
                    const Text(
                      "/pax", // Assuming per pax
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(thickness: 1),

            const Text(
              "Customer Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildLabelTextField(
              label: "Customer Name",
              controller: controller.nameController,
              hint: "Enter your name",
            ),
            const SizedBox(height: 16),
            _buildLabelTextField(
              label: "Email",
              controller: controller.emailController,
              hint: "Enter your email",
              inputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildLabelTextField(
              label: "Address",
              controller: controller.addressController,
              hint: "Enter your address",
              maxLines: 1,
            ),
            const SizedBox(height: 16),
            _buildLabelTextField(
              label: "Phone",
              controller: controller.phoneController,
              hint: "Enter your phone number",
              inputType: TextInputType.phone,
            ),

            const SizedBox(height: 24),
            const Text(
              "Booking Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Date Picker
            if (!controller.isEvent)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Check-in Date",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.dateController,
                      readOnly: true,
                      onTap: () => controller.selectDate(context),
                      decoration: InputDecoration(
                        hintText: 'Select Date',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        suffixIcon: const Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: Colors.grey,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            _buildLabelTextField(
              label: "Quantity (Pax)",
              controller: controller.paxController,
              inputType: TextInputType.number,
            ),

            const SizedBox(height: 16),
            _buildLabelTextField(
              label: "Special Notes",
              controller: controller.noteController,
              maxLines: 3,
              hint: "Any special requests?",
            ),

            const SizedBox(height: 32),

            // Total Price Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Payment",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Obx(
                    () => Text(
                      currencyFormatter.format(controller.totalPrice.value),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.submitBooking,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Confirm Booking",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: inputType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
