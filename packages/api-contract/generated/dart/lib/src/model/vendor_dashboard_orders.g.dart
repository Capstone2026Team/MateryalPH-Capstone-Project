// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_orders.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardOrders extends VendorDashboardOrders {
  @override
  final VendorDashboardOrdersKpis kpis;
  @override
  final BuiltList<VendorDashboardSeriesPoint> series;
  @override
  final VendorDashboardOrdersForecast forecast;
  @override
  final BuiltList<VendorDashboardOrdersPipelineInner> pipeline;
  @override
  final BuiltList<VendorDashboardOrdersIncomingInner> incoming;
  @override
  final BuiltList<VendorDashboardOrdersFunnelInner> funnel;
  @override
  final VendorDashboardOrdersMix mix;
  @override
  final VendorDashboardOrdersProducts products;
  @override
  final VendorDashboardOrdersUnusualDays unusualDays;

  factory _$VendorDashboardOrders(
          [void Function(VendorDashboardOrdersBuilder)? updates]) =>
      (VendorDashboardOrdersBuilder()..update(updates))._build();

  _$VendorDashboardOrders._(
      {required this.kpis,
      required this.series,
      required this.forecast,
      required this.pipeline,
      required this.incoming,
      required this.funnel,
      required this.mix,
      required this.products,
      required this.unusualDays})
      : super._();
  @override
  VendorDashboardOrders rebuild(
          void Function(VendorDashboardOrdersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardOrdersBuilder toBuilder() =>
      VendorDashboardOrdersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardOrders &&
        kpis == other.kpis &&
        series == other.series &&
        forecast == other.forecast &&
        pipeline == other.pipeline &&
        incoming == other.incoming &&
        funnel == other.funnel &&
        mix == other.mix &&
        products == other.products &&
        unusualDays == other.unusualDays;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kpis.hashCode);
    _$hash = $jc(_$hash, series.hashCode);
    _$hash = $jc(_$hash, forecast.hashCode);
    _$hash = $jc(_$hash, pipeline.hashCode);
    _$hash = $jc(_$hash, incoming.hashCode);
    _$hash = $jc(_$hash, funnel.hashCode);
    _$hash = $jc(_$hash, mix.hashCode);
    _$hash = $jc(_$hash, products.hashCode);
    _$hash = $jc(_$hash, unusualDays.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardOrders')
          ..add('kpis', kpis)
          ..add('series', series)
          ..add('forecast', forecast)
          ..add('pipeline', pipeline)
          ..add('incoming', incoming)
          ..add('funnel', funnel)
          ..add('mix', mix)
          ..add('products', products)
          ..add('unusualDays', unusualDays))
        .toString();
  }
}

class VendorDashboardOrdersBuilder
    implements Builder<VendorDashboardOrders, VendorDashboardOrdersBuilder> {
  _$VendorDashboardOrders? _$v;

  VendorDashboardOrdersKpisBuilder? _kpis;
  VendorDashboardOrdersKpisBuilder get kpis =>
      _$this._kpis ??= VendorDashboardOrdersKpisBuilder();
  set kpis(VendorDashboardOrdersKpisBuilder? kpis) => _$this._kpis = kpis;

  ListBuilder<VendorDashboardSeriesPoint>? _series;
  ListBuilder<VendorDashboardSeriesPoint> get series =>
      _$this._series ??= ListBuilder<VendorDashboardSeriesPoint>();
  set series(ListBuilder<VendorDashboardSeriesPoint>? series) =>
      _$this._series = series;

  VendorDashboardOrdersForecastBuilder? _forecast;
  VendorDashboardOrdersForecastBuilder get forecast =>
      _$this._forecast ??= VendorDashboardOrdersForecastBuilder();
  set forecast(VendorDashboardOrdersForecastBuilder? forecast) =>
      _$this._forecast = forecast;

  ListBuilder<VendorDashboardOrdersPipelineInner>? _pipeline;
  ListBuilder<VendorDashboardOrdersPipelineInner> get pipeline =>
      _$this._pipeline ??= ListBuilder<VendorDashboardOrdersPipelineInner>();
  set pipeline(ListBuilder<VendorDashboardOrdersPipelineInner>? pipeline) =>
      _$this._pipeline = pipeline;

  ListBuilder<VendorDashboardOrdersIncomingInner>? _incoming;
  ListBuilder<VendorDashboardOrdersIncomingInner> get incoming =>
      _$this._incoming ??= ListBuilder<VendorDashboardOrdersIncomingInner>();
  set incoming(ListBuilder<VendorDashboardOrdersIncomingInner>? incoming) =>
      _$this._incoming = incoming;

  ListBuilder<VendorDashboardOrdersFunnelInner>? _funnel;
  ListBuilder<VendorDashboardOrdersFunnelInner> get funnel =>
      _$this._funnel ??= ListBuilder<VendorDashboardOrdersFunnelInner>();
  set funnel(ListBuilder<VendorDashboardOrdersFunnelInner>? funnel) =>
      _$this._funnel = funnel;

  VendorDashboardOrdersMixBuilder? _mix;
  VendorDashboardOrdersMixBuilder get mix =>
      _$this._mix ??= VendorDashboardOrdersMixBuilder();
  set mix(VendorDashboardOrdersMixBuilder? mix) => _$this._mix = mix;

  VendorDashboardOrdersProductsBuilder? _products;
  VendorDashboardOrdersProductsBuilder get products =>
      _$this._products ??= VendorDashboardOrdersProductsBuilder();
  set products(VendorDashboardOrdersProductsBuilder? products) =>
      _$this._products = products;

  VendorDashboardOrdersUnusualDaysBuilder? _unusualDays;
  VendorDashboardOrdersUnusualDaysBuilder get unusualDays =>
      _$this._unusualDays ??= VendorDashboardOrdersUnusualDaysBuilder();
  set unusualDays(VendorDashboardOrdersUnusualDaysBuilder? unusualDays) =>
      _$this._unusualDays = unusualDays;

  VendorDashboardOrdersBuilder() {
    VendorDashboardOrders._defaults(this);
  }

  VendorDashboardOrdersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kpis = $v.kpis.toBuilder();
      _series = $v.series.toBuilder();
      _forecast = $v.forecast.toBuilder();
      _pipeline = $v.pipeline.toBuilder();
      _incoming = $v.incoming.toBuilder();
      _funnel = $v.funnel.toBuilder();
      _mix = $v.mix.toBuilder();
      _products = $v.products.toBuilder();
      _unusualDays = $v.unusualDays.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardOrders other) {
    _$v = other as _$VendorDashboardOrders;
  }

  @override
  void update(void Function(VendorDashboardOrdersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardOrders build() => _build();

  _$VendorDashboardOrders _build() {
    _$VendorDashboardOrders _$result;
    try {
      _$result = _$v ??
          _$VendorDashboardOrders._(
            kpis: kpis.build(),
            series: series.build(),
            forecast: forecast.build(),
            pipeline: pipeline.build(),
            incoming: incoming.build(),
            funnel: funnel.build(),
            mix: mix.build(),
            products: products.build(),
            unusualDays: unusualDays.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'kpis';
        kpis.build();
        _$failedField = 'series';
        series.build();
        _$failedField = 'forecast';
        forecast.build();
        _$failedField = 'pipeline';
        pipeline.build();
        _$failedField = 'incoming';
        incoming.build();
        _$failedField = 'funnel';
        funnel.build();
        _$failedField = 'mix';
        mix.build();
        _$failedField = 'products';
        products.build();
        _$failedField = 'unusualDays';
        unusualDays.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorDashboardOrders', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
