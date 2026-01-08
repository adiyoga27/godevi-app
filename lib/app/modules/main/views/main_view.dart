import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godevi_app/app/modules/home/views/home_view.dart';
import 'package:godevi_app/app/modules/main/controllers/main_controller.dart';
import 'package:godevi_app/app/modules/profile/views/profile_view.dart';
import 'package:godevi_app/app/modules/reservation/views/reservation_view.dart';
import 'package:godevi_app/core/theme/app_theme.dart';

class MainView extends GetView<MainController> {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [HomeView(), ReservationView(), ProfileView()],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors.grey,
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Reservasi',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
