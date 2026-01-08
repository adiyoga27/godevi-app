import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/modules/article_list/controllers/article_list_controller.dart';
import 'package:godevi_app/app/modules/home/views/widgets/article_card.dart';

class ArticleListView extends GetView<ArticleListController> {
  const ArticleListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search articles...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (value) => controller.search(value),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.articles.isEmpty) {
                return const Center(child: Text('No articles found.'));
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.articles.length,
                itemBuilder: (context, index) {
                  return ArticleCard(article: controller.articles[index]);
                },
                separatorBuilder: (_, __) => const SizedBox(height: 16),
              );
            }),
          ),
        ],
      ),
    );
  }
}
