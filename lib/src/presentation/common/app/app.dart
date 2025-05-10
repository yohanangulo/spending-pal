import 'package:flutter/material.dart';
import 'package:spending_pal/src/config/router/router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SpendingPal',
      routerConfig: router,
    );
  }
}
