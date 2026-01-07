import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:godevi_app/app/data/models/village_model.dart';

class VillageCard extends StatelessWidget {
  final VillageModel village;

  const VillageCard({Key? key, required this.village}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: widget(
              height: 120,
              width: 160,
              // Fallback or placeholder since defaultImg might be missing in VillageModel from API response review
              // Assuming derived or using first image if available
              child: CachedNetworkImage(
                imageUrl:
                    village.thumbnail ?? 'https://via.placeholder.com/160x120',
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            village.villageName ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            village.villageAddress ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget widget({
    required double height,
    required double width,
    required Widget child,
  }) {
    return SizedBox(height: height, width: width, child: child);
  }
}
