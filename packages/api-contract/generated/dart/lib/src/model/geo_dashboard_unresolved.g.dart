// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_dashboard_unresolved.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoDashboardUnresolved extends GeoDashboardUnresolved {
  @override
  final int orders;
  @override
  final int vendors;
  @override
  final int registeredBuyers;
  @override
  final int responses;
  @override
  final int activity;

  factory _$GeoDashboardUnresolved(
          [void Function(GeoDashboardUnresolvedBuilder)? updates]) =>
      (GeoDashboardUnresolvedBuilder()..update(updates))._build();

  _$GeoDashboardUnresolved._(
      {required this.orders,
      required this.vendors,
      required this.registeredBuyers,
      required this.responses,
      required this.activity})
      : super._();
  @override
  GeoDashboardUnresolved rebuild(
          void Function(GeoDashboardUnresolvedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoDashboardUnresolvedBuilder toBuilder() =>
      GeoDashboardUnresolvedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoDashboardUnresolved &&
        orders == other.orders &&
        vendors == other.vendors &&
        registeredBuyers == other.registeredBuyers &&
        responses == other.responses &&
        activity == other.activity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, vendors.hashCode);
    _$hash = $jc(_$hash, registeredBuyers.hashCode);
    _$hash = $jc(_$hash, responses.hashCode);
    _$hash = $jc(_$hash, activity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoDashboardUnresolved')
          ..add('orders', orders)
          ..add('vendors', vendors)
          ..add('registeredBuyers', registeredBuyers)
          ..add('responses', responses)
          ..add('activity', activity))
        .toString();
  }
}

class GeoDashboardUnresolvedBuilder
    implements Builder<GeoDashboardUnresolved, GeoDashboardUnresolvedBuilder> {
  _$GeoDashboardUnresolved? _$v;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  int? _vendors;
  int? get vendors => _$this._vendors;
  set vendors(int? vendors) => _$this._vendors = vendors;

  int? _registeredBuyers;
  int? get registeredBuyers => _$this._registeredBuyers;
  set registeredBuyers(int? registeredBuyers) =>
      _$this._registeredBuyers = registeredBuyers;

  int? _responses;
  int? get responses => _$this._responses;
  set responses(int? responses) => _$this._responses = responses;

  int? _activity;
  int? get activity => _$this._activity;
  set activity(int? activity) => _$this._activity = activity;

  GeoDashboardUnresolvedBuilder() {
    GeoDashboardUnresolved._defaults(this);
  }

  GeoDashboardUnresolvedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orders = $v.orders;
      _vendors = $v.vendors;
      _registeredBuyers = $v.registeredBuyers;
      _responses = $v.responses;
      _activity = $v.activity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoDashboardUnresolved other) {
    _$v = other as _$GeoDashboardUnresolved;
  }

  @override
  void update(void Function(GeoDashboardUnresolvedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoDashboardUnresolved build() => _build();

  _$GeoDashboardUnresolved _build() {
    final _$result = _$v ??
        _$GeoDashboardUnresolved._(
          orders: BuiltValueNullFieldError.checkNotNull(
              orders, r'GeoDashboardUnresolved', 'orders'),
          vendors: BuiltValueNullFieldError.checkNotNull(
              vendors, r'GeoDashboardUnresolved', 'vendors'),
          registeredBuyers: BuiltValueNullFieldError.checkNotNull(
              registeredBuyers, r'GeoDashboardUnresolved', 'registeredBuyers'),
          responses: BuiltValueNullFieldError.checkNotNull(
              responses, r'GeoDashboardUnresolved', 'responses'),
          activity: BuiltValueNullFieldError.checkNotNull(
              activity, r'GeoDashboardUnresolved', 'activity'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
