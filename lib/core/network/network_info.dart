import 'dart:io';
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

    // 1. Try standard connection checker (pings)
    bool connected = await connectionChecker.hasConnection;

    // 2. Fallback: Try DNS lookup if pings are blocked (common on some Wi-Fi)
    if (!connected) {
      try {
        final result = await InternetAddress.lookup(
          'google.com',
        ).timeout(const Duration(seconds: 3));
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          connected = true;
        }
      } catch (_) {
        connected = false;
      }
    }

    _lastResult = connected;
    _lastCheck = now;
    return connected;
  }
}
