import 'package:flutter/material.dart';
import 'package:spending_pal/src/config/router/router.dart';
import 'package:spending_pal/src/config/translations/l10n.dart';
import 'package:spending_pal/src/presentation/common/global/global_blocs.dart';
import 'package:spending_pal/src/presentation/common/global/global_listeners.dart';
import 'package:spending_pal/src/presentation/common/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalBlocs(
      child: GlobalListeners(
        child: MaterialApp.router(
          theme: AppTheme.dark,
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          locale: L10n.currentSupportedLocale,
          onGenerateTitle: L10n.initializeAndReturnTitle,
        ),
      ),
    );
  }
}
