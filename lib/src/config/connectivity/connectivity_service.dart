import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ConnectivityService {
  ConnectivityService(this._connectivity);

  final Connectivity _connectivity;

  Future<bool> get isConnected async {
    final currentConnections = await _connectivity.checkConnectivity();
    return !currentConnections.contains(ConnectivityResult.none);
  }
}
