import 'dart:async';
import 'package:flutter/foundation.dart';
import '../map_discovery/discovery_models.dart';

@immutable
class BuyerNavigationCounts {
  const BuyerNavigationCounts({
    this.messages = 0,
    this.orders = 0,
    this.disputes = 0,
    this.cartQuantity = '0',
    this.cartVersion = 0,
  });
  final int messages;
  final int orders;
  final int disputes;
  final String cartQuantity;
  final int cartVersion;
}

abstract interface class NavigationCountsTransport {
  Future<BuyerNavigationCounts> counts();
  Future<void Function()> watchCounts(void Function() refresh);
}

/// One foreground snapshot for navigation, profile counters and cart shortcuts.
class NavigationCountsController extends ChangeNotifier {
  NavigationCountsController(this._transport);
  final NavigationCountsTransport _transport;
  BuyerNavigationCounts value = const BuyerNavigationCounts();
  bool _active = false;
  bool _disposed = false;
  bool _again = false;
  int _generation = 0;
  int _synchronizationVersion = 0;
  bool get active => _active && !_disposed;
  int get accessVersion => _generation;
  int get synchronizationVersion => _synchronizationVersion;
  Future<void>? _loading;
  Timer? _poll;
  Timer? _invalidation;
  void Function()? _stop;

  void setActive(bool active, {bool clear = false}) {
    if (_disposed) return;
    if (!active) {
      _active = false;
      _generation++;
      _poll?.cancel();
      _invalidation?.cancel();
      _invalidation = null;
      _stop?.call();
      _stop = null;
      _loading = null;
      _again = false;
      if (clear) {
        value = const BuyerNavigationCounts();
        notifyListeners();
      }
      return;
    }
    if (_active) return;
    _active = true;
    final generation = ++_generation;
    unawaited(refresh());
    _poll = Timer.periodic(
      const Duration(seconds: 15),
      (_) => unawaited(refresh()),
    );
    unawaited(
      _transport
          .watchCounts(invalidate)
          .then((stop) {
            if (_current(generation)) {
              _stop = stop;
            } else {
              stop();
            }
          })
          .catchError((Object _) {}),
    );
  }

  void invalidate() {
    if (!_active || _disposed) return;
    if (_loading != null) _again = true;
    _invalidation ??= Timer(const Duration(milliseconds: 100), () {
      _invalidation = null;
      unawaited(refresh());
    });
  }

  bool _current(int generation) =>
      !_disposed && _active && generation == _generation;

  void publishCart(String quantity, int version) {
    if (!_active || _disposed || version < value.cartVersion) return;
    value = BuyerNavigationCounts(
      messages: value.messages,
      orders: value.orders,
      disputes: value.disputes,
      cartQuantity: quantity,
      cartVersion: version,
    );
    notifyListeners();
  }

  Future<void> refresh() {
    if (!_active || _disposed) return Future.value();
    if (_loading != null) {
      _again = true;
      return _loading!;
    }
    final generation = _generation;
    final future = _load(generation);
    _loading = future;
    return future.whenComplete(() {
      if (!_current(generation)) return;
      _loading = null;
      if (_again) {
        _again = false;
        unawaited(refresh());
      }
    });
  }

  Future<void> _load(int generation) async {
    try {
      final snapshot = await _transport.counts();
      if (!_current(generation)) return;
      value = snapshot.cartVersion < value.cartVersion
          ? BuyerNavigationCounts(
              messages: snapshot.messages,
              orders: snapshot.orders,
              disputes: snapshot.disputes,
              cartQuantity: value.cartQuantity,
              cartVersion: value.cartVersion,
            )
          : snapshot;
      _synchronizationVersion++;
      notifyListeners();
    } on DiscoveryFailure catch (error) {
      if (!_current(generation)) return;
      if (error.kind == DiscoveryFailureKind.sessionExpired ||
          error.kind == DiscoveryFailureKind.forbidden) {
        setActive(false, clear: true);
      }
    } catch (_) {
      /* Retain the last snapshot while reconnecting; REST recovery retries. */
    }
  }

  @override
  void dispose() {
    setActive(false);
    _disposed = true;
    super.dispose();
  }
}
