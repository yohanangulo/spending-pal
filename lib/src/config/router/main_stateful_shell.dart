import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:spending_pal/src/config/router/router.dart';
import 'package:spending_pal/src/presentation/common/widgets/main_app_shell.dart';
import 'package:spending_pal/src/presentation/screens/account/account_screen.dart';
import 'package:spending_pal/src/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:spending_pal/src/presentation/screens/overview_screen/overview_screen.dart';
import 'package:spending_pal/src/presentation/screens/transactions/transactions_screen.dart';

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

  bool get shouldShowAppBar => switch (this) {
    MainAppShellTab.expenses => false,
    MainAppShellTab.home => true,
    MainAppShellTab.overview => true,
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

  static StatefulShellBranch get overviewBranch {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: Routes.overview,
          builder: (context, state) => const OverviewScreen(),
        ),
      ],
    );
  }

  static StatefulShellBranch get expensesBranch {
    return StatefulShellBranch(
      preload: true,
      routes: [
        GoRoute(
          path: Routes.expenses,
          builder: (context, state) => const TransactionsScreen(),
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
        overviewBranch,
        expensesBranch,
        accountBranch,
      ],
    );
  }
}
