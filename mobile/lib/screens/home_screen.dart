import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/nav_controller.dart';
import '../data/api_client.dart';
import '../logic/business/business_cubit.dart';
import '../logic/insights/insights_cubit.dart';
import '../logic/reviews/reviews_cubit.dart';
import '../widgets/theme_toggle_button.dart';
import 'business_screen.dart';
import 'dashboard_screen.dart';
import 'reviews_screen.dart';

/// The screen shown after login. Provides the three feature Cubits (each starts
/// loading immediately) and switches between the Dashboard, Business, and
/// Reviews screens via a bottom navigation bar. The active tab is GetX state.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _titles = ['Insights', 'Business Profile', 'Reviews'];

  @override
  Widget build(BuildContext context) {
    final api = Get.find<ApiClient>();
    final nav = Get.find<NavController>();
    final auth = Get.find<AuthController>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => InsightsCubit(api)..load()),
        BlocProvider(create: (_) => BusinessCubit(api)..load()),
        BlocProvider(create: (_) => ReviewsCubit(api)..load()),
      ],
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            title: Text(_titles[nav.tabIndex.value]),
            actions: [
              const ThemeToggleButton(),
              IconButton(
                tooltip: 'Log out',
                icon: const Icon(Icons.logout_outlined, size: 20),
                onPressed: auth.logout,
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: IndexedStack(
            index: nav.tabIndex.value,
            children: const [
              DashboardScreen(),
              BusinessScreen(),
              ReviewsScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: nav.tabIndex.value,
            onTap: nav.changeTab,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined, size: 21),
                activeIcon: Icon(Icons.bar_chart, size: 21),
                label: 'Insights',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.storefront_outlined, size: 21),
                activeIcon: Icon(Icons.storefront, size: 21),
                label: 'Business',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.rate_review_outlined, size: 21),
                activeIcon: Icon(Icons.rate_review, size: 21),
                label: 'Reviews',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
