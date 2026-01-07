part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const DETAIL = _Paths.DETAIL;
  static const BOOKING = _Paths.BOOKING;
  static const PROFILE = _Paths.PROFILE;
  static const LOGIN = _Paths.LOGIN;
  static const ARTICLE_DETAIL = _Paths.ARTICLE_DETAIL;
  static const CATEGORY_LIST = _Paths.CATEGORY_LIST;
  static const REGISTER = _Paths.REGISTER;
  static const FAQ = _Paths.FAQ;
  static const ABOUT = _Paths.ABOUT;
  static const CHANGE_PASSWORD = _Paths.CHANGE_PASSWORD;
  static const VILLAGE_LIST = _Paths.VILLAGE_LIST;
  static const VILLAGE_DETAIL = _Paths.VILLAGE_DETAIL;
  static const RESERVATION = _Paths.RESERVATION;
  static const TRANSACTION_DETAIL = _Paths.TRANSACTION_DETAIL;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const DETAIL = '/detail';
  static const BOOKING = '/booking';
  static const PROFILE = '/profile';
  static const LOGIN = '/login';
  static const ARTICLE_DETAIL = '/article-detail';
  static const CATEGORY_LIST = '/category-list';
  static const REGISTER = '/register';
  static const FAQ = '/faq';
  static const ABOUT = '/about';
  static const CHANGE_PASSWORD = '/change-password';
  static const VILLAGE_LIST = '/village-list';
  static const VILLAGE_DETAIL = '/village-detail';
  static const RESERVATION = '/reservation';
  static const TRANSACTION_DETAIL = '/transaction-detail';
}
