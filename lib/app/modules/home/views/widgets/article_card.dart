import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:godevi_app/app/data/models/article_model.dart';

import 'package:get/get.dart';
import 'package:godevi_app/app/modules/home/controllers/home_controller.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';
import 'package:godevi_app/app/routes/app_pages.dart';
import 'package:godevi_app/app/modules/article_list/controllers/article_list_controller.dart'
    as godevi_app;
import 'package:intl/intl.dart';

class ArticleCard extends StatelessWidget {
  final ArticleModel article;
  final double? width;

  const ArticleCard({Key? key, required this.article, this.width})
    : super(key: key);

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
      width: width ?? double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  const SizedBox(height: 4),
                  Text(
                    (article.postContent ?? '').replaceAll(
                      RegExp(r'<[^>]*>'),
                      '',
                    ), // Strip HTML tags
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
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
    return Obx(() {
      ArticleModel? reactiveArticle;
      dynamic activeController;

      // Try finding ArticleListController
      if (Get.isRegistered<godevi_app.ArticleListController>()) {
        final alc = Get.find<godevi_app.ArticleListController>();
        // Check regular list
        reactiveArticle = alc.articles.firstWhereOrNull(
          (e) => e.id == article.id,
        );
        // Check popular list if not found
        reactiveArticle ??= alc.popularArticles.firstWhereOrNull(
          (e) => e.id == article.id,
        );
        if (reactiveArticle != null) activeController = alc;
      }

      // If not found, try HomeController
      if (reactiveArticle == null && Get.isRegistered<HomeController>()) {
        final hc = Get.find<HomeController>();
        reactiveArticle = hc.articles.firstWhereOrNull(
          (e) => e.id == article.id,
        );
        if (reactiveArticle != null) activeController = hc;
      }

      // Fallback if not found in any reactive list (shouldn't happen if hierarchy is correct)
      final currentArticle = reactiveArticle ?? article;

      final authService = Get.find<AuthService>();
      final userId = authService.user.value?.id;
      final isLiked = currentArticle.likedBy?.contains(userId) ?? false;
      final likeCount = currentArticle.likedBy?.length ?? 0;

      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (activeController != null) {
              activeController.toggleLike(currentArticle);
            } else {
              // Fallback: try using HomeController even if article not in its list (e.g. from deep link?)
              if (Get.isRegistered<HomeController>()) {
                Get.find<HomeController>().toggleLike(currentArticle);
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.grey,
                  size: 20,
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
          ),
        ),
      );
    });
  }
}
