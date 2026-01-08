import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/modules/home/controllers/home_controller.dart';
import 'package:godevi_app/app/routes/app_pages.dart';
import 'package:godevi_app/app/modules/shared/widgets/skeletons_widget.dart';
import 'package:godevi_app/app/modules/home/views/widgets/article_card.dart';
import 'package:godevi_app/app/modules/home/views/widgets/category_selector.dart';
import 'package:godevi_app/app/modules/home/views/widgets/home_header.dart';
import 'package:godevi_app/app/modules/home/views/widgets/homestay_card.dart';
import 'package:godevi_app/app/modules/home/views/widgets/home_slider.dart';
import 'package:godevi_app/app/modules/home/views/widgets/package_card.dart';
import 'package:godevi_app/app/modules/home/views/widgets/section_header.dart';
import 'package:godevi_app/app/modules/home/views/widgets/village_card.dart';
import 'package:godevi_app/core/theme/app_theme.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const HomeSkeleton();
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  // Stack for custom header background if needed, leveraging HomeHeader
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      HomeSlider(sliders: controller.sliders),
                      const HomeHeader(),
                      Positioned(
                        bottom: -25,
                        left: 20,
                        right: 20,
                        child: GestureDetector(
                          onTap: () => Get.toNamed(Routes.SEARCH),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Colors.grey),
                                const SizedBox(width: 12),
                                Text(
                                  'Where are you going?',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // Category Selector
                  const CategorySelector(),

                  // Popular Villages
                  SectionHeader(title: 'Popular Villages'),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.popularVillages.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              Routes.VILLAGE_DETAIL,
                              arguments: controller.popularVillages[index],
                            );
                          },
                          child: VillageCard(
                            village: controller.popularVillages[index],
                          ),
                        );
                      },
                    ),
                  ),

                  // Best Tour Packages
                  SectionHeader(title: 'Best Tour Packages'),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.bestPackages.length,
                    itemBuilder: (context, index) {
                      return PackageCard(
                        package: controller.bestPackages[index],
                        currentPosition: controller.currentPosition,
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Best Homestay
                  SectionHeader(title: 'Best Homestay'),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(right: 20),
                      itemCount: controller.bestHomestays.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: HomestayCard(
                            homestay: controller.bestHomestays[index],
                            width: 160,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  const SizedBox(height: 20),
                  // Latest Articles
                  SectionHeader(
                    title: 'Latest Articles',
                    onShowAll: controller.navigateToArticleList,
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.articles.length,
                    itemBuilder: (context, index) {
                      return ArticleCard(article: controller.articles[index]);
                    },
                  ),

                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
