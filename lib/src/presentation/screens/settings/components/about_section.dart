import 'package:flutter/material.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/presentation/core/auth/auth_bloc.dart';
import 'package:spending_pal/src/presentation/screens/settings/widgets/settings_section.dart';
import 'package:spending_pal/src/presentation/screens/settings/widgets/settings_tile.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Acerca de',
      children: [
        const SettingsTile(
          icon: Icons.info_outline,
          title: 'App version',
          subtitle: 'Versión 1.0.0',
          showTrailing: false,
        ),
        SettingsTile(
          icon: Icons.logout,
          title: 'Cerrar sesión',
          onTap: () => context.authBloc.add(const AuthLogoutRequested()),
          isDestructive: true,
          showTrailing: false,
        ),
      ],
    );
  }
}
