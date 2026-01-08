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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: article.postThumbnail ?? '',
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            Container(color: Colors.grey[200]),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                              Colors.black.withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  transform: Matrix4.translationValues(0, -20, 0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Categories or Tags could go here
                        Text(
                          article.postTitle ?? '',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                            color: Colors.black87,
                            fontFamily: 'Inter', // Assuming Inter or similar
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.grey[200],
                              child: const Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article.postAuthor != null &&
                                          article.postAuthor!.length > 3
                                      ? article.postAuthor!
                                      : 'Godevi Contributor',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: _buildLikeSection(article),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        const Divider(height: 1),
                        const SizedBox(height: 24),

                        Html(
                          data: article.postContent ?? '',
                          style: {
                            "body": Style(
                              fontSize: FontSize(16),
                              lineHeight: LineHeight(1.6),
                              color: Colors.black87,
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                            ),
                            "p": Style(margin: Margins.only(bottom: 16)),
                            "img": Style(
                              width: Width(100, Unit.percent),
                              height: Height.auto(),
                            ),
                          },
                        ),

                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: _buildCommentSection(
                            Get.find<ArticleDetailController>(),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLikeSection(ArticleModel article) {
    return Obx(() {
      final homeController = Get.find<HomeController>();
      final reactiveArticle = homeController.articles.firstWhere(
        (element) => element.id == article.id,
        orElse: () => article,
      );

      final authService = Get.find<AuthService>();
      final userId = authService.user.value?.id;
      final isLiked = reactiveArticle.likedBy?.contains(userId) ?? false;
      final likeCount = reactiveArticle.likedBy?.length ?? 0;

      return InkWell(
        onTap: () => homeController.toggleLike(reactiveArticle),
        borderRadius: BorderRadius.circular(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              "$likeCount",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isLiked ? Colors.red : Colors.grey[700],
              ),
            ),
          ],
        ),
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
