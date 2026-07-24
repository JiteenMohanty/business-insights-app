import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/theme_controller.dart';

/// Light/dark toggle. Reflects the currently rendered brightness (resolving
/// "system" against the platform) and persists the choice on tap.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeController>();

    return Obx(() {
      // Read the observable so this rebuilds when the mode changes.
      controller.themeMode.value;
      final isDark = controller.isDarkMode;

      return IconButton(
        tooltip: isDark ? 'Switch to light theme' : 'Switch to dark theme',
        onPressed: controller.toggleTheme,
        icon: Icon(
          isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          size: 20,
        ),
      );
    });
  }
}
