// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_areas_recruitment_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardAreasRecruitmentInner
    extends AdminDashboardAreasRecruitmentInner {
  @override
  final String code;
  @override
  final String name;
  @override
  final int vendors;
  @override
  final int orders;
  @override
  final num ordersPerVendor;

  factory _$AdminDashboardAreasRecruitmentInner(
          [void Function(AdminDashboardAreasRecruitmentInnerBuilder)?
              updates]) =>
      (AdminDashboardAreasRecruitmentInnerBuilder()..update(updates))._build();

  _$AdminDashboardAreasRecruitmentInner._(
      {required this.code,
      required this.name,
      required this.vendors,
      required this.orders,
      required this.ordersPerVendor})
      : super._();
  @override
  AdminDashboardAreasRecruitmentInner rebuild(
          void Function(AdminDashboardAreasRecruitmentInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardAreasRecruitmentInnerBuilder toBuilder() =>
      AdminDashboardAreasRecruitmentInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardAreasRecruitmentInner &&
        code == other.code &&
        name == other.name &&
        vendors == other.vendors &&
        orders == other.orders &&
        ordersPerVendor == other.ordersPerVendor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, vendors.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, ordersPerVendor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardAreasRecruitmentInner')
          ..add('code', code)
          ..add('name', name)
          ..add('vendors', vendors)
          ..add('orders', orders)
          ..add('ordersPerVendor', ordersPerVendor))
        .toString();
  }
}

class AdminDashboardAreasRecruitmentInnerBuilder
    implements
        Builder<AdminDashboardAreasRecruitmentInner,
            AdminDashboardAreasRecruitmentInnerBuilder> {
  _$AdminDashboardAreasRecruitmentInner? _$v;

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

  num? _ordersPerVendor;
  num? get ordersPerVendor => _$this._ordersPerVendor;
  set ordersPerVendor(num? ordersPerVendor) =>
      _$this._ordersPerVendor = ordersPerVendor;

  AdminDashboardAreasRecruitmentInnerBuilder() {
    AdminDashboardAreasRecruitmentInner._defaults(this);
  }

  AdminDashboardAreasRecruitmentInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _vendors = $v.vendors;
      _orders = $v.orders;
      _ordersPerVendor = $v.ordersPerVendor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardAreasRecruitmentInner other) {
    _$v = other as _$AdminDashboardAreasRecruitmentInner;
  }

  @override
  void update(
      void Function(AdminDashboardAreasRecruitmentInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardAreasRecruitmentInner build() => _build();

  _$AdminDashboardAreasRecruitmentInner _build() {
    final _$result = _$v ??
        _$AdminDashboardAreasRecruitmentInner._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AdminDashboardAreasRecruitmentInner', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminDashboardAreasRecruitmentInner', 'name'),
          vendors: BuiltValueNullFieldError.checkNotNull(
              vendors, r'AdminDashboardAreasRecruitmentInner', 'vendors'),
          orders: BuiltValueNullFieldError.checkNotNull(
              orders, r'AdminDashboardAreasRecruitmentInner', 'orders'),
          ordersPerVendor: BuiltValueNullFieldError.checkNotNull(
              ordersPerVendor,
              r'AdminDashboardAreasRecruitmentInner',
              'ordersPerVendor'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
