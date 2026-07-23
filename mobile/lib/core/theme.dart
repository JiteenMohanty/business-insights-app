import 'package:flutter/material.dart';

/// App color palette. Kept in one place so screens stay visually consistent.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF4F46E5); // indigo-600
  static const Color primaryDark = Color(0xFF3730A3); // indigo-800
  static const Color scaffold = Color(0xFFF5F6FA);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFECECF1);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color star = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  /// One color per insight metric, in the same order the metrics are displayed
  /// (profile views, search views, website clicks, phone calls, direction
  /// requests). Used by both the metric cards and the bar chart so a metric has
  /// the same color everywhere.
  static const List<Color> metric = <Color>[
    Color(0xFF4F46E5), // indigo
    Color(0xFF06B6D4), // cyan
    Color(0xFF10B981), // green
    Color(0xFFF59E0B), // amber
    Color(0xFFEC4899), // pink
  ];
}

/// Single light theme for the app (Material 3).
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
      ),
      scaffoldBackgroundColor: AppColors.scaffold,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
