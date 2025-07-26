import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:spending_pal/src/config/config/config.dart';
import 'package:spending_pal/src/config/service_locator/service_locator.dart';
import 'package:spending_pal/src/config/translations/l10n/generated/l10n.dart';
import 'package:spending_pal/src/core/user/src/infrastructure/user_preferences_repository.dart';

/// Prefer using [context.l10n]
///
/// ```dart
/// context.l10n.title
/// ```
///
/// [l10n] should be only used when [BuildContext] is not available
AppLocalizations get l10n => getIt<AppLocalizations>();

abstract class L10n {
  L10n._();

  static String initializeAndReturnTitle(BuildContext context) {
    _initializeAppLocalizations(context);

    return config.flavor.appName;
  }

  static void _initializeAppLocalizations(BuildContext context) {
    if (getIt.isRegistered<AppLocalizations>()) {
      getIt.unregister<AppLocalizations>();
    }
    getIt.registerLazySingleton<AppLocalizations>(() => AppLocalizations.of(context));
  }

  static List<Locale> supportedLocales = AppLocalizations.delegate.supportedLocales;

  static const Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Locale get defaultLocale => const Locale('en');

  static UserPreferencesRepository get repository => getIt<UserPreferencesRepository>();

  static Locale get currentSupportedLocale {
    final locale = repository.getLocaleName() ?? Platform.localeName;

    final foundByLocaleName = supportedLocales.firstWhereOrNull(
      (s) => locale == s.toString(),
    );

    if (foundByLocaleName != null) {
      return foundByLocaleName;
    } else {
      final foundByLanguageCode = supportedLocales.firstWhereOrNull(
        (s) => locale.split('_').first == s.languageCode,
      );

      if (foundByLanguageCode != null) {
        return foundByLanguageCode;
      }
    }

    return defaultLocale;
  }
}
