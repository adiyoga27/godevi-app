import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/article_model.dart';
import 'package:godevi_app/app/modules/home/controllers/home_controller.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';
import 'package:godevi_app/app/modules/home/controllers/article_detail_controller.dart';
import 'package:intl/intl.dart';

class ArticleDetailView extends StatelessWidget {
  const ArticleDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ArticleDetailController());
    final ArticleModel article = Get.arguments;

    String formattedDate = '';
    if (article.createdAt != null) {
      try {
        DateTime date = DateTime.parse(article.createdAt!);
        formattedDate = DateFormat('dd MMM yyyy').format(date);
      } catch (e) {
        formattedDate = article.createdAt!;
      }
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: article.postThumbnail ?? '',
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
                  Text(
                    article.postTitle ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildLikeSection(article),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      if (article.postAuthor != null) ...[
                        const SizedBox(width: 15),
                        const Icon(Icons.person, size: 14, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          'Author: ${article.postAuthor}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  Html(data: article.postContent ?? ''),
                  const SizedBox(height: 20),
                  const Divider(),
                  _buildCommentSection(Get.find<ArticleDetailController>()),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikeSection(ArticleModel article) {
    return Obx(() {
      final homeController = Get.find<HomeController>();
      // Find the latest version of this article from the controller's list
      final reactiveArticle = homeController.articles.firstWhere(
        (element) => element.id == article.id,
        orElse: () => article,
      );

      final authService = Get.find<AuthService>();
      final userId = authService.user.value?.id;
      final isLiked = reactiveArticle.likedBy?.contains(userId) ?? false;
      final likeCount = reactiveArticle.likedBy?.length ?? 0;

      return Row(
        children: [
          IconButton(
            onPressed: () => homeController.toggleLike(reactiveArticle),
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey,
              size: 28,
            ),
          ),
          Text(
            "$likeCount Likes",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      );
    });
  }

  Widget _buildCommentSection(ArticleDetailController controller) {
    final authService = Get.find<AuthService>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Comments",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // Comment List
        Obx(() {
          if (controller.isLoadingComments.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.comments.isEmpty) {
            return const Text(
              "No comments yet.",
              style: TextStyle(color: Colors.grey),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.comments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 15),
            itemBuilder: (context, index) {
              final comment = controller.comments[index];
              final isOwner = authService.user.value?.id == comment.userId;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: comment.userAvatar != null
                        ? CachedNetworkImageProvider(comment.userAvatar!)
                        : null,
                    radius: 20,
                    child: comment.userAvatar == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.userName ?? 'User',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(comment.comment ?? ''),
                      ],
                    ),
                  ),
                  if (isOwner)
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () => controller.deleteComment(comment.id!),
                    ),
                ],
              );
            },
          );
        }),

        const SizedBox(height: 20),
        const Divider(),

        // Create Comment
        Obx(() {
          if (!authService.isLoggedIn.value) {
            return Center(
              child: ElevatedButton(
                onPressed: () => Get.toNamed('/login'),
                child: const Text("Login to Comment"),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: controller.commentController,
                decoration: const InputDecoration(
                  hintText: "Write a comment...",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: controller.isPostingComment.value
                    ? null
                    : () => controller.postComment(),
                child: controller.isPostingComment.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Post Comment"),
              ),
            ],
          );
        }),
      ],
    );
  }
}
