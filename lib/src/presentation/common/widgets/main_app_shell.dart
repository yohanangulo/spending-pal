import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spending_pal/src/config/router/app_navigator.dart';
import 'package:spending_pal/src/config/router/router.dart';

class MainAppShell extends StatelessWidget {
  const MainAppShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final MainAppShellTab tab = MainAppShellTab.fromIndex(navigationShell.currentIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text(tab.title),
        actions: [
          if (tab == MainAppShellTab.account)
            const IconButton(
              onPressed: AppNavigator.navigateToEditProfile,
              icon: Icon(Icons.edit),
            ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Overview',
          ),
          const NavigationDestination(
            icon: Icon(Icons.add),
            label: 'Expenses',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
