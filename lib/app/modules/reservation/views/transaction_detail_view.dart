import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/transaction_model.dart';
import 'package:godevi_app/app/modules/reservation/controllers/reservation_controller.dart'
    as reservation;
import 'package:godevi_app/app/modules/reservation/controllers/transaction_detail_controller.dart';
import 'package:intl/intl.dart';

class TransactionDetailView extends GetView<TransactionDetailController> {
  const TransactionDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controller is injected via Binding
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transaction Detail",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final transaction = controller.transaction.value;
        if (transaction == null) {
          return const Center(child: Text("Transaction not found"));
        }

        final currencyFormatter = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp',
          decimalDigits: 0,
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Image & Status
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: transaction.image ?? '',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(transaction.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        transaction.status ?? 'Unknown',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Title & Price
              Text(
                transaction.name ?? 'No Name',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currencyFormatter.format(transaction.total ?? 0),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Transaction Info
              _buildSectionHeader("Transaction Info"),
              _buildInfoRow("Type", transaction.category ?? '-'),
              _buildInfoRow("Code", transaction.code ?? '-'),
              _buildInfoRow("Date", _formatDate(transaction.date)),
              _buildInfoRow("Location", transaction.location ?? '-'),
              const Divider(height: 30),

              // Customer Info
              _buildSectionHeader("Customer Info"),
              _buildInfoRow("Name", transaction.customerName ?? '-'),
              _buildInfoRow("Email", transaction.customerEmail ?? '-'),
              _buildInfoRow("Phone", transaction.customerPhone ?? '-'),
              _buildInfoRow("Address", transaction.customerAddress ?? '-'),
              const Divider(height: 30),

              // Payment Info
              _buildSectionHeader("Payment Info"),
              _buildInfoRow(
                "Package Price",
                currencyFormatter.format(transaction.price ?? 0),
              ),
              _buildInfoRow(
                "Total Payment",
                currencyFormatter.format(transaction.total ?? 0),
              ),
              _buildInfoRow("Payment Type", transaction.paymentType ?? '-'),
              _buildInfoRow("Payment Date", transaction.paymentDate ?? '-'),
              _buildInfoRow("Payment Status", transaction.status ?? '-'),
              const Divider(height: 30),

              // Notes
              if (transaction.specialNote != null &&
                  transaction.specialNote!.isNotEmpty) ...[
                _buildSectionHeader("Details & Notes"),
                Text(
                  transaction.specialNote!,
                  style: TextStyle(color: Colors.grey[800], height: 1.5),
                ),
                const SizedBox(height: 20),
              ],

              // Spacing for bottom button
              const SizedBox(height: 80),
            ],
          ),
        );
      }),
      bottomSheet: Obx(() {
        if (controller.isLoading.value ||
            controller.transaction.value == null) {
          return const SizedBox.shrink();
        }
        return _buildBottomActions(context, controller.transaction.value!);
      }),
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    TransactionModel transaction,
  ) {
    // Show actions if status is pending, unpaid, or null (assuming null might mean new/unpaid)
    bool showActions =
        transaction.status?.toLowerCase() == 'pending' ||
        transaction.status == null ||
        transaction.status?.toLowerCase() ==
            'alert' || // Assuming 'alert'/unpaid status
        transaction.status?.toLowerCase() == 'unpaid';

    if (!showActions) return const SizedBox.shrink();

    // Ideally we should use TransactionDetailController logic,
    // but reusing ReservationController logic if available:
    final resController = Get.find<reservation.ReservationController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => resController.cancelTransaction(transaction),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Cancel Payment"),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => resController.proceedToPayment(transaction),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("To Payment"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    final s = status.toLowerCase();
    if (s == 'success' || s == 'paid') return Colors.green;
    if (s == 'pending') return Colors.orange;
    if (s == 'cancelled' || s == 'expire' || s == 'deny') return Colors.red;
    return Colors.blue;
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
