import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/article_model.dart';
import 'package:godevi_app/app/modules/home/controllers/home_controller.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';
import 'package:godevi_app/app/modules/home/controllers/article_detail_controller.dart';
import 'package:godevi_app/app/modules/article_list/controllers/article_list_controller.dart'
    as godevi_app;
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
        final homeController = Get.find<HomeController>();
        reactiveArticle = homeController.articles.firstWhereOrNull(
          (element) => element.id == article.id,
        );
        reactiveArticle ??= homeController.popularArticles.firstWhereOrNull(
          (element) => element.id == article.id,
        );
        if (reactiveArticle != null) activeController = homeController;
      }

      final currentArticle = reactiveArticle ?? article;

      final authService = Get.find<AuthService>();
      final userId = authService.user.value?.id;
      final isLiked = currentArticle.likedBy?.contains(userId) ?? false;
      final likeCount = currentArticle.likedBy?.length ?? 0;

      return InkWell(
        onTap: () {
          if (activeController != null) {
            activeController.toggleLike(currentArticle);
          } else {
            if (Get.isRegistered<HomeController>()) {
              Get.find<HomeController>().toggleLike(currentArticle);
            }
          }
        },
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
        Obx(
          () => Text(
            "Comments (${controller.comments.length})",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),

        // Input Area
        Obx(() {
          if (!authService.isLoggedIn.value) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Column(
                children: [
                  const Text("Join the discussion"),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/login'),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Login to Comment"),
                  ),
                ],
              ),
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: authService.user.value?.avatar != null
                    ? CachedNetworkImageProvider(
                        authService.user.value!.avatar!,
                      )
                    : null,
                child: authService.user.value?.avatar == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: controller.commentController,
                      decoration: InputDecoration(
                        hintText: "What are your thoughts?",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: controller.isPostingComment.value
                          ? null
                          : () => controller.postComment(),
                      icon: controller.isPostingComment.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send, size: 16),
                      label: const Text("Post"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),

        const SizedBox(height: 24),

        // Comment List
        Obx(() {
          if (controller.isLoadingComments.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.comments.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 48,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "No comments yet. Be the first!",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.comments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final comment = controller.comments[index];
              final isOwner = authService.user.value?.id == comment.userId;

              // Format date if available
              String timeAgo = '';
              if (comment.createdAt != null) {
                // Simple parsing or use timeago package if available.
                // Fallback to raw string
                timeAgo = comment.createdAt!;
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: comment.userAvatar != null
                        ? CachedNetworkImageProvider(comment.userAvatar!)
                        : null,
                    radius: 18,
                    child: comment.userAvatar == null
                        ? const Icon(Icons.person, size: 20)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                comment.userName ?? 'User',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              if (timeAgo.isNotEmpty)
                                Text(
                                  timeAgo,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment.comment ?? '',
                            style: TextStyle(
                              color: Colors.grey[800],
                              height: 1.4,
                            ),
                          ),
                          if (isOwner) ...[
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () =>
                                    controller.deleteComment(comment.id!),
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ],
    );
  }
}
