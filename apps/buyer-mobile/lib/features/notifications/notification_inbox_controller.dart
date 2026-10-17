import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import '../map_discovery/discovery_models.dart';

abstract interface class NotificationInboxTransport {
  Future<api.ListNotifications200Response> list([String? cursor]);
  Future<api.NotificationBulkReadAction> readAll(
    String throughId,
    String? category,
  );
  Future<String> resolve(String id);
  Future<void Function()> watch(void Function() refresh);
}

String notificationCategoryLabel(String category) => switch (category) {
  'SECURITY' => 'Account security update',
  'TEAM' => 'Team access changed',
  'ORDERS' => 'Order updates',
  'INVOICES' => 'Invoice updates',
  'PAYMENT' => 'Payment updates',
  'REFUND' => 'Refund updates',
  'FINANCE_MANDATORY' => 'Finance notices',
  _ =>
    category.isEmpty
        ? 'Other updates'
        : '${category[0].toUpperCase()}${category.substring(1).toLowerCase().replaceAll('_', ' ')}',
};

/// One authenticated inbox snapshot drives the list and every Buyer bell badge.
/// Realtime carries invalidations only; REST rechecks access to each notice.
class NotificationInboxController extends ChangeNotifier {
  NotificationInboxController(this._transport);

  final NotificationInboxTransport _transport;
  List<api.NotificationItem> _items = const [];
  List<api.NotificationItem> get items => List.unmodifiable(_items);
  String? category;
  String? error;
  bool loaded = false;
  bool marking = false;
  bool opening = false;
  bool _active = false, _disposed = false, _refreshAgain = false;
  bool _mutationError = false;
  int _generation = 0, _readVersion = 0;
  Future<void>? _refreshing;
  Timer? _poll, _invalidation;
  void Function()? _stopWatch;
  Set<String> _pendingReads = const {};
  String? _pendingReadAt;

  int get accessVersion => _generation;

  int get unreadCount => _items.where((item) => item.readAt == null).length;
  List<String> get categories {
    final values = _items.map((item) => item.category).toSet().toList();
    values.sort(
      (a, b) =>
          notificationCategoryLabel(a).compareTo(notificationCategoryLabel(b)),
    );
    return values;
  }

  Iterable<api.NotificationItem> get _matchingType =>
      _items.where((item) => category == null || item.category == category);
  int get filteredUnreadCount =>
      _matchingType.where((item) => item.readAt == null).length;

  /// The inbox lists unread notices only; a notice leaves it once read.
  List<api.NotificationItem> get visible =>
      _matchingType.where((item) => item.readAt == null).toList();
  bool get filtersActive => category != null;
  bool get canMarkAll =>
      loaded && !marking && !opening && filteredUnreadCount > 0;

  void filter({String? type, bool clearType = false}) {
    if (clearType) {
      category = null;
    } else if (type != null) {
      category = type;
    }
    _emit();
  }

  void clearFilters() {
    category = null;
    _emit();
  }

