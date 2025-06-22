import 'package:spending_pal/src/config/router/router.dart';

abstract class AppNavigator {
  static void navigateToLogin() {
    router.goNamed(Routes.auth.name);
  }

  static void navigateToDashboard() {
    router.goNamed(Routes.dashboard.name);
  }

  static void navigateToOnboarding() {
    router.goNamed(Routes.onboarding.name);
  }
}
