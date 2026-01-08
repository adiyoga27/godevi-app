import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:godevi_app/app/routes/app_pages.dart';
import 'package:godevi_app/core/theme/app_theme.dart';
import 'package:godevi_app/app/data/services/auth_service.dart';
import 'package:godevi_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Services
  await GetStorage.init();
  await Get.putAsync(() => AuthService().init());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    GetMaterialApp(
      title: "Godevi",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
    ),
  );
}
