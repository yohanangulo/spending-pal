import 'package:go_router/go_router.dart';
import 'package:spending_pal/src/presentation/splash/splash_screen.dart';

part 'routes.dart';

final router = GoRouter(
  initialLocation: Routes.initial,
  routes: [
    GoRoute(
      name: Routes.initial,
      path: Routes.initial,
      builder: (context, state) => SplashScreen(),
    ),
  ],
);
