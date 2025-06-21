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
}
