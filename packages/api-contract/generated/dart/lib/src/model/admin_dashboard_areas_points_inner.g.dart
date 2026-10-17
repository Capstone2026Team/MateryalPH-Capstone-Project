// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_areas_points_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardAreasPointsInner extends AdminDashboardAreasPointsInner {
  @override
  final String name;
  @override
  final int vendors;
  @override
  final int orders;
  @override
  final String segment;

  factory _$AdminDashboardAreasPointsInner(
          [void Function(AdminDashboardAreasPointsInnerBuilder)? updates]) =>
      (AdminDashboardAreasPointsInnerBuilder()..update(updates))._build();

  _$AdminDashboardAreasPointsInner._(
      {required this.name,
      required this.vendors,
      required this.orders,
      required this.segment})
      : super._();
  @override
  AdminDashboardAreasPointsInner rebuild(
          void Function(AdminDashboardAreasPointsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardAreasPointsInnerBuilder toBuilder() =>
      AdminDashboardAreasPointsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardAreasPointsInner &&
        name == other.name &&
        vendors == other.vendors &&
        orders == other.orders &&
        segment == other.segment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, vendors.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, segment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardAreasPointsInner')
          ..add('name', name)
          ..add('vendors', vendors)
          ..add('orders', orders)
          ..add('segment', segment))
        .toString();
  }
}

class AdminDashboardAreasPointsInnerBuilder
    implements
        Builder<AdminDashboardAreasPointsInner,
            AdminDashboardAreasPointsInnerBuilder> {
  _$AdminDashboardAreasPointsInner? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _vendors;
  int? get vendors => _$this._vendors;
  set vendors(int? vendors) => _$this._vendors = vendors;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  String? _segment;
  String? get segment => _$this._segment;
  set segment(String? segment) => _$this._segment = segment;

  AdminDashboardAreasPointsInnerBuilder() {
    AdminDashboardAreasPointsInner._defaults(this);
  }

  AdminDashboardAreasPointsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _vendors = $v.vendors;
      _orders = $v.orders;
      _segment = $v.segment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardAreasPointsInner other) {
    _$v = other as _$AdminDashboardAreasPointsInner;
  }

  @override
  void update(void Function(AdminDashboardAreasPointsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardAreasPointsInner build() => _build();

  _$AdminDashboardAreasPointsInner _build() {
    final _$result = _$v ??
        _$AdminDashboardAreasPointsInner._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminDashboardAreasPointsInner', 'name'),
          vendors: BuiltValueNullFieldError.checkNotNull(
              vendors, r'AdminDashboardAreasPointsInner', 'vendors'),
          orders: BuiltValueNullFieldError.checkNotNull(
              orders, r'AdminDashboardAreasPointsInner', 'orders'),
          segment: BuiltValueNullFieldError.checkNotNull(
              segment, r'AdminDashboardAreasPointsInner', 'segment'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
