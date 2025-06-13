import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:spending_pal/src/config/service_locator/service_locator.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
