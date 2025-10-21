import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spending_pal/src/config/router/main_stateful_shell.dart';
import 'package:spending_pal/src/presentation/common/screen_wrapper/screen_wrapper.dart';
import 'package:spending_pal/src/presentation/screens/auth_screen/auth_screen.dart';
import 'package:spending_pal/src/presentation/screens/categories/categories_screen.dart';
import 'package:spending_pal/src/presentation/screens/edit_profile/edit_profile_screen.dart';
import 'package:spending_pal/src/presentation/screens/help_and_support/help_and_support_screen.dart';
import 'package:spending_pal/src/presentation/screens/language/language_screen.dart';
import 'package:spending_pal/src/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:spending_pal/src/presentation/screens/privacy_and_security/privacy_and_security_screen.dart';
import 'package:spending_pal/src/presentation/screens/settings/settings_screen.dart';
import 'package:spending_pal/src/presentation/screens/theme_mode/theme_mode_screen.dart';
import 'package:spending_pal/src/presentation/splash/splash_screen.dart';

part 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.initial,
  routes: [
    GoRoute(
      path: Routes.initial,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: Routes.auth,
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

    MainStatefulShell.create(),

    GoRoute(
      path: Routes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: Routes.editProfile,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: Routes.settings,
      builder: (context, state) => const SettingsScreen(),
      routes: [
        GoRoute(
          path: Routes.themeModeRelative,
          builder: (context, state) => const ThemeModeScreen(),
        ),
        GoRoute(
          path: Routes.languageRelative,
          builder: (context, state) => const LanguageScreen(),
        ),
      ],
    ),
    GoRoute(
      path: Routes.privacyAndSecurity,
      builder: (context, state) => const PrivacyAndSecurityScreen(),
    ),
    GoRoute(
      path: Routes.helpAndSupport,
      builder: (context, state) => const HelpAndSupportScreen(),
    ),
    GoRoute(
      path: Routes.categories,
      builder: (context, state) => const CategoriesScreen().wrap(),
    ),
  ],
);
