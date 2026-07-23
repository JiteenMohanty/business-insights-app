import 'package:get/get.dart';

import '../controllers/nav_controller.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import 'app_routes.dart';

/// Binds the [NavController] fresh whenever the home route is entered (e.g.
/// after each login), so the active tab always starts at the dashboard.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavController>(() => NavController());
  }
}

/// GetX page table.
class AppPages {
  AppPages._();

  static final List<GetPage> routes = [
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
  ];
}
