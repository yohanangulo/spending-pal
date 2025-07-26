import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/user/src/infrastructure/user_preferences_repository.dart';

@injectable
class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit(
    this._repository,
  ) : super(_repository.getThemeMode()) {
    _init();
  }

  final UserPreferencesRepository _repository;

  void _init() {
    _repository.watchThemeMode().listen(emit);
  }

  void changeThemeMode(ThemeMode themeMode) => _repository.setThemeMode(themeMode);
}
