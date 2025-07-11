part of 'extensions.dart';

extension BuildContextExtensions on BuildContext {
  AppLocalizations get l10n {
    final instance = AppLocalizations.maybeOf(this);
    if (instance != null) return instance;

    return localization.l10n;
  }

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;
  ThemeData get theme => Theme.of(this);

  AuthBloc get authBloc => read<AuthBloc>();

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  void showSnackbar(SnackBar snackBar) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ));
  }
}
