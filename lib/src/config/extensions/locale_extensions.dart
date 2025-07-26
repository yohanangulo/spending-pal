part of 'extensions.dart';

extension LocaleNameX on Locale {
  String get localeName {
    return switch (languageCode) {
      'es' => 'Español',
      'en' => 'English',
      _ => languageCode,
    };
  }
}
