import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  // Simple cache to avoid redundant pings during rapid batches of requests
  bool? _lastResult;
  DateTime? _lastCheck;

  @override
  Future<bool> get isConnected async {
    final now = DateTime.now();
    if (_lastResult != null &&
        _lastCheck != null &&
        now.difference(_lastCheck!).inSeconds < 3) {
      return _lastResult!;
    }
    _lastResult = await connectionChecker.hasConnection;
    _lastCheck = now;
    return _lastResult!;
  }
}
