import 'dart:async';

import 'package:flutter/widgets.dart';

/// Revalidates a visible destination on entry/resume and every five seconds after completion.
/// Hidden tabs, covered routes and background apps pause; failures back off up to one minute.
mixin ForegroundRefresh<T extends StatefulWidget> on State<T> {
  Future<bool> refreshInForeground();

  Timer? _refreshTimer;
  late final AppLifecycleListener _refreshLifecycle;
  bool _refreshVisible = false;
  bool _refreshResumed = true;
  bool _refreshActive = false;
  bool _refreshRunning = false;
  int _refreshFailures = 0;

  @override
  void initState() {
    super.initState();
    final state = WidgetsBinding.instance.lifecycleState;
    _refreshResumed = state == null || state == AppLifecycleState.resumed;
    _refreshLifecycle = AppLifecycleListener(
      onStateChange: (state) {
        _refreshResumed = state == AppLifecycleState.resumed;
        _updateRefreshActivity();
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshVisible =
        TickerMode.valuesOf(context).enabled &&
        (ModalRoute.of(context)?.isCurrent ?? true);
    _updateRefreshActivity();
  }

  void _updateRefreshActivity() {
    final active = _refreshVisible && _refreshResumed;
    if (active == _refreshActive) return;
    _refreshActive = active;
    _refreshTimer?.cancel();
    if (active) {
      _refreshFailures = 0;
      // Controllers may notify listeners; wait until dependency rebuilding finishes.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _refreshActive) unawaited(_refreshForeground());
      });
      WidgetsBinding.instance.ensureVisualUpdate();
    }
  }

  Future<void> _refreshForeground() async {
    if (!mounted || !_refreshActive || _refreshRunning) return;
    _refreshRunning = true;
    var success = false;
    try {
      success = await refreshInForeground();
    } catch (_) {
      // A failed background read must not escape into the widget lifecycle.
      success = false;
    } finally {
      _refreshRunning = false;
      if (mounted && _refreshActive) {
        _refreshFailures = success ? 0 : (_refreshFailures + 1).clamp(0, 4);
        final seconds = (5 * (1 << _refreshFailures)).clamp(5, 60);
        _refreshTimer = Timer(Duration(seconds: seconds), () {
          unawaited(_refreshForeground());
        });
      }
    }
  }

  @override
  void dispose() {
    _refreshActive = false;
    _refreshTimer?.cancel();
    _refreshLifecycle.dispose();
    super.dispose();
  }
}
