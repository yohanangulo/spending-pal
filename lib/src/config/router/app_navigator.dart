import 'package:spending_pal/src/config/router/router.dart';

abstract class AppNavigator {
  static void navigateToLogin() {
    router.pushNamed(Routes.auth.name);
  }

  static void navigateToDashboard() {
    router.pushNamed(Routes.dashboard.name);
  }
}
