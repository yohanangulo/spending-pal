import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class UserPreferencesRepository {
  UserPreferencesRepository(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  static const String _localeKey = 'locale_name';
  static const String _themeModeKey = 'theme_mode';

  // ----- subjects -----
  final _localeNameSubject = PublishSubject<String>();
  final _themeModeSubject = PublishSubject<ThemeMode>();

  // ----- methods -----

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _sharedPreferences.setString(_themeModeKey, themeMode.name);
    _themeModeSubject.add(themeMode);
  }

  Future<void> setLocaleName(String localeName) async {
    await _sharedPreferences.setString(_localeKey, localeName);
    _localeNameSubject.add(localeName);
  }

  String? getLocaleName() {
    final locale = _sharedPreferences.getString(_localeKey);

    if (locale == null || locale.isEmpty) return null;

    return locale;
  }

  ThemeMode getThemeMode() {
    final themeMode = _sharedPreferences.getString(_themeModeKey);

    if (themeMode == null || themeMode.isEmpty) return ThemeMode.system;

    return ThemeMode.values.firstWhere((e) => e.name == themeMode);
  }

  Stream<String> watchLocaleName() => _localeNameSubject.stream.asBroadcastStream();

  Stream<ThemeMode> watchThemeMode() => _themeModeSubject.stream.asBroadcastStream();
}
