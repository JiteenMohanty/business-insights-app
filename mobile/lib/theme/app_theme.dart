import 'package:flutter/material.dart';

/// Spacing scale. Kept deliberately tight for an information-dense,
/// enterprise-dashboard feel.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;

  /// Outer padding for scrollable screen bodies.
  static const EdgeInsets screen = EdgeInsets.all(md);

  /// Inner padding for cards/panels.
  static const EdgeInsets card = EdgeInsets.all(md);
}

/// App-specific color tokens that don't map cleanly onto Material's
/// [ColorScheme] (chart series, semantic status colors, hairline borders).
///
/// Exposed as a [ThemeExtension] so light and dark each supply their own values
/// and widgets never hardcode a hex.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.border,
    required this.subtleSurface,
    required this.star,
    required this.success,
    required this.warning,
    required this.danger,
    required this.metric,
  });

  /// Hairline border used instead of heavy card shadows.
  final Color border;

  /// Slightly recessed surface for grouped rows / input fills.
  final Color subtleSurface;

  final Color star;
  final Color success;
  final Color warning;
  final Color danger;

  /// One muted color per insight metric, in display order.
  final List<Color> metric;

  @override
  AppPalette copyWith({
    Color? border,
    Color? subtleSurface,
    Color? star,
    Color? success,
    Color? warning,
    Color? danger,
    List<Color>? metric,
  }) {
    return AppPalette(
      border: border ?? this.border,
      subtleSurface: subtleSurface ?? this.subtleSurface,
      star: star ?? this.star,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      metric: metric ?? this.metric,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      border: Color.lerp(border, other.border, t)!,
      subtleSurface: Color.lerp(subtleSurface, other.subtleSurface, t)!,
      star: Color.lerp(star, other.star, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      metric: [
        for (var i = 0; i < metric.length; i++)
          Color.lerp(metric[i], other.metric[i], t)!,
      ],
    );
  }
}

/// Convenience accessors so widgets read `context.palette` / `context.texts`
/// instead of repeating `Theme.of(context)...`.
extension AppThemeContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get texts => Theme.of(this).textTheme;
}

/// Light and dark [ThemeData] for the app.
///
/// Direction: muted / corporate. Low-saturation steel-blue primary, neutral
/// grays, hairline borders instead of drop shadows, and a compact type scale.
class AppTheme {
  AppTheme._();

  // ---------------------------------------------------------------- light
  static const Color _lPrimary = Color(0xFF345C82); // steel blue
  static const Color _lSurface = Color(0xFFFFFFFF);
  static const Color _lBackground = Color(0xFFF4F5F7);
  static const Color _lOnSurface = Color(0xFF1C2530);
  static const Color _lOnSurfaceVariant = Color(0xFF64707D);
  static const Color _lBorder = Color(0xFFDDE1E6);
  static const Color _lSubtle = Color(0xFFEDEFF2);

  static const AppPalette _lightPalette = AppPalette(
    border: _lBorder,
    subtleSurface: _lSubtle,
    star: Color(0xFFB5893B),
    success: Color(0xFF3F7D58),
    warning: Color(0xFFB07D2B),
    danger: Color(0xFFB3261E),
    metric: [
      Color(0xFF4A6FA5), // muted blue
      Color(0xFF4E8098), // muted teal
      Color(0xFF5B8C6E), // muted green
      Color(0xFFA8834B), // muted ochre
      Color(0xFF8A6A8E), // muted plum
    ],
  );

  // ----------------------------------------------------------------- dark
  static const Color _dPrimary = Color(0xFF7FA8D4); // lifted for dark contrast
  static const Color _dSurface = Color(0xFF1C2027); // dark slate, not black
  static const Color _dBackground = Color(0xFF15181D); // charcoal
  static const Color _dOnSurface = Color(0xFFE3E7EB);
  static const Color _dOnSurfaceVariant = Color(0xFF9AA5B1);
  static const Color _dBorder = Color(0xFF2E353F);
  static const Color _dSubtle = Color(0xFF242932);

  static const AppPalette _darkPalette = AppPalette(
    border: _dBorder,
    subtleSurface: _dSubtle,
    star: Color(0xFFD4A857),
    success: Color(0xFF6FAF8B),
    warning: Color(0xFFCFA059),
    danger: Color(0xFFE07A72),
    metric: [
      Color(0xFF6B90C4),
      Color(0xFF6FA3B8),
      Color(0xFF7FAE91),
      Color(0xFFC4A16B),
      Color(0xFFA98BAD),
    ],
  );

  /// Compact type scale shared by both themes. Colors are applied per-theme.
  static TextTheme _textTheme(Color onSurface, Color onSurfaceVariant) {
    return TextTheme(
      // Screen / app bar titles.
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: onSurface,
      ),
      // Section headers.
      titleMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: onSurface,
      ),
      // Large numeric values (metric cards).
      headlineSmall: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: onSurface,
      ),
      // Emphasized row values.
      titleSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      bodyMedium: TextStyle(fontSize: 13, height: 1.45, color: onSurface),
      bodySmall: TextStyle(fontSize: 12, color: onSurfaceVariant),
      // Metric/field labels.
      labelSmall: TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: onSurfaceVariant,
      ),
      labelMedium: TextStyle(fontSize: 12, color: onSurfaceVariant),
    );
  }

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme scheme,
    required Color scaffold,
    required AppPalette palette,
  }) {
    final text = _textTheme(scheme.onSurface, scheme.onSurfaceVariant);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      textTheme: text,
      extensions: <ThemeExtension<dynamic>>[palette],
      dividerTheme: DividerThemeData(
        color: palette.border,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
        // Hairline separator instead of a shadow.
        shape: Border(bottom: BorderSide(color: palette.border)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.subtleSurface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        labelStyle: text.labelMedium,
        hintStyle: text.labelMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.error, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          // Kept at 48 for an accessible tap target despite the denser layout.
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: palette.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle:
            const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
      ),
    );
  }

  static ThemeData get light => _build(
        brightness: Brightness.light,
        scaffold: _lBackground,
        palette: _lightPalette,
        scheme: const ColorScheme.light(
          primary: _lPrimary,
          onPrimary: Colors.white,
          secondary: Color(0xFF4E7C6A),
          onSecondary: Colors.white,
          surface: _lSurface,
          onSurface: _lOnSurface,
          onSurfaceVariant: _lOnSurfaceVariant,
          outline: _lBorder,
          error: Color(0xFFB3261E),
          onError: Colors.white,
          inverseSurface: Color(0xFF2A323C),
          onInverseSurface: Color(0xFFF1F3F5),
        ),
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        scaffold: _dBackground,
        palette: _darkPalette,
        scheme: const ColorScheme.dark(
          primary: _dPrimary,
          onPrimary: Color(0xFF10243A),
          secondary: Color(0xFF87B3A0),
          onSecondary: Color(0xFF10241C),
          surface: _dSurface,
          onSurface: _dOnSurface,
          onSurfaceVariant: _dOnSurfaceVariant,
          outline: _dBorder,
          error: Color(0xFFE07A72),
          onError: Color(0xFF3A0F0C),
          inverseSurface: Color(0xFFE3E7EB),
          onInverseSurface: Color(0xFF1C2027),
        ),
      );
}
