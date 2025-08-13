import 'package:flutter/material.dart';
import 'package:spending_pal/src/config/router/app_navigator.dart';
import 'package:spending_pal/src/presentation/screens/account/widgets/account_option.dart';
import 'package:spending_pal/src/presentation/screens/account/widgets/account_section.dart';

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Colors.grey[200],
      indent: 56,
    );
  }
}

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccountSection(
      children: [
        AccountOption(
          icon: Icons.settings,
          title: 'Settings',
          onTap: AppNavigator.navigateToSettings,
        ),
        _Divider(),
        AccountOption(
          icon: Icons.security,
          title: 'Privacy and Security',
          onTap: AppNavigator.navigateToPrivacyAndSecurity,
        ),
        _Divider(),
        AccountOption(
          icon: Icons.help,
          title: 'Help and Support',
          onTap: AppNavigator.navigateToHelpAndSupport,
        ),
      ],
    );
  }
}
