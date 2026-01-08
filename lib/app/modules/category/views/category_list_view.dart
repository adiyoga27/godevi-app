import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/data/models/article_model.dart';
import 'package:godevi_app/app/data/models/event_model.dart';
import 'package:godevi_app/app/data/models/homestay_model.dart';
import 'package:godevi_app/app/data/models/package_model.dart';
import 'package:godevi_app/app/modules/category/controllers/category_list_controller.dart';
import 'package:godevi_app/app/modules/shared/widgets/skeletons_widget.dart';
import 'package:godevi_app/app/modules/home/views/widgets/article_list_card.dart';
import 'package:godevi_app/app/modules/home/views/widgets/event_card.dart';
import 'package:godevi_app/app/modules/home/views/widgets/homestay_card.dart';
import 'package:godevi_app/app/modules/home/views/widgets/package_list_card.dart';
import 'package:godevi_app/core/theme/app_theme.dart';

class CategoryListView extends GetView<CategoryListController> {
  const CategoryListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.title,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ListSkeleton();
        }

        if (controller.items.isEmpty) {
          return const Center(child: Text("No items found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            final item = controller.items[index];

            if (item is PackageModel) {
              return PackageListCard(package: item);
            } else if (item is EventModel) {
              return EventCard(event: item);
            } else if (item is HomestayModel) {
              return HomestayCard(homestay: item);
            } else if (item is ArticleModel) {
              return ArticleListCard(article: item);
            }
            return const SizedBox();
          },
        );
      }),
    );
  }
}
