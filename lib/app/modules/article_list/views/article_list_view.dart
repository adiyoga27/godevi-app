import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/modules/article_list/controllers/article_list_controller.dart';
import 'package:godevi_app/app/modules/home/views/widgets/article_card.dart';

class ArticleListView extends GetView<ArticleListController> {
  const ArticleListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Slightly off-white background
      appBar: AppBar(
        title: const Text(
          'Discover Articles',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: CustomScrollView(
        slivers: [
          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for articles...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onSubmitted: (value) => controller.search(value),
                ),
              ),
            ),
          ),

          // Popular Articles Section (Only if not searching)
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.keyword.isNotEmpty ||
                  controller.popularArticles.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      'Popular Now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.popularArticles.length,
                      itemBuilder: (context, index) {
                        return ArticleCard(
                          article: controller.popularArticles[index],
                          width: 280,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }),
          ),

          // All Articles / Search Results Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Obx(
                () => Text(
                  controller.keyword.isEmpty
                      ? 'All Articles'
                      : 'Search Results',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Article List
          Obx(() {
            if (controller.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.articles.isEmpty) {
              return const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No articles found.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: ArticleCard(article: controller.articles[index]),
                );
              }, childCount: controller.articles.length),
            );
          }),

          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }
}
