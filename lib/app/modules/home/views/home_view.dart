import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/modules/home/controllers/home_controller.dart';
import 'package:godevi_app/app/modules/home/views/widgets/article_card.dart';
import 'package:godevi_app/app/modules/home/views/widgets/category_selector.dart';
import 'package:godevi_app/app/modules/home/views/widgets/home_header.dart';
import 'package:godevi_app/app/modules/home/views/widgets/home_slider.dart';
import 'package:godevi_app/app/modules/home/views/widgets/package_card.dart';
import 'package:godevi_app/app/modules/home/views/widgets/section_header.dart';
import 'package:godevi_app/app/modules/home/views/widgets/village_card.dart';
import 'package:godevi_app/core/theme/app_theme.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
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
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        child: HomeSlider(sliders: controller.sliders),
                      ),
                      const HomeHeader(),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Categories
                  const CategorySelector(),

                  // Popular Villages
                  SectionHeader(title: 'Popular Villages', onShowAll: () {}),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.popularVillages.length,
                      itemBuilder: (context, index) {
                        return VillageCard(
                          village: controller.popularVillages[index],
                        );
                      },
                    ),
                  ),

                  // Best Tour Packages
                  SectionHeader(title: 'Best Tour Packages', onShowAll: () {}),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.bestPackages.length,
                    itemBuilder: (context, index) {
                      return PackageCard(
                        package: controller.bestPackages[index],
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  // Latest Articles
                  const SectionHeader(title: 'Latest Articles'),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 240,
                    child: Obx(
                      () => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(right: 20),
                        itemCount: controller.articles.length,
                        itemBuilder: (context, index) {
                          return ArticleCard(
                            article: controller.articles[index],
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Reservasi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Home (already here)
              break;
            case 1:
              controller.navigateToBooking();
              break;
            case 2:
              controller.navigateToProfile();
              break;
          }
        },
      ),
    );
  }
}
