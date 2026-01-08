import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/routes/app_pages.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'icon': 'assets/icons/icon_homestay.png',
        'label': 'Village',
      }, // Reusing homestay icon or similar
      {'icon': 'assets/icons/icon_tour.png', 'label': 'Tour'},
      {'icon': 'assets/icons/icon_events.png', 'label': 'Events'},
      {'icon': 'assets/icons/icon_homestay.png', 'label': 'Homestay'},
      {'icon': 'assets/icons/icon_article.png', 'label': 'Article'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: categories.map((cat) {
          return Padding(
            padding: const EdgeInsets.only(
              right: 20.0,
            ), // Spacing between items
            child: GestureDetector(
              onTap: () {
                String label = cat['label'] as String;
                if (label == 'Village') {
                  Get.toNamed(Routes.VILLAGE_LIST);
                } else if (label == 'Article') {
                  Get.toNamed(Routes.ARTICLE_LIST);
                } else {
                  // Determine type based on label
                  String type = '';
                  if (label == 'Tour') type = 'tour';
                  if (label == 'Events') type = 'event';
                  if (label == 'Homestay') type = 'homestay';

                  Get.toNamed(
                    Routes.CATEGORY_LIST,
                    arguments: {'title': label, 'type': type},
                  );
                }
              },
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Image.asset(
                      cat['icon'] as String,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    cat['label'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
