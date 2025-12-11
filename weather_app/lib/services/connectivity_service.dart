import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final _conn = Connectivity();

  Future<bool> hasConnection() async {
    final r = await _conn.checkConnectivity();
    return r != ConnectivityResult.none;
  }

  Stream<bool> get onChanged async* {
    await for (final r in _conn.onConnectivityChanged) {
      yield r != ConnectivityResult.none;
    }
  }
}
