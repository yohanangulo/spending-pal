import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ConnectivityPlusModule {
  @lazySingleton
  Connectivity get connectivity => Connectivity();
}
