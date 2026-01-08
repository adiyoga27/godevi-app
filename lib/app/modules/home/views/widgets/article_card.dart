import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:godevi_app/app/data/models/article_model.dart';

import 'package:get/get.dart';
import 'package:godevi_app/app/modules/home/controllers/home_controller.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';
import 'package:godevi_app/app/routes/app_pages.dart';
import 'package:intl/intl.dart';

class ArticleCard extends StatelessWidget {
  final ArticleModel article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse date if possible
    String formattedDate = '';
    if (article.createdAt != null) {
      try {
        DateTime date = DateTime.parse(article.createdAt!);
        formattedDate = DateFormat('dd MMM yyyy').format(date);
      } catch (e) {
        formattedDate = article.createdAt!;
      }
    }

    return Container(
      width: 250,
      margin: const EdgeInsets.only(left: 20),
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
        onTap: () => Get.toNamed(Routes.ARTICLE_DETAIL, arguments: article),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: article.postThumbnail ?? '',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  height: 120,
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
                    article.postTitle ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      _buildLikeButton(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLikeButton() {
    final controller = Get.find<HomeController>();
    final authService = Get.find<AuthService>();
    final userId = authService.user.value?.id;

    final isLiked = article.likedBy?.contains(userId) ?? false;
    final likeCount = article.likedBy?.length ?? 0;

    return GestureDetector(
      onTap: () => controller.toggleLike(article),
      child: Row(
        children: [
          Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            "$likeCount",
            style: TextStyle(
              color: isLiked ? Colors.red : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
