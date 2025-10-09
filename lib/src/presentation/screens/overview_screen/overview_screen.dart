import 'package:flutter/material.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(context.l10n.hello_world),
      ),
    );
  }
}
