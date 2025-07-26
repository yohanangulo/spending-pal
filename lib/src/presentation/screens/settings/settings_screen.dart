import 'package:flutter/material.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/screens/settings/components/about_section.dart';
import 'package:spending_pal/src/presentation/screens/settings/components/preferences_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(Dimens.p4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PreferencesSection(),
            SizedBox(height: Dimens.p6),
            AboutSection(),
            SizedBox(height: Dimens.p8),
          ],
        ),
      ),
    );
  }
}
