import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  ConnectivityCubit() : super(ConnectivityStatus.online) {
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _sub;

  Future<void> _init() async {
    // Check current status immediately
    final results = await _connectivity.checkConnectivity();
    _emit(results);

    // Listen for changes
    _sub = _connectivity.onConnectivityChanged.listen(_emit);
  }

  void _emit(List<ConnectivityResult> results) {
    final hasConnection = results.any((r) => r != ConnectivityResult.none);
    emit(hasConnection ? ConnectivityStatus.online : ConnectivityStatus.offline);
  }

  /// Manually re-check (used by the retry button).
  Future<void> retry() async {
    final results = await _connectivity.checkConnectivity();
    _emit(results);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
