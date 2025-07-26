import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/config/translations/l10n.dart';
import 'package:spending_pal/src/core/user/src/infrastructure/user_preferences_repository.dart';

@injectable
class AppLocalizationsCubit extends Cubit<Locale> {
  AppLocalizationsCubit(
    this._repository,
  ) : super(L10n.currentSupportedLocale) {
    _init();
  }

  final UserPreferencesRepository _repository;

  void _init() {
    _repository.watchLocaleName().listen((localeName) {
      emit(Locale(localeName));
    });
  }

  void changeLocale(Locale locale) => _repository.setLocaleName(locale.languageCode);
}
