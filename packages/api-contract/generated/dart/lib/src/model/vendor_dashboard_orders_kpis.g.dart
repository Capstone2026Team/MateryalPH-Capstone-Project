// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_orders_kpis.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardOrdersKpis extends VendorDashboardOrdersKpis {
  @override
  final DashboardDelta orderVolume;
  @override
  final DashboardDelta? grossSalesCentavos;
  @override
  final DashboardDelta? netSalesCentavos;
  @override
  final VendorDashboardOrdersKpisAverageOrderValueCentavos?
      averageOrderValueCentavos;
  @override
  final DashboardRate fulfillmentRate;
  @override
  final DashboardRate cancellationRate;
  @override
  final DashboardRate disputeRate;
  @override
  final DashboardResponseTime responseTime;

  factory _$VendorDashboardOrdersKpis(
          [void Function(VendorDashboardOrdersKpisBuilder)? updates]) =>
      (VendorDashboardOrdersKpisBuilder()..update(updates))._build();

  _$VendorDashboardOrdersKpis._(
      {required this.orderVolume,
      this.grossSalesCentavos,
      this.netSalesCentavos,
      this.averageOrderValueCentavos,
      required this.fulfillmentRate,
      required this.cancellationRate,
      required this.disputeRate,
      required this.responseTime})
      : super._();
  @override
  VendorDashboardOrdersKpis rebuild(
          void Function(VendorDashboardOrdersKpisBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardOrdersKpisBuilder toBuilder() =>
      VendorDashboardOrdersKpisBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardOrdersKpis &&
        orderVolume == other.orderVolume &&
        grossSalesCentavos == other.grossSalesCentavos &&
        netSalesCentavos == other.netSalesCentavos &&
        averageOrderValueCentavos == other.averageOrderValueCentavos &&
        fulfillmentRate == other.fulfillmentRate &&
        cancellationRate == other.cancellationRate &&
        disputeRate == other.disputeRate &&
        responseTime == other.responseTime;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderVolume.hashCode);
    _$hash = $jc(_$hash, grossSalesCentavos.hashCode);
    _$hash = $jc(_$hash, netSalesCentavos.hashCode);
    _$hash = $jc(_$hash, averageOrderValueCentavos.hashCode);
    _$hash = $jc(_$hash, fulfillmentRate.hashCode);
    _$hash = $jc(_$hash, cancellationRate.hashCode);
    _$hash = $jc(_$hash, disputeRate.hashCode);
    _$hash = $jc(_$hash, responseTime.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardOrdersKpis')
          ..add('orderVolume', orderVolume)
          ..add('grossSalesCentavos', grossSalesCentavos)
          ..add('netSalesCentavos', netSalesCentavos)
          ..add('averageOrderValueCentavos', averageOrderValueCentavos)
          ..add('fulfillmentRate', fulfillmentRate)
          ..add('cancellationRate', cancellationRate)
          ..add('disputeRate', disputeRate)
          ..add('responseTime', responseTime))
        .toString();
  }
}

