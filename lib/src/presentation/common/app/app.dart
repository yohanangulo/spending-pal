import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/router/router.dart';
import 'package:spending_pal/src/config/translations/l10n.dart';
import 'package:spending_pal/src/core/common/blocs/theme_mode_cubit.dart';
import 'package:spending_pal/src/presentation/common/theme/app_theme.dart';
import 'package:spending_pal/src/presentation/core/app_localizations_cubit/app_localizations_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select((ThemeModeCubit c) => c.state);
    final locale = context.select((AppLocalizationsCubit c) => c.state);
    return MaterialApp.router(
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      locale: locale,
      onGenerateTitle: L10n.initializeAndReturnTitle,
    );
  }
}
