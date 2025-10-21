import 'package:spending_pal/src/config/router/router.dart';

abstract class AppNavigator {
  static void navigateToLogin() {
    router.go(Routes.auth);
  }

  static void navigateToDashboard() {
    router.go(Routes.dashboard);
  }

  static void navigateToOnboarding() {
    router.go(Routes.onboarding);
  }

  static void navigateToEditProfile() {
    router.push(Routes.editProfile);
  }

  static void pop() {
    router.pop();
  }

  static void navigateToSettings() {
    router.push(Routes.settings);
  }

  static void navigateToPrivacyAndSecurity() {
    router.push(Routes.privacyAndSecurity);
  }

  static void navigateToHelpAndSupport() {
    router.push(Routes.helpAndSupport);
  }

  static void navigateToThemeMode() {
    router.push(Routes.themeMode);
  }

  static void navigateToLanguage() {
    router.push(Routes.language);
  }

  static void navigateToCategories() {
    router.push(Routes.categories);
  }
}
