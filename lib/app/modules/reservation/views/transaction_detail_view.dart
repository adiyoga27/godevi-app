import 'package:cached_network_image/cached_network_image.dart';
import 'package:godevi_app/core/theme/app_theme.dart';
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
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Transaction Detail",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.backgroundColor,
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
              _buildHeaderImage(transaction),
              const SizedBox(height: 20),

              // Title & Price Logic
              Text(
                transaction.name ?? 'No Name',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currencyFormatter.format(transaction.total ?? 0),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.teal.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Transaction Info Card
              _buildCard(
                title: "Transaction Info",
                children: [
                  _buildInfoRow(
                    Icons.confirmation_number_outlined,
                    "Code",
                    transaction.code ?? '-',
                  ),
                  _buildInfoRow(
                    Icons.category_outlined,
                    "Type",
                    transaction.category ?? '-',
                  ),
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    "Date",
                    _formatDate(transaction.date),
                  ),
                  _buildInfoRow(
                    Icons.place_outlined,
                    "Location",
                    transaction.location ?? '-',
                  ),
                ],
              ),

              // Customer Info Card
              _buildCard(
                title: "Customer Info",
                children: [
                  _buildInfoRow(
                    Icons.person_outline,
                    "Name",
                    transaction.customerName ?? '-',
                  ),
                  _buildInfoRow(
                    Icons.email_outlined,
                    "Email",
                    transaction.customerEmail ?? '-',
                  ),
                  _buildInfoRow(
                    Icons.phone_outlined,
                    "Phone",
                    transaction.customerPhone ?? '-',
                  ),
                  _buildInfoRow(
                    Icons.home_outlined,
                    "Address",
                    transaction.customerAddress ?? '-',
                  ),
                ],
              ),

              // Payment Info Card
              _buildCard(
                title: "Payment Info",
                children: [
                  _buildInfoRow(
                    Icons.people_outline,
                    "Pax",
                    "${transaction.pax ?? '-'} Person(s)",
                  ),
                  _buildInfoRow(
                    Icons.monetization_on_outlined,
                    "Package Price",
                    currencyFormatter.format(transaction.price ?? 0),
                  ),
                  _buildInfoRow(
                    Icons.payments_outlined,
                    "Total Payment",
                    currencyFormatter.format(transaction.total ?? 0),
                  ),
                  _buildInfoRow(
                    Icons.credit_card_outlined,
                    "Payment Type",
                    transaction.paymentType ?? '-',
                  ),
                  _buildInfoRow(
                    Icons.event_available_outlined,
                    "Payment Date",
                    transaction.paymentDate ?? '-',
                  ),
                  _buildInfoRow(
                    Icons.info_outline,
                    "Payment Status",
                    transaction.status ?? '-',
                  ),
                ],
              ),

              // Notes
              if (transaction.specialNote != null &&
                  transaction.specialNote!.isNotEmpty)
                _buildCard(
                  title: "Details & Notes",
                  children: [
                    Text(
                      transaction.specialNote!,
                      style: TextStyle(color: Colors.grey[800], height: 1.5),
                    ),
                  ],
                ),

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

  Widget _buildHeaderImage(TransactionModel transaction) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: transaction.image ?? '',
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              height: 220,
              color: Colors.grey[200],
              child: const Icon(Icons.image, size: 50, color: Colors.grey),
            ),
          ),
        ),
        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
              ),
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getStatusColor(transaction.status).withOpacity(0.9),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: _getStatusColor(transaction.status).withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  transaction.status ?? 'Unknown',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
        transaction.status?.toLowerCase() == 'alert' ||
        transaction.status?.toLowerCase() == 'unpaid';

    if (!showActions) return const SizedBox.shrink();

    final resController = Get.find<reservation.ReservationController>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => resController.cancelTransaction(transaction),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade400,
                side: BorderSide(color: Colors.red.shade200),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
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
                shadowColor: Colors.teal.withOpacity(0.4),
                elevation: 8,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "To Payment",
                style: TextStyle(fontWeight: FontWeight.bold),
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
