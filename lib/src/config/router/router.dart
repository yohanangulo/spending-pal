import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spending_pal/src/presentation/screens/auth_screen/auth_screen.dart';
import 'package:spending_pal/src/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:spending_pal/src/presentation/screens/onboarding/onboarding_screen.dart';
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
    GoRoute(
      name: Routes.auth.name,
      path: Routes.auth.path,
      builder: (context, state) => const AuthScreen(),
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: const AuthScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: Routes.dashboard.name,
      path: Routes.dashboard.path,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      name: Routes.onboarding.name,
      path: Routes.onboarding.path,
      builder: (context, state) => const OnboardingScreen(),
    ),
  ],
);
