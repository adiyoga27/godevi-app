import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:godevi_app/app/routes/app_pages.dart';
import 'package:godevi_app/core/theme/app_theme.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          controller.user?.name ?? 'User',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'View and edit profile',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: ClipOval(
                    child: Obx(() {
                      final avatarUrl = controller.user?.avatar;
                      if (avatarUrl != null && avatarUrl.isNotEmpty) {
                        return CachedNetworkImage(
                          imageUrl: avatarUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) =>
                              const Icon(Icons.person, color: Colors.grey),
                        );
                      }
                      return const Icon(Icons.person, color: Colors.grey);
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            _buildMenuItem(
              title: 'Change Password',
              icon: Icons.vpn_key_outlined,
              onTap: () => Get.toNamed(Routes.CHANGE_PASSWORD),
            ),
            _buildDivider(),
            _buildMenuItem(
              title: 'About',
              icon: Icons.info_outline_rounded,
              onTap: () => Get.toNamed(Routes.ABOUT),
            ),
            _buildDivider(),
            _buildMenuItem(
              title: 'FAQ',
              icon: Icons.help_outline,
              onTap: () => Get.toNamed(Routes.FAQ),
            ),
            _buildDivider(),
            _buildMenuItem(
              title: 'Logout',
              icon: Icons.logout,
              onTap: controller.logout,
            ),
            _buildDivider(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Profile
        onTap: (index) {
          if (index == 0) Get.offAllNamed(Routes.HOME);
          if (index == 1) Get.offAllNamed(Routes.BOOKING); // Or check auth
          // Index 2 is current
        },
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Reservasi',
            icon: Icon(Icons.shopping_bag_outlined),
          ),
          BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: Icon(icon, color: Colors.grey, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0));
  }
}
