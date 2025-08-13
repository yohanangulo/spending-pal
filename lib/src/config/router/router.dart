import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spending_pal/src/presentation/common/screen_wrapper/screen_wrapper.dart';
import 'package:spending_pal/src/presentation/common/widgets/main_app_shell.dart';
import 'package:spending_pal/src/presentation/screens/account/account_screen.dart';
import 'package:spending_pal/src/presentation/screens/auth_screen/auth_screen.dart';
import 'package:spending_pal/src/presentation/screens/categories/categories_screen.dart';
import 'package:spending_pal/src/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:spending_pal/src/presentation/screens/edit_profile/edit_profile_screen.dart';
import 'package:spending_pal/src/presentation/screens/expenses/expenses_screen.dart';
import 'package:spending_pal/src/presentation/screens/help_and_support/help_and_support_screen.dart';
import 'package:spending_pal/src/presentation/screens/language/language_screen.dart';
import 'package:spending_pal/src/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:spending_pal/src/presentation/screens/overview_screen/overview_screen.dart';
import 'package:spending_pal/src/presentation/screens/privacy_and_security/privacy_and_security_screen.dart';
import 'package:spending_pal/src/presentation/screens/settings/settings_screen.dart';
import 'package:spending_pal/src/presentation/screens/theme_mode/theme_mode_screen.dart';
import 'package:spending_pal/src/presentation/splash/splash_screen.dart';

part 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

enum MainAppShellTab {
  home,
  overview,
  account,
  expenses;

  static MainAppShellTab fromIndex(int index) {
    return switch (index) {
      0 => home,
      1 => overview,
      2 => expenses,
      3 => account,
      _ => throw Exception('Invalid index: $index'),
    };
  }

  String get title {
    return switch (this) {
      MainAppShellTab.home => 'Home',
      MainAppShellTab.overview => 'Overview',
      MainAppShellTab.account => 'Account',
      MainAppShellTab.expenses => 'Expenses',
    };
  }
}

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.initial.path,
  routes: [
    GoRoute(
      name: Routes.initial.name,
      path: Routes.initial.path,
      builder: (context, state) => const SplashScreen(),
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

    // ----- main app shell -----

    StatefulShellRoute.indexedStack(
      builder: (context, state, child) => MainAppShell(navigationShell: child),
      branches: [
        // ----- home branch -----
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              name: Routes.dashboard.name,
              path: Routes.dashboard.path,
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),

        // ----- overview branch -----
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: Routes.overview.name,
              path: Routes.overview.path,
              builder: (context, state) => const OverviewScreen(),
            ),
          ],
        ),

        // ----- expenses branch -----
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: Routes.expenses.name,
              path: Routes.expenses.path,
              builder: (context, state) => const ExpensesScreen(),
            ),
          ],
        ),

        // ----- account branch -----
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: Routes.account.name,
              path: Routes.account.path,
              builder: (context, state) => const AccountScreen(),
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      name: Routes.onboarding.name,
      path: Routes.onboarding.path,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      name: Routes.editProfile.name,
      path: Routes.editProfile.path,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      name: Routes.settings.name,
      path: Routes.settings.path,
      builder: (context, state) => const SettingsScreen(),
      routes: [
        GoRoute(
          name: Routes.themeMode.name,
          path: Routes.themeMode.path,
          builder: (context, state) => const ThemeModeScreen(),
        ),
        GoRoute(
          name: Routes.language.name,
          path: Routes.language.path,
          builder: (context, state) => const LanguageScreen(),
        ),
      ],
    ),
    GoRoute(
      name: Routes.privacyAndSecurity.name,
      path: Routes.privacyAndSecurity.path,
      builder: (context, state) => const PrivacyAndSecurityScreen(),
    ),
    GoRoute(
      name: Routes.helpAndSupport.name,
      path: Routes.helpAndSupport.path,
      builder: (context, state) => const HelpAndSupportScreen(),
    ),
    GoRoute(
      name: Routes.categories.name,
      path: Routes.categories.path,
      builder: (context, state) => const CategoriesScreen().wrap(),
    ),
  ],
);
