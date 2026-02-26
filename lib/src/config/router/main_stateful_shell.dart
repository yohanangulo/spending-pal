import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:spending_pal/src/config/router/router.dart';
import 'package:spending_pal/src/presentation/common/widgets/main_app_shell.dart';
import 'package:spending_pal/src/presentation/screens/account/account_screen.dart';
import 'package:spending_pal/src/presentation/screens/analytics/analytics_screen.dart';
import 'package:spending_pal/src/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:spending_pal/src/presentation/screens/transactions/transactions_screen.dart';

enum MainAppShellTab {
  home,
  transactions,
  analytics,
  account;

  static MainAppShellTab fromIndex(int index) {
    return switch (index) {
      0 => home,
      1 => transactions,
      2 => analytics,
      3 => account,
      _ => throw Exception('Invalid index: $index'),
    };
  }

  String get title {
    return switch (this) {
      MainAppShellTab.home => 'Home',
      MainAppShellTab.transactions => 'Transactions',
      MainAppShellTab.analytics => 'Analytics',
      MainAppShellTab.account => 'Account',
    };
  }

  bool get shouldShowAppBar => switch (this) {
    MainAppShellTab.transactions => false,
    MainAppShellTab.home => true,
    MainAppShellTab.analytics => true,
    MainAppShellTab.account => true,
  };
}

abstract class MainStatefulShell {
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static StatefulShellBranch get homeBranch {
    return StatefulShellBranch(
      navigatorKey: _shellNavigatorKey,
      routes: [
        GoRoute(
          path: Routes.dashboard,
          builder: (context, state) => const DashboardScreen(),
        ),
      ],
    );
  }

  static StatefulShellBranch get transactionsBranch {
    return StatefulShellBranch(
      preload: true,
      routes: [
        GoRoute(
          path: Routes.transactions,
          builder: (context, state) => const TransactionsScreen(),
        ),
      ],
    );
  }

  static StatefulShellBranch get analyticsBranch {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: Routes.analytics,
          builder: (context, state) => const AnalyticsScreen(),
        ),
      ],
    );
  }

  static StatefulShellBranch get accountBranch {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: Routes.account,
          builder: (context, state) => const AccountScreen(),
        ),
      ],
    );
  }

  static StatefulShellRoute create() {
    return StatefulShellRoute.indexedStack(
      builder: (context, state, child) => MainAppShell(navigationShell: child),
      branches: [
        homeBranch,
        transactionsBranch,
        analyticsBranch,
        accountBranch,
      ],
    );
  }
}
