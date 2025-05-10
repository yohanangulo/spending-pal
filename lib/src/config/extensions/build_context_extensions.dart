part of 'extensions.dart';

extension BuildContextExtensions on BuildContext {
  AppLocalizations get l10n {
    final instance = AppLocalizations.maybeOf(this);
    if (instance != null) return instance;

    return localization.l10n;
  }
}
