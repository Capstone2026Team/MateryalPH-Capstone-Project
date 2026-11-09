// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_location_map.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderLocationMap extends OrderLocationMap {
  @override
  final DeliveryNavigationRoutePoint? store;
  @override
  final DeliveryNavigationRoutePoint? destination;

  factory _$OrderLocationMap(
          [void Function(OrderLocationMapBuilder)? updates]) =>
      (OrderLocationMapBuilder()..update(updates))._build();

  _$OrderLocationMap._({this.store, this.destination}) : super._();
  @override
  OrderLocationMap rebuild(void Function(OrderLocationMapBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderLocationMapBuilder toBuilder() =>
      OrderLocationMapBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderLocationMap &&
        store == other.store &&
        destination == other.destination;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, store.hashCode);
    _$hash = $jc(_$hash, destination.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderLocationMap')
          ..add('store', store)
          ..add('destination', destination))
        .toString();
  }
}

class OrderLocationMapBuilder
    implements Builder<OrderLocationMap, OrderLocationMapBuilder> {
  _$OrderLocationMap? _$v;

  DeliveryNavigationRoutePointBuilder? _store;
  DeliveryNavigationRoutePointBuilder get store =>
      _$this._store ??= DeliveryNavigationRoutePointBuilder();
  set store(DeliveryNavigationRoutePointBuilder? store) =>
      _$this._store = store;

  DeliveryNavigationRoutePointBuilder? _destination;
  DeliveryNavigationRoutePointBuilder get destination =>
      _$this._destination ??= DeliveryNavigationRoutePointBuilder();
  set destination(DeliveryNavigationRoutePointBuilder? destination) =>
      _$this._destination = destination;

  OrderLocationMapBuilder() {
    OrderLocationMap._defaults(this);
  }

  OrderLocationMapBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _store = $v.store?.toBuilder();
      _destination = $v.destination?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderLocationMap other) {
    _$v = other as _$OrderLocationMap;
  }

  @override
  void update(void Function(OrderLocationMapBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderLocationMap build() => _build();

  _$OrderLocationMap _build() {
    _$OrderLocationMap _$result;
    try {
      _$result = _$v ??
          _$OrderLocationMap._(
            store: _store?.build(),
            destination: _destination?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'store';
        _store?.build();
        _$failedField = 'destination';
        _destination?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OrderLocationMap', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
