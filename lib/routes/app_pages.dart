import 'package:get/get.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/navigation/views/main_navigation_view.dart';
import '../modules/profile/views/profile_view.dart';

class AppPages {
  static const initial = '/login';

  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/home',
      page: () => const MainNavigationView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/profile',
      page: () => const ProfileView(),
      transition: Transition.rightToLeft,
    ),
  ];
}
