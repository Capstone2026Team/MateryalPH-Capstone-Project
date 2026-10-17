// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_insights_access.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardInsightsAccess extends VendorDashboardInsightsAccess {
  @override
  final bool orders;
  @override
  final bool salesValue;
  @override
  final bool performance;
  @override
  final bool stock;
  @override
  final bool disputes;
  @override
  final bool assignedFulfillment;

  factory _$VendorDashboardInsightsAccess(
          [void Function(VendorDashboardInsightsAccessBuilder)? updates]) =>
      (VendorDashboardInsightsAccessBuilder()..update(updates))._build();

  _$VendorDashboardInsightsAccess._(
      {required this.orders,
      required this.salesValue,
      required this.performance,
      required this.stock,
      required this.disputes,
      required this.assignedFulfillment})
      : super._();
  @override
  VendorDashboardInsightsAccess rebuild(
          void Function(VendorDashboardInsightsAccessBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardInsightsAccessBuilder toBuilder() =>
      VendorDashboardInsightsAccessBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardInsightsAccess &&
        orders == other.orders &&
        salesValue == other.salesValue &&
        performance == other.performance &&
        stock == other.stock &&
        disputes == other.disputes &&
        assignedFulfillment == other.assignedFulfillment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, salesValue.hashCode);
    _$hash = $jc(_$hash, performance.hashCode);
    _$hash = $jc(_$hash, stock.hashCode);
    _$hash = $jc(_$hash, disputes.hashCode);
    _$hash = $jc(_$hash, assignedFulfillment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardInsightsAccess')
          ..add('orders', orders)
          ..add('salesValue', salesValue)
          ..add('performance', performance)
          ..add('stock', stock)
          ..add('disputes', disputes)
          ..add('assignedFulfillment', assignedFulfillment))
        .toString();
  }
}

class VendorDashboardInsightsAccessBuilder
    implements
        Builder<VendorDashboardInsightsAccess,
            VendorDashboardInsightsAccessBuilder> {
  _$VendorDashboardInsightsAccess? _$v;

  bool? _orders;
  bool? get orders => _$this._orders;
  set orders(bool? orders) => _$this._orders = orders;

  bool? _salesValue;
  bool? get salesValue => _$this._salesValue;
  set salesValue(bool? salesValue) => _$this._salesValue = salesValue;

  bool? _performance;
  bool? get performance => _$this._performance;
  set performance(bool? performance) => _$this._performance = performance;

  bool? _stock;
  bool? get stock => _$this._stock;
  set stock(bool? stock) => _$this._stock = stock;

  bool? _disputes;
  bool? get disputes => _$this._disputes;
  set disputes(bool? disputes) => _$this._disputes = disputes;

  bool? _assignedFulfillment;
  bool? get assignedFulfillment => _$this._assignedFulfillment;
  set assignedFulfillment(bool? assignedFulfillment) =>
      _$this._assignedFulfillment = assignedFulfillment;

  VendorDashboardInsightsAccessBuilder() {
    VendorDashboardInsightsAccess._defaults(this);
  }

  VendorDashboardInsightsAccessBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orders = $v.orders;
      _salesValue = $v.salesValue;
      _performance = $v.performance;
      _stock = $v.stock;
      _disputes = $v.disputes;
      _assignedFulfillment = $v.assignedFulfillment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardInsightsAccess other) {
    _$v = other as _$VendorDashboardInsightsAccess;
  }

  @override
  void update(void Function(VendorDashboardInsightsAccessBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardInsightsAccess build() => _build();

  _$VendorDashboardInsightsAccess _build() {
    final _$result = _$v ??
        _$VendorDashboardInsightsAccess._(
          orders: BuiltValueNullFieldError.checkNotNull(
              orders, r'VendorDashboardInsightsAccess', 'orders'),
          salesValue: BuiltValueNullFieldError.checkNotNull(
              salesValue, r'VendorDashboardInsightsAccess', 'salesValue'),
          performance: BuiltValueNullFieldError.checkNotNull(
              performance, r'VendorDashboardInsightsAccess', 'performance'),
          stock: BuiltValueNullFieldError.checkNotNull(
              stock, r'VendorDashboardInsightsAccess', 'stock'),
          disputes: BuiltValueNullFieldError.checkNotNull(
              disputes, r'VendorDashboardInsightsAccess', 'disputes'),
          assignedFulfillment: BuiltValueNullFieldError.checkNotNull(
              assignedFulfillment,
              r'VendorDashboardInsightsAccess',
              'assignedFulfillment'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
