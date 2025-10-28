part of 'extensions.dart';

extension BrightnessExtensions on Brightness {
  bool get isDark => this == Brightness.dark;
  bool get isLight => this == Brightness.light;

  T when<T>({
    required T Function() dark,
    required T Function() light,
  }) {
    return switch (this) {
      Brightness.dark => dark(),
      Brightness.light => light(),
    };
  }
}
