part of 'router.dart';

abstract class Routes {
  static const String initial = '/';
  static const String auth = '/auth';
  static const String dashboard = '/dashboard';
  static const String onboarding = '/onboarding';
  static const String account = '/account';
  static const String editProfile = '/edit-profile';
  static const String expenses = '/expenses';
  static const String overview = '/overview';
  static const String categories = '/categories';
  static const String reports = '/reports';
  static const String privacyAndSecurity = '/privacy-and-security';
  static const String helpAndSupport = '/help-and-support';

  static const String addTransaction = '/add-transaction';

  // settings related
  static const String settings = '/settings';

  static const String themeModeRelative = 'theme-mode';
  static const String themeMode = '$settings/$themeModeRelative';

  static const String languageRelative = 'language';
  static const String language = '$settings/$languageRelative';
}
