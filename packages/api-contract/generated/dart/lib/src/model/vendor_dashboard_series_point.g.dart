// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_series_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardSeriesPoint extends VendorDashboardSeriesPoint {
  @override
  final Date date;
  @override
  final int orders;
  @override
  final int orderRequests;
  @override
  final num? ordersAverage;
  @override
  final int? grossSalesCentavos;
  @override
  final int? netSalesCentavos;
  @override
  final int? salesAverageCentavos;

  factory _$VendorDashboardSeriesPoint(
          [void Function(VendorDashboardSeriesPointBuilder)? updates]) =>
      (VendorDashboardSeriesPointBuilder()..update(updates))._build();

  _$VendorDashboardSeriesPoint._(
      {required this.date,
      required this.orders,
      required this.orderRequests,
      this.ordersAverage,
      this.grossSalesCentavos,
      this.netSalesCentavos,
      this.salesAverageCentavos})
      : super._();
  @override
  VendorDashboardSeriesPoint rebuild(
          void Function(VendorDashboardSeriesPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardSeriesPointBuilder toBuilder() =>
      VendorDashboardSeriesPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardSeriesPoint &&
        date == other.date &&
        orders == other.orders &&
        orderRequests == other.orderRequests &&
        ordersAverage == other.ordersAverage &&
        grossSalesCentavos == other.grossSalesCentavos &&
        netSalesCentavos == other.netSalesCentavos &&
        salesAverageCentavos == other.salesAverageCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, orderRequests.hashCode);
    _$hash = $jc(_$hash, ordersAverage.hashCode);
    _$hash = $jc(_$hash, grossSalesCentavos.hashCode);
    _$hash = $jc(_$hash, netSalesCentavos.hashCode);
    _$hash = $jc(_$hash, salesAverageCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardSeriesPoint')
          ..add('date', date)
          ..add('orders', orders)
          ..add('orderRequests', orderRequests)
          ..add('ordersAverage', ordersAverage)
          ..add('grossSalesCentavos', grossSalesCentavos)
          ..add('netSalesCentavos', netSalesCentavos)
          ..add('salesAverageCentavos', salesAverageCentavos))
        .toString();
  }
}

class VendorDashboardSeriesPointBuilder
    implements
        Builder<VendorDashboardSeriesPoint, VendorDashboardSeriesPointBuilder> {
  _$VendorDashboardSeriesPoint? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  int? _orderRequests;
  int? get orderRequests => _$this._orderRequests;
  set orderRequests(int? orderRequests) =>
      _$this._orderRequests = orderRequests;

  num? _ordersAverage;
  num? get ordersAverage => _$this._ordersAverage;
  set ordersAverage(num? ordersAverage) =>
      _$this._ordersAverage = ordersAverage;

  int? _grossSalesCentavos;
  int? get grossSalesCentavos => _$this._grossSalesCentavos;
  set grossSalesCentavos(int? grossSalesCentavos) =>
      _$this._grossSalesCentavos = grossSalesCentavos;

  int? _netSalesCentavos;
  int? get netSalesCentavos => _$this._netSalesCentavos;
  set netSalesCentavos(int? netSalesCentavos) =>
      _$this._netSalesCentavos = netSalesCentavos;

  int? _salesAverageCentavos;
  int? get salesAverageCentavos => _$this._salesAverageCentavos;
  set salesAverageCentavos(int? salesAverageCentavos) =>
      _$this._salesAverageCentavos = salesAverageCentavos;

  VendorDashboardSeriesPointBuilder() {
    VendorDashboardSeriesPoint._defaults(this);
  }

  VendorDashboardSeriesPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _orders = $v.orders;
      _orderRequests = $v.orderRequests;
      _ordersAverage = $v.ordersAverage;
      _grossSalesCentavos = $v.grossSalesCentavos;
      _netSalesCentavos = $v.netSalesCentavos;
      _salesAverageCentavos = $v.salesAverageCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardSeriesPoint other) {
    _$v = other as _$VendorDashboardSeriesPoint;
  }

  @override
  void update(void Function(VendorDashboardSeriesPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardSeriesPoint build() => _build();

  _$VendorDashboardSeriesPoint _build() {
    final _$result = _$v ??
        _$VendorDashboardSeriesPoint._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'VendorDashboardSeriesPoint', 'date'),
          orders: BuiltValueNullFieldError.checkNotNull(
              orders, r'VendorDashboardSeriesPoint', 'orders'),
          orderRequests: BuiltValueNullFieldError.checkNotNull(
              orderRequests, r'VendorDashboardSeriesPoint', 'orderRequests'),
          ordersAverage: ordersAverage,
          grossSalesCentavos: grossSalesCentavos,
          netSalesCentavos: netSalesCentavos,
          salesAverageCentavos: salesAverageCentavos,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
