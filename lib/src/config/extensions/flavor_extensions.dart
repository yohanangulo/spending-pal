part of 'extensions.dart';

extension FlavorExtension on Flavor {
  String get appName {
    switch (this) {
      case Flavor.dev:
        return 'Spending Pal DEV';
      case Flavor.prod:
        return 'Spending Pal';
    }
  }

  bool get isDev => this == Flavor.dev;
  bool get isProd => this == Flavor.prod;
}
