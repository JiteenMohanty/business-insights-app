import 'dart:io';

import 'package:business_insights/controllers/auth_controller.dart';
import 'package:business_insights/controllers/theme_controller.dart';
import 'package:business_insights/data/api_client.dart';
import 'package:business_insights/main.dart';
import 'package:business_insights/theme/app_theme.dart';
import 'package:business_insights/widgets/metric_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // GetStorage needs a documents directory; path_provider isn't available in
    // the test environment, so point it at a temp dir.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => Directory.systemTemp.createTempSync().path,
    );
    await GetStorage.init();
  });

  group('App shell', () {
    setUp(() {
      // Register the singletons the way main() does.
      final api = ApiClient();
      Get.put<ApiClient>(api, permanent: true);
      Get.put<AuthController>(AuthController(api), permanent: true);
      Get.put<ThemeController>(ThemeController(), permanent: true);
    });

    tearDown(Get.reset);

    testWidgets('Login screen renders its key elements', (tester) async {
      await tester.pumpWidget(const BusinessInsightsApp());
      await tester.pumpAndSettle();

      expect(find.text('Business Insights'), findsOneWidget);
      expect(find.text('Log in'), findsOneWidget);
      expect(find.text('Fill demo credentials'), findsOneWidget);
    });

    testWidgets('Shows validation errors when submitting an empty form',
        (tester) async {
      await tester.pumpWidget(const BusinessInsightsApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log in'));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('Theme toggle flips the rendered brightness', (tester) async {
      final controller = Get.find<ThemeController>();
      final wasDark = controller.isDarkMode;

      await tester.pumpWidget(const BusinessInsightsApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip(
        wasDark ? 'Switch to light theme' : 'Switch to dark theme',
      ));
      await tester.pumpAndSettle();

      expect(controller.isDarkMode, isNot(wasDark));
    });
  });

  // Regression guard for the "BOTTOM OVERFLOWED BY 8.9 PIXELS" bug: the card is
  // rendered at exactly the size the dashboard grid gives it, using the longest
  // label, in both themes. A RenderFlex overflow surfaces as a test exception.
  group('MetricCard layout', () {
    Widget harness(ThemeData theme, double width) {
      return MaterialApp(
        theme: theme,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: width,
              height: MetricCard.gridExtent,
              child: const MetricCard(
                label: 'Direction Requests',
                value: 1200,
                icon: Icons.directions_outlined,
                accent: Color(0xFF4A6FA5),
              ),
            ),
          ),
        ),
      );
    }

    for (final width in <double>[140, 170, 220]) {
      testWidgets('does not overflow at ${width}px wide (light)',
          (tester) async {
        await tester.pumpWidget(harness(AppTheme.light, width));
        expect(tester.takeException(), isNull);
      });

      testWidgets('does not overflow at ${width}px wide (dark)',
          (tester) async {
        await tester.pumpWidget(harness(AppTheme.dark, width));
        expect(tester.takeException(), isNull);
      });
    }
  });
}
