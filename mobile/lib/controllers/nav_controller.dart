import 'package:get/get.dart';

/// Tracks the active bottom-navigation tab on the home screen.
///
/// This is exactly the kind of "simple reactive UI state" GetX owns in this
/// app; the data behind each tab is owned by the feature Cubits.
class NavController extends GetxController {
  final RxInt tabIndex = 0.obs;

  void changeTab(int index) => tabIndex.value = index;
}
