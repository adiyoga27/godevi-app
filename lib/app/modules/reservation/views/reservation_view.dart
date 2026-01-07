import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/transaction_model.dart';
import 'package:godevi_app/app/modules/reservation/controllers/reservation_controller.dart';
import 'package:godevi_app/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class ReservationView extends GetView<ReservationController> {
  const ReservationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Reservasi",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.transactions.isEmpty) {
                return const Center(child: Text("No transactions found"));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.transactions.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildTransactionCard(controller.transactions[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(() {
        return Row(
          children: [
            _buildTabItem("Not Paid", 0),
            _buildTabItem("Paid", 1),
            _buildTabItem("Finished", 2),
          ],
        );
      }),
    );
  }

  Widget _buildTabItem(String label, int index) {
    bool isActive = controller.currentTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive
                ? Colors.transparent
                : Colors.transparent, // Highlight background usually?
            // User image shows just text color change or maybe background?
            // Image shows: Grey background containing pill. Active one has separate background?
            // Looking at image: The whole container is grey. The active tab has a WHITE (or light green?) background pill.
            // Wait, standard design is: Background container grey. Active tab gets a pill shape.
            // Let's assume active gets a white shadow/card look or green text.
            // Image 1: "Not Paid" is active, Green text?, gray bg? No, look at "Paid" active in middle image.
            // It seems the active tab has a distinct background color (maybe white or light green accent).
            // Let's iterate: Active = White/Green pill. Inactive = Transparent.
            // I'll make active tab have a Color(0xFFE0F2F1) (light teal) and Green text.
          ),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white
                  : Colors.transparent, // Active gets white card
              borderRadius: BorderRadius.circular(18),
              boxShadow: isActive
                  ? [BoxShadow(color: Colors.black12, blurRadius: 2)]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.green : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(TransactionModel transaction) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Ideally navigate to a Transaction Detail page.
            // But we can try to navigate to the product detail page for re-booking or viewing.
            // However, the user likely wants to see the specific transaction status.
            // Since there is no specific "Transaction Detail Request" in the prompt other than "muncul detailnya",
            // I will navigate to the DetailView (Product) using the data we have.

            // Importing PackageModel is needed here.
            // Instead of complicating imports, I will pass a Map or rely on dynamic arguments if DetailView supports it.
            // DetailView expects `package` argument as PackageModel.

            // I will use a helper method in Controller to handle navigation to keep View clean
            // and avoid import issues if PackageModel isn't imported.
            controller.navigateToDetail(transaction);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: transaction.image ?? '',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(transaction.category),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        transaction.category ?? 'Other',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        color: Colors.teal,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            transaction.name ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          currencyFormatter.format(transaction.total ?? 0),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.location ?? '-',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Star Ratings (Mocked or real)
                        if (transaction.rating != null)
                          ...List.generate(5, (index) {
                            return Icon(
                              index < (transaction.rating ?? 0).round()
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 14,
                              color: index < (transaction.rating ?? 0).round()
                                  ? Colors.amber
                                  : Colors.grey[300],
                            );
                          }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String? category) {
    if (category == null) return Colors.grey;
    final catLower = category.toLowerCase();
    if (catLower.contains('tour')) return Colors.blue;
    if (catLower.contains('event')) return Colors.orange;
    if (catLower.contains('homestay')) return Colors.green;
    return Colors.teal;
  }
}
