// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_areas_unusual_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardAreasUnusualInner
    extends AdminDashboardAreasUnusualInner {
  @override
  final String code;
  @override
  final String name;
  @override
  final int vendors;
  @override
  final int orders;
  @override
  final int gmvCentavos;

  factory _$AdminDashboardAreasUnusualInner(
          [void Function(AdminDashboardAreasUnusualInnerBuilder)? updates]) =>
      (AdminDashboardAreasUnusualInnerBuilder()..update(updates))._build();

  _$AdminDashboardAreasUnusualInner._(
      {required this.code,
      required this.name,
      required this.vendors,
      required this.orders,
      required this.gmvCentavos})
      : super._();
  @override
  AdminDashboardAreasUnusualInner rebuild(
          void Function(AdminDashboardAreasUnusualInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardAreasUnusualInnerBuilder toBuilder() =>
      AdminDashboardAreasUnusualInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardAreasUnusualInner &&
        code == other.code &&
        name == other.name &&
        vendors == other.vendors &&
        orders == other.orders &&
        gmvCentavos == other.gmvCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, vendors.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, gmvCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardAreasUnusualInner')
          ..add('code', code)
          ..add('name', name)
          ..add('vendors', vendors)
          ..add('orders', orders)
          ..add('gmvCentavos', gmvCentavos))
        .toString();
  }
}

class AdminDashboardAreasUnusualInnerBuilder
    implements
        Builder<AdminDashboardAreasUnusualInner,
            AdminDashboardAreasUnusualInnerBuilder> {
  _$AdminDashboardAreasUnusualInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _vendors;
  int? get vendors => _$this._vendors;
  set vendors(int? vendors) => _$this._vendors = vendors;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  int? _gmvCentavos;
  int? get gmvCentavos => _$this._gmvCentavos;
  set gmvCentavos(int? gmvCentavos) => _$this._gmvCentavos = gmvCentavos;

  AdminDashboardAreasUnusualInnerBuilder() {
    AdminDashboardAreasUnusualInner._defaults(this);
  }

  AdminDashboardAreasUnusualInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _vendors = $v.vendors;
      _orders = $v.orders;
      _gmvCentavos = $v.gmvCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardAreasUnusualInner other) {
    _$v = other as _$AdminDashboardAreasUnusualInner;
  }

  @override
  void update(void Function(AdminDashboardAreasUnusualInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardAreasUnusualInner build() => _build();

  _$AdminDashboardAreasUnusualInner _build() {
    final _$result = _$v ??
        _$AdminDashboardAreasUnusualInner._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AdminDashboardAreasUnusualInner', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminDashboardAreasUnusualInner', 'name'),
          vendors: BuiltValueNullFieldError.checkNotNull(
              vendors, r'AdminDashboardAreasUnusualInner', 'vendors'),
          orders: BuiltValueNullFieldError.checkNotNull(
              orders, r'AdminDashboardAreasUnusualInner', 'orders'),
          gmvCentavos: BuiltValueNullFieldError.checkNotNull(
              gmvCentavos, r'AdminDashboardAreasUnusualInner', 'gmvCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
