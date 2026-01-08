import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/article_model.dart';
import 'package:godevi_app/app/data/models/comment_model.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';

class ArticleDetailController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final AuthService _authService = Get.find<AuthService>();

  late ArticleModel article;
  final comments = <CommentModel>[].obs;
  final isLoadingComments = true.obs;
  final isPostingComment = false.obs;
  final commentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    article = Get.arguments;
    if (article.slug != null) {
      fetchComments(article.slug!);
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  Future<void> fetchComments(String slug) async {
    isLoadingComments.value = true;
    try {
      final response = await _apiProvider.getComments(slug);
      if (response.statusCode == 200 && response.body['status'] == true) {
        final data = response.body['data'] as List;
        comments.assignAll(data.map((e) => CommentModel.fromJson(e)).toList());
      }
    } catch (e) {
      print("Error fetching comments: $e");
    } finally {
      isLoadingComments.value = false;
    }
  }

  Future<void> postComment() async {
    if (commentController.text.trim().isEmpty) return;
    if (!_authService.isLoggedIn.value) {
      Get.toNamed('/login');
      return;
    }

    isPostingComment.value = true;
    try {
      final response = await _apiProvider.postComment(
        article.slug ?? '',
        commentController.text,
      );

      if (response.statusCode == 200) {
        // Assuming 200 OK or 201 Created
        commentController.clear();
        fetchComments(article.slug ?? '');
        Get.snackbar("Success", "Comment posted successfully");
      } else {
        Get.snackbar("Error", "Failed to post comment: ${response.statusText}");
      }
    } catch (e) {
      print("Error posting comment: $e");
      Get.snackbar("Error", "An unexpected error occurred");
    } finally {
      isPostingComment.value = false;
    }
  }

  Future<void> deleteComment(int id) async {
    try {
      final response = await _apiProvider.deleteComment(id);
      if (response.statusCode == 200) {
        comments.removeWhere((c) => c.id == id);
        Get.snackbar("Success", "Comment deleted");
      } else {
        Get.snackbar("Error", "Failed to delete comment");
      }
    } catch (e) {
      print("Error deleting comment: $e");
    }
  }
}
