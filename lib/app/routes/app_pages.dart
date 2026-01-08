import 'package:get/get.dart';
import 'package:godevi_app/app/modules/booking/views/booking_view.dart';
import 'package:godevi_app/app/modules/booking/bindings/booking_binding.dart';
import 'package:godevi_app/app/modules/detail/bindings/detail_binding.dart';
import 'package:godevi_app/app/modules/detail/views/detail_view.dart';
import 'package:godevi_app/app/modules/main/bindings/main_binding.dart';
import 'package:godevi_app/app/modules/main/views/main_view.dart';
import 'package:godevi_app/app/modules/login/bindings/login_binding.dart';
import 'package:godevi_app/app/modules/login/views/login_view.dart';
import 'package:godevi_app/app/modules/home/views/article_detail_view.dart';
import 'package:godevi_app/app/modules/category/views/category_list_view.dart';
import 'package:godevi_app/app/modules/category/bindings/category_list_binding.dart';
import 'package:godevi_app/app/modules/register/views/register_view.dart';
import 'package:godevi_app/app/modules/register/bindings/register_binding.dart';
import 'package:godevi_app/app/modules/profile/views/profile_view.dart';
import 'package:godevi_app/app/modules/profile/bindings/profile_binding.dart';
import 'package:godevi_app/app/modules/faq/views/faq_view.dart';
import 'package:godevi_app/app/modules/faq/bindings/faq_binding.dart';
import 'package:godevi_app/app/modules/about/views/about_view.dart';
import 'package:godevi_app/app/modules/about/bindings/about_binding.dart';
import 'package:godevi_app/app/modules/change_password/views/change_password_view.dart';
import 'package:godevi_app/app/modules/change_password/bindings/change_password_binding.dart';
import 'package:godevi_app/app/modules/village_list/views/village_list_view.dart';
import 'package:godevi_app/app/modules/village_list/bindings/village_list_binding.dart';
import 'package:godevi_app/app/modules/village_detail/views/village_detail_view.dart';
import 'package:godevi_app/app/modules/village_detail/bindings/village_detail_binding.dart';
import 'package:godevi_app/app/modules/reservation/bindings/reservation_binding.dart';
import 'package:godevi_app/app/modules/reservation/views/reservation_view.dart';
import 'package:godevi_app/app/modules/reservation/views/transaction_detail_view.dart';
import 'package:godevi_app/app/modules/reservation/bindings/transaction_detail_binding.dart';
import 'package:godevi_app/app/modules/notification/views/notification_view.dart';
import 'package:godevi_app/app/modules/notification/bindings/notification_binding.dart';
import 'package:godevi_app/app/modules/search/views/search_view.dart';
import 'package:godevi_app/app/modules/search/bindings/search_binding.dart';
import 'package:godevi_app/app/modules/article_list/views/article_list_view.dart';
import 'package:godevi_app/app/modules/article_list/bindings/article_list_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const MainView(),
      binding: MainBinding(),
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
    GetPage(
      name: _Paths.BOOKING,
      page: () => const BookingView(),
      binding: BookingBinding(),
    ),
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
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.FAQ,
      page: () => const FaqView(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.VILLAGE_LIST,
      page: () => const VillageListView(),
      binding: VillageListBinding(),
    ),
    GetPage(
      name: _Paths.VILLAGE_DETAIL,
      page: () => const VillageDetailView(),
      binding: VillageDetailBinding(),
    ),
    GetPage(
      name: _Paths.RESERVATION,
      page: () => const ReservationView(),
      binding: ReservationBinding(),
    ),
    GetPage(
      name: _Paths.TRANSACTION_DETAIL,
      page: () => const TransactionDetailView(),
      binding: TransactionDetailBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.ARTICLE_LIST,
      page: () => const ArticleListView(),
      binding: ArticleListBinding(),
    ),
  ];
}
