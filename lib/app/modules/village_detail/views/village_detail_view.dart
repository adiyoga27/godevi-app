import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/modules/village_detail/controllers/village_detail_controller.dart';
import 'package:godevi_app/core/theme/app_theme.dart';
import 'package:godevi_app/app/modules/village_detail/views/widgets/recommended_package_card.dart';

class VillageDetailView extends GetView<VillageDetailController> {
  const VillageDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final village = controller.village.value;
        if (village == null) {
          return const Center(child: Text('Village not found'));
        }
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.arrow_back, color: Colors.black),
                ),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  imageUrl: village.thumbnail ?? village.defaultImg ?? '',
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      village.villageName ?? 'Unknown Village',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            village.villageAddress ?? 'No Address',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (village.contactPerson != null &&
                        village.contactPerson!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Contact Person',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                // Render HTML/Text here or simple string if it's simple
                                // API response showed '<p>0812...</p>'
                                // Html widget handles it
                                SizedBox(
                                  width: 200, // Constraint width
                                  child: Html(
                                    data: village.contactPerson,
                                    style: {
                                      "body": Style(
                                        margin: Margins.all(0),
                                        padding: HtmlPaddings.all(0),
                                        fontSize: FontSize(14),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      "p": Style(
                                        margin: Margins.all(0),
                                        padding: HtmlPaddings.all(0),
                                      ),
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                    const Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Html(
                      data: village.desc ?? '',
                      style: {
                        "body": Style(
                          margin: Margins.all(0),
                          padding: HtmlPaddings.all(0),
                          color: Colors.grey[800],
                          lineHeight: LineHeight(1.5),
                          fontSize: FontSize(14),
                        ),
                      },
                    ),
                    const SizedBox(height: 30),

                    // Recommended Packages Section
                    Obx(() {
                      if (controller.isLoadingPackages.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.recommendedPackages.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recommended Tour Packages',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.recommendedPackages.length,
                            itemBuilder: (context, index) {
                              return RecommendedPackageCard(
                                package: controller.recommendedPackages[index],
                              );
                            },
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
