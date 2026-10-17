import 'dart:async';
import 'package:flutter/foundation.dart';
import 'navigation_counts_controller.dart';

/// Mounted read models share the existing account subscription and recovery poll.
/// Local cart publications do not trigger additional order requests.
class NavigationRefreshBinding {
  NavigationRefreshBinding(this._refresh, this._clear);
  final Future<void> Function() _refresh;
  final VoidCallback _clear;
  NavigationCountsController? _navigation;
  Timer? _timer;
  bool _disposed = false;
  bool _running = false;
  bool _again = false;
  int _scope = 0;
  int _lastSynchronization = 0;

  bool bind(NavigationCountsController? navigation) {
    if (identical(_navigation, navigation)) return false;
    _navigation?.removeListener(_changed);
    _timer?.cancel();
    _timer = null;
    _again = false;
    _scope++;
    _navigation = navigation;
    _lastSynchronization = navigation?.synchronizationVersion ?? 0;
    navigation?.addListener(_changed);
    return true;
  }

  (int, int) get stamp => (_scope, _navigation?.accessVersion ?? 0);
  bool get active => !_disposed && (_navigation?.active ?? true);
  bool isCurrent((int, int) request) => active && request == stamp;
  bool isSameScope((int, int) request) => !_disposed && request.$1 == _scope;

  void _changed() {
    if (!(_navigation?.active ?? true)) {
      _scope++;
      _timer?.cancel();
      _timer = Timer(Duration.zero, () {
        _timer = null;
        if (!_disposed) _clear();
      });
      return;
    }
    final version = _navigation?.synchronizationVersion ?? 0;
    if (version == _lastSynchronization) return;
    _lastSynchronization = version;
    invalidate();
  }

  void invalidate() {
    if (_disposed || !(_navigation?.active ?? true)) return;
    if (_running) {
      _again = true;
      return;
    }
    _timer ??= Timer(const Duration(milliseconds: 100), () {
      _timer = null;
      unawaited(_synchronize());
    });
  }

  Future<void> _synchronize() async {
    if (_disposed || !(_navigation?.active ?? true)) return;
    if (_running) {
      _again = true;
      return;
    }
    _running = true;
    try {
      do {
        _again = false;
        await _refresh();
      } while (_again && !_disposed && (_navigation?.active ?? true));
    } finally {
      _running = false;
    }
  }

  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _navigation?.removeListener(_changed);
  }
}
