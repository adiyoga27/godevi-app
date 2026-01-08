import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:godevi_app/app/modules/search/controllers/search_controller.dart'
    as app;
import 'package:godevi_app/app/data/models/search_result_model.dart';
import 'package:godevi_app/app/data/models/package_model.dart';
import 'package:godevi_app/app/data/models/homestay_model.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';
import 'package:godevi_app/app/routes/app_pages.dart';

class SearchView extends GetView<app.SearchController> {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: TextField(
          controller: textController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search tours, events, homestays...',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onSubmitted: (value) => controller.search(value),
          onChanged: (value) {
            if (value.length >= 3) {
              controller.search(value);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () => controller.search(textController.text),
          ),
          Obx(
            () => controller.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      textController.clear();
                      controller.clearSearch();
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(controller.errorMessage.value),
              ],
            ),
          );
        }

        if (controller.searchResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  controller.searchQuery.value.isEmpty
                      ? 'Start typing to search'
                      : 'No results found',
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.searchResults.length,
          itemBuilder: (context, index) {
            final item = controller.searchResults[index];
            return _buildSearchResultCard(item);
          },
        );
      }),
    );
  }

  Widget _buildSearchResultCard(SearchResultModel item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToDetail(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: item.thumbnail ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(item.type),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.type.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Name
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'tour':
        return Colors.blue;
      case 'event':
        return Colors.orange;
      case 'homestay':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> _navigateToDetail(SearchResultModel item) async {
    print('\x1B[33m[Search] Navigating to: ${item.type}/${item.slug}\x1B[0m');

    // Show loading indicator
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final apiProvider = Get.find<ApiProvider>();
      Response response;

      switch (item.type.toLowerCase()) {
        case 'tour':
          response = await apiProvider.getTourBySlug(item.slug);
          break;
        case 'event':
          response = await apiProvider.getEventBySlug(item.slug);
          break;
        case 'homestay':
          response = await apiProvider.getHomestayBySlug(item.slug);
          break;
        default:
          Get.back(); // Close loading
          Get.snackbar('Error', 'Unknown item type: ${item.type}');
          return;
      }

      Get.back(); // Close loading

      print(
        '\x1B[33m[Search] Detail Response Status: ${response.statusCode}\x1B[0m',
      );
      print('\x1B[33m[Search] Detail Response Body: ${response.body}\x1B[0m');

      if (response.statusCode == 200 && response.body != null) {
        // Detail API returns {data: {...}} directly, not {status: true, data: {...}}
        final body = response.body;
        Map<String, dynamic>? data;

        // Handle both response formats
        if (body is Map<String, dynamic>) {
          if (body.containsKey('data') &&
              body['data'] is Map<String, dynamic>) {
            data = body['data'];
          } else if (body.containsKey('id')) {
            // Response is the data directly
            data = body;
          }
        }

        if (data != null) {
          print('\x1B[32m[Search] Data received: $data\x1B[0m');

          PackageModel package;

          // Use appropriate model based on type
          if (item.type.toLowerCase() == 'homestay') {
            final homestay = HomestayModel.fromJson(data);
            package = homestay.toPackageModel();
            print(
              '\x1B[32m[Search] Homestay parsed: ${homestay.name}, owner: ${homestay.ownerName}\x1B[0m',
            );
          } else {
            package = PackageModel.fromJson(data);
            package.type = item.type.toLowerCase();
          }

          print(
            '\x1B[32m[Search] Package created: id=${package.id}, name=${package.name}, type=${package.type}\x1B[0m',
          );

          Get.toNamed(Routes.DETAIL, arguments: package);
        } else {
          print('\x1B[31m[Search] Could not parse data from response\x1B[0m');
          Get.snackbar(
            'Error',
            'Could not parse response data',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        final errorMsg = response.body['message'] ?? 'Failed to load details';
        print('\x1B[31m[Search] API Error: $errorMsg\x1B[0m');
        Get.snackbar(
          'Error',
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stackTrace) {
      Get.back(); // Close loading if open
      print('\x1B[31m[Search] Error loading detail: $e\x1B[0m');
      print(
        '\x1B[31m[Search] Stack: ${stackTrace.toString().split('\n').take(5).join('\n')}\x1B[0m',
      );
      Get.snackbar(
        'Error',
        'Failed to load details: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
