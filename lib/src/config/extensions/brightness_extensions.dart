part of 'extensions.dart';

extension BrightnessExtensions on Brightness {
  bool get isDark => this == Brightness.dark;
  bool get isLight => this == Brightness.light;
}
