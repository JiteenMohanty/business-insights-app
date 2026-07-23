import 'package:business_insights/controllers/auth_controller.dart';
import 'package:business_insights/data/api_client.dart';
import 'package:business_insights/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    // LoginScreen resolves AuthController via Get.find, so register the
    // singletons the way main() does. No network is hit just rendering login.
    final api = ApiClient();
    Get.put<ApiClient>(api, permanent: true);
    Get.put<AuthController>(AuthController(api), permanent: true);
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
}