class VendorDashboardOrdersKpisBuilder
    implements
        Builder<VendorDashboardOrdersKpis, VendorDashboardOrdersKpisBuilder> {
  _$VendorDashboardOrdersKpis? _$v;

  DashboardDeltaBuilder? _orderVolume;
  DashboardDeltaBuilder get orderVolume =>
      _$this._orderVolume ??= DashboardDeltaBuilder();
  set orderVolume(DashboardDeltaBuilder? orderVolume) =>
      _$this._orderVolume = orderVolume;

  DashboardDeltaBuilder? _grossSalesCentavos;
  DashboardDeltaBuilder get grossSalesCentavos =>
      _$this._grossSalesCentavos ??= DashboardDeltaBuilder();
  set grossSalesCentavos(DashboardDeltaBuilder? grossSalesCentavos) =>
      _$this._grossSalesCentavos = grossSalesCentavos;

  DashboardDeltaBuilder? _netSalesCentavos;
  DashboardDeltaBuilder get netSalesCentavos =>
      _$this._netSalesCentavos ??= DashboardDeltaBuilder();
  set netSalesCentavos(DashboardDeltaBuilder? netSalesCentavos) =>
      _$this._netSalesCentavos = netSalesCentavos;

  VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder?
      _averageOrderValueCentavos;
  VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder
      get averageOrderValueCentavos => _$this._averageOrderValueCentavos ??=
          VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder();
  set averageOrderValueCentavos(
          VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder?
              averageOrderValueCentavos) =>
      _$this._averageOrderValueCentavos = averageOrderValueCentavos;

  DashboardRateBuilder? _fulfillmentRate;
  DashboardRateBuilder get fulfillmentRate =>
      _$this._fulfillmentRate ??= DashboardRateBuilder();
  set fulfillmentRate(DashboardRateBuilder? fulfillmentRate) =>
      _$this._fulfillmentRate = fulfillmentRate;

  DashboardRateBuilder? _cancellationRate;
  DashboardRateBuilder get cancellationRate =>
      _$this._cancellationRate ??= DashboardRateBuilder();
  set cancellationRate(DashboardRateBuilder? cancellationRate) =>
      _$this._cancellationRate = cancellationRate;

  DashboardRateBuilder? _disputeRate;
  DashboardRateBuilder get disputeRate =>
      _$this._disputeRate ??= DashboardRateBuilder();
  set disputeRate(DashboardRateBuilder? disputeRate) =>
      _$this._disputeRate = disputeRate;

  DashboardResponseTimeBuilder? _responseTime;
  DashboardResponseTimeBuilder get responseTime =>
      _$this._responseTime ??= DashboardResponseTimeBuilder();
  set responseTime(DashboardResponseTimeBuilder? responseTime) =>
      _$this._responseTime = responseTime;

  VendorDashboardOrdersKpisBuilder() {
    VendorDashboardOrdersKpis._defaults(this);
  }

  VendorDashboardOrdersKpisBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderVolume = $v.orderVolume.toBuilder();
      _grossSalesCentavos = $v.grossSalesCentavos?.toBuilder();
      _netSalesCentavos = $v.netSalesCentavos?.toBuilder();
      _averageOrderValueCentavos = $v.averageOrderValueCentavos?.toBuilder();
      _fulfillmentRate = $v.fulfillmentRate.toBuilder();
      _cancellationRate = $v.cancellationRate.toBuilder();
      _disputeRate = $v.disputeRate.toBuilder();
      _responseTime = $v.responseTime.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardOrdersKpis other) {
    _$v = other as _$VendorDashboardOrdersKpis;
  }

  @override
  void update(void Function(VendorDashboardOrdersKpisBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardOrdersKpis build() => _build();

  _$VendorDashboardOrdersKpis _build() {
    _$VendorDashboardOrdersKpis _$result;
    try {
      _$result = _$v ??
          _$VendorDashboardOrdersKpis._(
            orderVolume: orderVolume.build(),
            grossSalesCentavos: _grossSalesCentavos?.build(),
            netSalesCentavos: _netSalesCentavos?.build(),
            averageOrderValueCentavos: _averageOrderValueCentavos?.build(),
            fulfillmentRate: fulfillmentRate.build(),
            cancellationRate: cancellationRate.build(),
            disputeRate: disputeRate.build(),
            responseTime: responseTime.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orderVolume';
        orderVolume.build();
        _$failedField = 'grossSalesCentavos';
        _grossSalesCentavos?.build();
        _$failedField = 'netSalesCentavos';
        _netSalesCentavos?.build();
        _$failedField = 'averageOrderValueCentavos';
        _averageOrderValueCentavos?.build();
        _$failedField = 'fulfillmentRate';
        fulfillmentRate.build();
        _$failedField = 'cancellationRate';
        cancellationRate.build();
        _$failedField = 'disputeRate';
        disputeRate.build();
        _$failedField = 'responseTime';
        responseTime.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorDashboardOrdersKpis', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
