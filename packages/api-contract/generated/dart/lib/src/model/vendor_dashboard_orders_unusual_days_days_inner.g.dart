// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_orders_unusual_days_days_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardOrdersUnusualDaysDaysInner
    extends VendorDashboardOrdersUnusualDaysDaysInner {
  @override
  final Date date;
  @override
  final int orders;
  @override
  final int? grossSalesCentavos;

  factory _$VendorDashboardOrdersUnusualDaysDaysInner(
          [void Function(VendorDashboardOrdersUnusualDaysDaysInnerBuilder)?
              updates]) =>
      (VendorDashboardOrdersUnusualDaysDaysInnerBuilder()..update(updates))
          ._build();

  _$VendorDashboardOrdersUnusualDaysDaysInner._(
      {required this.date, required this.orders, this.grossSalesCentavos})
      : super._();
  @override
  VendorDashboardOrdersUnusualDaysDaysInner rebuild(
          void Function(VendorDashboardOrdersUnusualDaysDaysInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardOrdersUnusualDaysDaysInnerBuilder toBuilder() =>
      VendorDashboardOrdersUnusualDaysDaysInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardOrdersUnusualDaysDaysInner &&
        date == other.date &&
        orders == other.orders &&
        grossSalesCentavos == other.grossSalesCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, grossSalesCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VendorDashboardOrdersUnusualDaysDaysInner')
          ..add('date', date)
          ..add('orders', orders)
          ..add('grossSalesCentavos', grossSalesCentavos))
        .toString();
  }
}

class VendorDashboardOrdersUnusualDaysDaysInnerBuilder
    implements
        Builder<VendorDashboardOrdersUnusualDaysDaysInner,
            VendorDashboardOrdersUnusualDaysDaysInnerBuilder> {
  _$VendorDashboardOrdersUnusualDaysDaysInner? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  int? _grossSalesCentavos;
  int? get grossSalesCentavos => _$this._grossSalesCentavos;
  set grossSalesCentavos(int? grossSalesCentavos) =>
      _$this._grossSalesCentavos = grossSalesCentavos;

  VendorDashboardOrdersUnusualDaysDaysInnerBuilder() {
    VendorDashboardOrdersUnusualDaysDaysInner._defaults(this);
  }

  VendorDashboardOrdersUnusualDaysDaysInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _orders = $v.orders;
      _grossSalesCentavos = $v.grossSalesCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardOrdersUnusualDaysDaysInner other) {
    _$v = other as _$VendorDashboardOrdersUnusualDaysDaysInner;
  }

  @override
  void update(
      void Function(VendorDashboardOrdersUnusualDaysDaysInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardOrdersUnusualDaysDaysInner build() => _build();

  _$VendorDashboardOrdersUnusualDaysDaysInner _build() {
    final _$result = _$v ??
        _$VendorDashboardOrdersUnusualDaysDaysInner._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'VendorDashboardOrdersUnusualDaysDaysInner', 'date'),
          orders: BuiltValueNullFieldError.checkNotNull(
              orders, r'VendorDashboardOrdersUnusualDaysDaysInner', 'orders'),
          grossSalesCentavos: grossSalesCentavos,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