  void setActive(bool active, {bool clear = false}) {
    if (_disposed) return;
    if (!active) {
      _active = false;
      _generation++;
      _refreshAgain = false;
      _refreshing = null;
      _poll?.cancel();
      _invalidation?.cancel();
      _stopWatch?.call();
      _stopWatch = null;
      if (_pendingReads.isNotEmpty) {
        _items = _items
            .map(
              (item) =>
                  _pendingReads.contains(item.id) &&
                      item.readAt == _pendingReadAt
                  ? item.rebuild((b) => b..readAt = null)
                  : item,
            )
            .toList();
      }
      _pendingReads = const {};
      _pendingReadAt = null;
      marking = opening = false;
      _readVersion++;
      if (clear) {
        _items = const [];
        _pendingReads = const {};
        _pendingReadAt = null;
        loaded = marking = opening = false;
        error = category = null;
        _mutationError = false;
        _emit();
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
          .watch(() {
            if (!_current(generation)) return;
            _invalidation?.cancel();
            _invalidation = Timer(
              const Duration(milliseconds: 150),
              () => unawaited(refresh()),
            );
          })
          .then((stop) {
            if (!_current(generation)) {
              stop();
            } else {
              _stopWatch = stop;
            }
          })
          .catchError((Object _) {}),
    );
  }

  bool _current(int generation) =>
      !_disposed && _active && generation == _generation;

  Future<void> refresh() {
    if (!_active || _disposed) return Future.value();
    if (_refreshing != null) {
      _refreshAgain = true;
      return _refreshing!;
    }
    final generation = _generation;
    final future = _load(generation);
    _refreshing = future;
    return future.whenComplete(() {
      if (!_current(generation)) return;
      _refreshing = null;
      if (_refreshAgain) {
        _refreshAgain = false;
        unawaited(refresh());
      }
    });
  }

  Future<void> _load(int generation) async {
    final version = _readVersion;
    try {
      final snapshot = <String, api.NotificationItem>{};
      final cursors = <String>{};
      String? cursor;
      do {
        final page = await _transport.list(cursor);
        if (!_current(generation)) return;
        for (final item in page.data) {
          snapshot[item.id] = item;
        }
        cursor = page.meta['next_cursor']?.value as String?;
        if (cursor != null && !cursors.add(cursor)) {
          throw StateError('Repeated notification cursor');
        }
      } while (cursor != null);
      if (version != _readVersion) {
        _refreshAgain = true;
        return;
      }
      final result = snapshot.values.toList()
        ..sort((a, b) => b.id.compareTo(a.id));
      _items = _withReads(result, _pendingReads, _pendingReadAt);
      loaded = true;
      if (!_mutationError && !marking && !opening) error = null;
      _emit();
    } catch (failure) {
      if (!_current(generation)) return;
      _failure(failure);
    }
  }

  Future<void> markAllRead() async {
    if (!canMarkAll) return;
    final generation = _generation;
    final ids = _matchingType
        .where((item) => item.readAt == null)
        .map((item) => item.id)
        .toSet();
    final throughId = _items.first.id;
    final selectedCategory = category;
    final optimisticAt = DateTime.now().toUtc().toIso8601String();
    _readVersion++;
    _pendingReads = ids;
    _pendingReadAt = optimisticAt;
    _items = _withReads(_items, ids, optimisticAt);
    marking = true;
    _mutationError = false;
    error = null;
    _emit();
    try {
      final result = await _transport.readAll(throughId, selectedCategory);
      if (!_current(generation)) return;
      _items = _withReads(_items, ids, result.readAt);
    } catch (failure) {
      if (!_current(generation)) return;
      _items = _items
          .map(
            (item) => ids.contains(item.id) && item.readAt == optimisticAt
                ? item.rebuild((b) => b..readAt = null)
                : item,
          )
          .toList();
      _mutationError = true;
      _failure(failure);
    } finally {
      if (_current(generation)) {
        _pendingReads = const {};
        _pendingReadAt = null;
        marking = false;
        _readVersion++;
        _emit();
        unawaited(refresh());
      }
    }
  }

  Future<String?> open(String id) async {
    if (!_active || opening || marking) return null;
    final generation = _generation;
    opening = true;
    _mutationError = false;
    error = null;
    _emit();
    try {
      final path = await _transport.resolve(id);
      if (!_current(generation)) return null;
      _readVersion++;
      _items = _withReads(_items, {
        id,
      }, DateTime.now().toUtc().toIso8601String());
      return path;
    } catch (failure) {
      if (_current(generation)) {
        _mutationError = true;
        _failure(failure);
      }
      return null;
    } finally {
      if (_current(generation)) {
        opening = false;
        _emit();
        unawaited(refresh());
      }
    }
  }

  List<api.NotificationItem> _withReads(
    List<api.NotificationItem> items,
    Set<String> ids,
    String? at,
  ) => items
      .map(
        (item) =>
            ids.contains(item.id) ? item.rebuild((b) => b..readAt = at) : item,
      )
      .toList();

  Future<void> retry() {
    _mutationError = false;
    error = null;
    setActive(true);
    return refresh();
  }

  void _failure(Object failure) {
    error = failure is DiscoveryFailure
        ? failure.message
        : 'This request could not be completed. Check your connection and retry.';
    if (failure is DiscoveryFailure &&
        (failure.kind == DiscoveryFailureKind.forbidden ||
            failure.kind == DiscoveryFailureKind.sessionExpired)) {
      setActive(false, clear: true);
      error = failure.message;
    }
    _emit();
  }

  void _emit() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    setActive(false, clear: true);
    _disposed = true;
    super.dispose();
  }
}
