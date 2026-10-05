import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Tracks real internet reachability across the app.
class ConnectivityService extends ChangeNotifier {
  ConnectivityService()
    : _checker = kIsWeb
          ? null
          : InternetConnectionChecker.createInstance(
              checkTimeout: const Duration(seconds: 4),
              checkInterval: const Duration(seconds: 10),
              slowConnectionConfig: const SlowConnectionConfig(
                enableToCheckForSlowConnection: false,
              ),
              addresses: _probeAddresses,
            );

  /// Endpoints used by Android/iOS/Windows for captive-portal checks.
  static final List<AddressCheckOption> _probeAddresses = [
    AddressCheckOption(uri: Uri.parse('https://www.google.com/generate_204')),
    AddressCheckOption(
      uri: Uri.parse('https://connectivitycheck.gstatic.com/generate_204'),
    ),
    AddressCheckOption(uri: Uri.parse('https://firebase.googleapis.com/')),
  ];

  final InternetConnectionChecker? _checker;
  final Connectivity _connectivity = Connectivity();

  bool _isOnline = true;
  int _failedChecks = 0;

  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;

  StreamSubscription<InternetConnectionStatus>? _checkerSubscription;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  Future<void> initialize() async {
    await _evaluateConnectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((_) {
      unawaited(_evaluateConnectivity());
    });

    if (!kIsWeb) {
      _checkerSubscription = _checker!.onStatusChange.listen((status) {
        unawaited(_handleCheckerStatus(status));
      });
    }
  }

  Future<void> _evaluateConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    if (_hasNoNetworkInterface(results)) {
      _failedChecks = 0;
      _setOnline(false);
      return;
    }

    // Browser connectivity probes to Google/Firebase are blocked by CORS.
    // connectivity_plus already uses the browser's network state on web.
    if (kIsWeb) {
      _failedChecks = 0;
      _setOnline(true);
      return;
    }

    final hasInternet = await _checker!.hasConnection;
    if (hasInternet) {
      _failedChecks = 0;
      _setOnline(true);
      return;
    }

    _failedChecks++;
    if (_failedChecks >= 2) {
      _setOnline(false);
    }
  }

  Future<void> _handleCheckerStatus(InternetConnectionStatus status) async {
    if (status == InternetConnectionStatus.disconnected) {
      final results = await _connectivity.checkConnectivity();
      if (_hasNoNetworkInterface(results)) {
        _failedChecks = 0;
        _setOnline(false);
        return;
      }

      _failedChecks++;
      if (_failedChecks >= 2) {
        _setOnline(false);
      }
      return;
    }

    _failedChecks = 0;
    _setOnline(true);
  }

  bool _hasNoNetworkInterface(List<ConnectivityResult> results) {
    return results.isEmpty ||
        results.every((result) => result == ConnectivityResult.none);
  }

  void _setOnline(bool value) {
    if (_isOnline == value) {
      return;
    }
    _isOnline = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _checkerSubscription?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
