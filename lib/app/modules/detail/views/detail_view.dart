import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/modules/detail/controllers/detail_controller.dart';
import 'package:godevi_app/core/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.package == null) {
      return const Scaffold(body: Center(child: Text("Package not found")));
    }

    final package = controller.package!;
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: package.defaultImg ?? '',
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    Container(color: Colors.grey),
              ),
            ),
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => Get.back(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Rating
                  Text(
                    package.name ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        (package.review != null)
                            ? package.review.toString()
                            : '0.0',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '(0 Reviews)',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Html(
                    data: package.description ?? '',
                    style: {
                      "body": Style(
                        margin: Margins.all(0),
                        padding: HtmlPaddings.all(0),
                        color: Colors.grey[800],
                        lineHeight: LineHeight(1.5),
                      ),
                    },
                  ),
                  const SizedBox(height: 20),

                  // Itinerary
                  if (package.itenaries != null) ...[
                    const Text(
                      "Itinerary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Html(
                      data: package.itenaries,
                      style: {
                        "body": Style(
                          margin: Margins.all(0),
                          padding: HtmlPaddings.all(0),
                          fontSize: FontSize(14),
                        ),
                        "li": Style(margin: Margins.only(bottom: 8)),
                      },
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Include
                  if (package.inclusion != null) ...[
                    const Text(
                      "Include",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Html(
                      data: package.inclusion,
                      style: {
                        "body": Style(
                          margin: Margins.all(0),
                          padding: HtmlPaddings.all(0),
                          fontSize: FontSize(14),
                        ),
                      },
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Terms
                  if (package.term != null) ...[
                    const Text(
                      "Terms",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Html(
                      data: package.term,
                      style: {
                        "body": Style(
                          margin: Margins.all(0),
                          padding: HtmlPaddings.all(0),
                          fontSize: FontSize(14),
                        ),
                      },
                    ),
                    const SizedBox(height: 30),
                  ],

                  // Some Information Box
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Some Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D0846),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildInfoItem(
                          icon: Icons.category,
                          label: "Category :",
                          value: package.categoryName ?? '-',
                          isPrice: false,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoItem(
                          icon: Icons.access_time,
                          label: "Durasi :",
                          value: _stripHtml(package.duration),
                          isPrice: false,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoItem(
                          icon: Icons.location_on_outlined,
                          label: "Lokasi :",
                          value: package.categoryName ?? '-',
                          isPrice: false,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoItem(
                          icon: Icons.person_outline,
                          label: "Per Person :",
                          isPrice: true,
                          valueWidget:
                              (package.disc != null && package.disc! > 0)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currencyFormatter.format(
                                        package.price ?? 0,
                                      ),
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      currencyFormatter.format(package.disc),
                                      style: const TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  currencyFormatter.format(package.price ?? 0),
                                  style: const TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: controller.onBookNow,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            "Book Now",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    String? value,
    Widget? valueWidget,
    required bool isPrice,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Icon(icon, size: 20, color: Colors.blue[300]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D0846),
                ),
              ),
              const SizedBox(height: 4),
              if (valueWidget != null)
                valueWidget
              else if (isPrice)
                Text(
                  value ?? '',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              else
                Text(
                  value ?? '',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _stripHtml(String? htmlString) {
    if (htmlString == null) return '-';
    // Remove HTML tags
    final document = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    var text = htmlString.replaceAll(document, '');
    // Remove explicit &nbsp; entities if any
    text = text.replaceAll('&nbsp;', ' ');
    return text.trim();
  }
}
