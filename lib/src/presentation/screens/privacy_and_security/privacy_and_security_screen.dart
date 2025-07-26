import 'package:flutter/material.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/screens/settings/widgets/settings_section.dart';
import 'package:spending_pal/src/presentation/screens/settings/widgets/settings_tile.dart';

// TODO: refactor this screen
class PrivacyAndSecurityScreen extends StatelessWidget {
  const PrivacyAndSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimens.p4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSecuritySection(),
            const SizedBox(height: Dimens.p6),
            _buildDataManagementSection(),
            const SizedBox(height: Dimens.p6),
            _buildComplianceSection(),
            const SizedBox(height: Dimens.p6),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySection() {
    return SettingsSection(
      title: 'Account Security',
      children: [
        SettingsTile(
          icon: Icons.lock_outline,
          title: 'Change Password',
          subtitle: 'Update your access password',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildDataManagementSection() {
    return SettingsSection(
      title: 'Data Management',
      children: [
        SettingsTile(
          icon: Icons.delete_forever_outlined,
          title: 'Delete Account',
          subtitle: 'Permanently delete all data',
          onTap: () {},
          isDestructive: true,
          showTrailing: false,
        ),
      ],
    );
  }

  Widget _buildComplianceSection() {
    return SettingsSection(
      title: 'Legal Compliance',
      children: [
        SettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'How we protect your data',
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.description_outlined,
          title: 'Terms of Service',
          subtitle: 'Terms and conditions',
          onTap: () {},
        ),
      ],
    );
  }
}
