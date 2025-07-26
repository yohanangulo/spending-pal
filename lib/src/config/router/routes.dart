part of 'router.dart';

class Route {
  Route({
    required this.path,
    String? name,
  }) : name = name ?? path;

  final String name;
  final String path;
}

abstract class Routes {
  static Route initial = Route(
    name: 'initial',
    path: '/',
  );
  static Route auth = Route(
    name: 'auth',
    path: '/auth',
  );
  static Route dashboard = Route(
    name: 'dashboard',
    path: '/dashboard',
  );
  static Route onboarding = Route(
    name: 'onboarding',
    path: '/onboarding',
  );
  static Route account = Route(
    name: 'account',
    path: '/account',
  );
  static Route editProfile = Route(
    name: 'editProfile',
    path: '/edit-profile',
  );
  static Route expenses = Route(
    name: 'expenses',
    path: '/expenses',
  );
  static Route overview = Route(
    name: 'overview',
    path: '/overview',
  );
  static Route settings = Route(
    name: 'settings',
    path: '/settings',
  );
  static Route privacyAndSecurity = Route(
    name: 'privacyAndSecurity',
    path: '/privacy-and-security',
  );
  static Route helpAndSupport = Route(
    name: 'helpAndSupport',
    path: '/help-and-support',
  );
  static Route themeMode = Route(
    name: 'themeMode',
    path: '${Routes.settings.path}/theme-mode',
  );
  static Route language = Route(
    name: 'language',
    path: '${Routes.settings.path}/language',
  );
}
