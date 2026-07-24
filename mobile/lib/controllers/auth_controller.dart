import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/api_client.dart';
import '../routes/app_routes.dart';

/// Handles login and logout.
///
/// This lives in GetX (not BLoC) because login is a navigation action with a
/// loading spinner — exactly the "navigation + simple reactive UI state" that
/// GetX owns in this app. The three data-display features (business, insights,
/// reviews) each have their own BLoC/Cubit.
class AuthController extends GetxController {
  AuthController(this._api);

  final ApiClient _api;

  /// Drives the login button's spinner.
  final RxBool isLoading = false.obs;

  /// The signed-in user's email, or null when logged out.
  final RxnString userEmail = RxnString();

  Future<void> login(String email, String password) async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final loggedInEmail = await _api.login(email.trim(), password);
      userEmail.value = loggedInEmail;
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar(
        'Login failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    userEmail.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
