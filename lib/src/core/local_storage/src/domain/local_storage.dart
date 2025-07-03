abstract class LocalStorage {
  Future<void> setString(String key, String value);

  Future<String?> getString(String key);

  Future<void> setBool(String key, bool value);

  Future<bool?> getBool(String key);

  Future<void> setInt(String key, int value);

  Future<int?> getInt(String key);

  Future<void> setDouble(String key, double value);

  Future<double?> getDouble(String key);
}
