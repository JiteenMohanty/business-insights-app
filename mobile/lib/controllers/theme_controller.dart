import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Owns the app's light/dark theme mode.
///
/// Lives in GetX alongside the other UI-state controllers. The chosen mode is
/// persisted with [GetStorage] so it survives app restarts; with nothing saved
/// yet the app follows the system theme.
class ThemeController extends GetxController {
  static const String _storageKey = 'theme_mode';

  final GetStorage _box = GetStorage();

  late final Rx<ThemeMode> themeMode = _readSavedMode().obs;

  ThemeMode _readSavedMode() {
    switch (_box.read<String>(_storageKey)) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _encode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Whether dark is currently being rendered, resolving [ThemeMode.system]
  /// against the platform brightness.
  bool get isDarkMode {
    switch (themeMode.value) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    }
  }

  /// Flips between light and dark, committing the choice explicitly (so a
  /// toggle away from `system` sticks).
  void toggleTheme() {
    final next = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    themeMode.value = next;
    Get.changeThemeMode(next);
    _box.write(_storageKey, _encode(next));
  }
}
