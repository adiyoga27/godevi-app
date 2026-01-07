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
}
