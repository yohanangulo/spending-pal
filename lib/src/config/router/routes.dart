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
  static Route splash = Route(
    name: 'splash',
    path: '/splash',
  );
  static Route login = Route(
    name: 'login',
    path: '/login',
  );
}
