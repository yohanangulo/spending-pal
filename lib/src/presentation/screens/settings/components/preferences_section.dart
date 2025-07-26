import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/config/router/app_navigator.dart';
import 'package:spending_pal/src/core/common/blocs/theme_mode_cubit.dart';
import 'package:spending_pal/src/presentation/core/app_localizations_cubit/app_localizations_cubit.dart';
import 'package:spending_pal/src/presentation/screens/settings/widgets/settings_section.dart';
import 'package:spending_pal/src/presentation/screens/settings/widgets/settings_tile.dart';

class PreferencesSection extends StatelessWidget {
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Preferencias',
      children: [
        const _LanguageTile(),
        const _ThemeTile(),
        SettingsTile(
          icon: Icons.currency_exchange_outlined,
          title: 'Moneda',
          subtitle: r'USD ($)',
          onTap: () {},
        ),
      ],
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile();

  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = context.select((ThemeModeCubit c) => c.state);
    return SettingsTile(
      icon: Icons.dark_mode_outlined,
      title: 'Tema',
      subtitle: switch (themeMode) {
        ThemeMode.light => context.l10n.light,
        ThemeMode.dark => context.l10n.dark,
        ThemeMode.system => context.l10n.system,
      },
      onTap: AppNavigator.navigateToThemeMode,
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile();

  @override
  Widget build(BuildContext context) {
    final Locale locale = context.select((AppLocalizationsCubit c) => c.state);
    return SettingsTile(
      icon: Icons.language_outlined,
      title: 'Idioma',
      subtitle: locale.localeName,
      onTap: AppNavigator.navigateToLanguage,
    );
  }
}
