import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spending_pal/src/core/local_storage/domain.dart';

@LazySingleton(as: LocalStorage)
class LocalStorageImpl implements LocalStorage {
  LocalStorageImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Future<bool?> getBool(String key) async {
    return _sharedPreferences.getBool(key);
  }

  @override
  Future<double?> getDouble(String key) async {
    return _sharedPreferences.getDouble(key);
  }

  @override
  Future<int?> getInt(String key) async {
    return _sharedPreferences.getInt(key);
  }

  @override
  Future<String?> getString(String key) async {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await _sharedPreferences.setBool(key, value);
  }

  @override
  Future<void> setDouble(String key, double value) async {
    await _sharedPreferences.setDouble(key, value);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _sharedPreferences.setInt(key, value);
  }

  @override
  Future<void> setString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }
}
