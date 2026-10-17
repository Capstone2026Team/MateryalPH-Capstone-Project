// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_orders_forecast.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardOrdersForecast extends VendorDashboardOrdersForecast {
  @override
  final int horizonDays;
  @override
  final DashboardForecast orders;
  @override
  final DashboardForecast? sales;

  factory _$VendorDashboardOrdersForecast(
          [void Function(VendorDashboardOrdersForecastBuilder)? updates]) =>
      (VendorDashboardOrdersForecastBuilder()..update(updates))._build();

  _$VendorDashboardOrdersForecast._(
      {required this.horizonDays, required this.orders, this.sales})
      : super._();
  @override
  VendorDashboardOrdersForecast rebuild(
          void Function(VendorDashboardOrdersForecastBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardOrdersForecastBuilder toBuilder() =>
      VendorDashboardOrdersForecastBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardOrdersForecast &&
        horizonDays == other.horizonDays &&
        orders == other.orders &&
        sales == other.sales;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, horizonDays.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, sales.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardOrdersForecast')
          ..add('horizonDays', horizonDays)
          ..add('orders', orders)
          ..add('sales', sales))
        .toString();
  }
}

class VendorDashboardOrdersForecastBuilder
    implements
        Builder<VendorDashboardOrdersForecast,
            VendorDashboardOrdersForecastBuilder> {
  _$VendorDashboardOrdersForecast? _$v;

  int? _horizonDays;
  int? get horizonDays => _$this._horizonDays;
  set horizonDays(int? horizonDays) => _$this._horizonDays = horizonDays;

  DashboardForecastBuilder? _orders;
  DashboardForecastBuilder get orders =>
      _$this._orders ??= DashboardForecastBuilder();
  set orders(DashboardForecastBuilder? orders) => _$this._orders = orders;

  DashboardForecastBuilder? _sales;
  DashboardForecastBuilder get sales =>
      _$this._sales ??= DashboardForecastBuilder();
  set sales(DashboardForecastBuilder? sales) => _$this._sales = sales;

  VendorDashboardOrdersForecastBuilder() {
    VendorDashboardOrdersForecast._defaults(this);
  }

  VendorDashboardOrdersForecastBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _horizonDays = $v.horizonDays;
      _orders = $v.orders.toBuilder();
      _sales = $v.sales?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardOrdersForecast other) {
    _$v = other as _$VendorDashboardOrdersForecast;
  }

  @override
  void update(void Function(VendorDashboardOrdersForecastBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardOrdersForecast build() => _build();

  _$VendorDashboardOrdersForecast _build() {
    _$VendorDashboardOrdersForecast _$result;
    try {
      _$result = _$v ??
          _$VendorDashboardOrdersForecast._(
            horizonDays: BuiltValueNullFieldError.checkNotNull(
                horizonDays, r'VendorDashboardOrdersForecast', 'horizonDays'),
            orders: orders.build(),
            sales: _sales?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orders';
        orders.build();
        _$failedField = 'sales';
        _sales?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorDashboardOrdersForecast', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
