import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:godevi_app/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.package == null) {
      return const Scaffold(body: Center(child: Text("Package not found")));
    }

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    // Determine info price
    final displayPrice =
        (controller.package?.disc != null && controller.package!.disc! > 0)
        ? controller.package!.disc!
        : controller.package?.price ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: const Text(
          "Booking Form",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Package Visualization (Standard for both Tour and Event)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: controller.package?.defaultImg ?? '',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.package?.type == 'event'
                            ? "Event Name"
                            : "Tour Packages Name",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        controller.package?.name ?? '-',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.package?.type == 'event'
                            ? "Category"
                            : "Type",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        controller.package?.categoryName ?? '-',
                        style: TextStyle(
                          fontSize: 14, // Slightly bigger than label
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currencyFormatter.format(displayPrice),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "/per pax",
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(), // Separator

            const SizedBox(height: 30),
            _buildSectionTitle("Customer Information"),
            const SizedBox(height: 16),
            _buildTextField("Customer Name", controller.nameController),
            const SizedBox(height: 16),
            _buildTextField(
              "Email",
              controller.emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField("Address", controller.addressController),
            const SizedBox(height: 16),
            _buildTextField(
              "Phone",
              controller.phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildDropdownGender(),

            const SizedBox(height: 30),
            _buildSectionTitle(
              controller.package?.type == 'event'
                  ? "Reservation Information"
                  : "Book Information",
            ),
            const SizedBox(height: 16),
            // Check-in Date (Only for Tour and Homestay)
            if (controller.package?.type != 'event') ...[
              GestureDetector(
                onTap: () => controller.selectDate(context),
                child: AbsorbPointer(
                  child: _buildTextField(
                    "Check-in Date",
                    controller.dateController,
                    suffixIcon: Icons.calendar_today,
                    hint: "Select Date",
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            _buildTextField(
              "Pax",
              controller.paxController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (context) {
                final price =
                    (controller.package?.disc != null &&
                        controller.package!.disc! > 0)
                    ? controller.package!.disc!
                    : controller.package?.price ?? 0;
                return _buildReadOnlyField(
                  "Price / Pax",
                  currencyFormatter.format(price),
                );
              },
            ),
            if (controller.package?.type == 'event')
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildTextField(
                  "Special Note",
                  controller.noteController,
                  maxLines: 4,
                  hint: "Input your note transaction",
                ),
              ),

            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),

            // Total and Button
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Total : ${currencyFormatter.format(controller.totalPrice.value)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D0846),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                "*Please check your form, because the order cannot be changed",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // Match design
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "To Payment",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0D0846),
      ),
    );
  }

  Widget _buildReadOnlyTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) =>
      _buildReadOnlyTextField(label, value);

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    String? hint,
    TextInputType? keyboardType,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 20) : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
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

  Widget _buildDropdownGender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gender",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.gender.value,
                isExpanded: true,
                items: <String>['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) controller.gender.value = newValue;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
