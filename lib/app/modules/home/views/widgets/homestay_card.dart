import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/homestay_model.dart';
import 'package:godevi_app/app/routes/app_pages.dart';
import 'package:godevi_app/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class HomestayCard extends StatelessWidget {
  final HomestayModel homestay;
  final double? width;

  const HomestayCard({Key? key, required this.homestay, this.width})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isListMode = width == null;

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Container(
      width: width,
      margin: isListMode ? const EdgeInsets.only(bottom: 20) : null,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Map HomestayModel to PackageModel for DetailView
          final package = HomestayModel(
            id: homestay.id,
            name: homestay.name,
            description:
                "${homestay.description ?? ''}<br><br><b>Location:</b> ${homestay.location ?? '-'}",
            price: homestay.price,
            defaultImg: homestay.defaultImg,
            categoryName: homestay.categoryName ?? 'Homestay',
            // type: 'homestay', // Crucial for BookingController
            facilities: homestay.facilities, // Map facilities to inclusion
            checkInTime: homestay.checkInTime,
            checkOutTime: homestay.checkOutTime,
            location: homestay.location,
            // Add other mappings if needed
          ).toPackageModel();
          Get.toNamed(Routes.DETAIL, arguments: package);
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: homestay.defaultImg ?? '',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    homestay.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          homestay.location ?? '',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormatter.format(homestay.price ?? 0),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
