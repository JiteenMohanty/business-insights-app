import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/auth_controller.dart';
import 'controllers/theme_controller.dart';
import 'data/api_client.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Backs the persisted theme preference.
  await GetStorage.init();

  // App-wide singletons. The ApiClient is shared by the AuthController (GetX)
  // and the feature Cubits (BLoC), which are provided per-screen.
  final apiClient = ApiClient();
  Get.put<ApiClient>(apiClient, permanent: true);
  Get.put<AuthController>(AuthController(apiClient), permanent: true);
  Get.put<ThemeController>(ThemeController(), permanent: true);

  runApp(const BusinessInsightsApp());
}

class BusinessInsightsApp extends StatelessWidget {
  const BusinessInsightsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initial mode comes from the persisted preference (defaulting to system);
    // later changes go through Get.changeThemeMode from ThemeController.
    final themeMode = Get.find<ThemeController>().themeMode.value;

    return GetMaterialApp(
      title: 'Business Insights',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      initialRoute: AppRoutes.login,
      getPages: AppPages.routes,
    );
  }
}
