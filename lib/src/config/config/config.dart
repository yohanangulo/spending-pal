import 'package:spending_pal/src/config/service_locator/service_locator.dart';

enum Flavor {
  dev,
  prod;

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

Config get config => getIt<Config>();

class Config {
  Config._(this.flavor);

  final Flavor flavor;

  static Future<void> initialize(Flavor flavor) async {
    getIt.registerLazySingleton(() => Config._(flavor));
  }
}
