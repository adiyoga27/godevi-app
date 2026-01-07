import 'package:get/get.dart';
import 'package:godevi_app/app/modules/booking/views/booking_view.dart';
import 'package:godevi_app/app/modules/detail/bindings/detail_binding.dart';
import 'package:godevi_app/app/modules/detail/views/detail_view.dart';
import 'package:godevi_app/app/modules/home/bindings/home_binding.dart';
import 'package:godevi_app/app/modules/home/views/home_view.dart';
import 'package:godevi_app/app/modules/login/bindings/login_binding.dart';
import 'package:godevi_app/app/modules/login/views/login_view.dart';
import 'package:godevi_app/app/modules/home/views/article_detail_view.dart';
import 'package:godevi_app/app/modules/category/views/category_list_view.dart';
import 'package:godevi_app/app/modules/category/bindings/category_list_binding.dart';
import 'package:godevi_app/app/modules/register/views/register_view.dart';
import 'package:godevi_app/app/modules/register/bindings/register_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL,
      page: () => const DetailView(),
      binding: DetailBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(name: _Paths.BOOKING, page: () => const BookingView()),
    GetPage(name: _Paths.ARTICLE_DETAIL, page: () => const ArticleDetailView()),
    GetPage(
      name: _Paths.CATEGORY_LIST,
      page: () => const CategoryListView(),
      binding: CategoryListBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORY_LIST,
      page: () => const CategoryListView(),
      binding: CategoryListBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
  ];
}
