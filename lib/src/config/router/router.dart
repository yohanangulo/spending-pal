import 'package:go_router/go_router.dart';
import 'package:spending_pal/src/presentation/splash/splash_screen.dart';

part 'routes.dart';

final router = GoRouter(
  initialLocation: Routes.initial.path,
  routes: [
    GoRoute(
      name: Routes.initial.name,
      path: Routes.initial.path,
      builder: (context, state) => SplashScreen(),
    ),
  ],
);
