import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'core/theme.dart';
import 'data/api_client.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() {
  // App-wide singletons. The ApiClient is shared by the AuthController (GetX)
  // and the feature Cubits (BLoC), which are provided per-screen.
  final apiClient = ApiClient();
  Get.put<ApiClient>(apiClient, permanent: true);
  Get.put<AuthController>(AuthController(apiClient), permanent: true);

  runApp(const BusinessInsightsApp());
}

class BusinessInsightsApp extends StatelessWidget {
  const BusinessInsightsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Business Insights',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.login,
      getPages: AppPages.routes,
    );
  }
}
