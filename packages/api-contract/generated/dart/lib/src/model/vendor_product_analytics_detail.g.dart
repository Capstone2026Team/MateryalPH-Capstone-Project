// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_analytics_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorProductAnalyticsDetail extends VendorProductAnalyticsDetail {
  @override
  final DateTime generatedAt;
  @override
  final ProductAnalyticsPeriod period;
  @override
  final VendorProductAnalyticsAccess access;
  @override
  final BuiltMap<String, String> definitions;
  @override
  final ProductAnalyticsTracking tracking;
  @override
  final ProductAnalyticsRow product;
  @override
  final VendorProductAnalyticsDetailKpis kpis;
  @override
  final BuiltList<ProductAnalyticsSeriesPoint> series;
  @override
  final VendorProductAnalyticsForecast forecast;
  @override
  final VendorProductAnalyticsDetailUnusualDays unusualDays;
  @override
  final VendorProductAnalyticsBasketRules basketRules;
  @override
  final BuiltList<ProductAnalyticsSuggestion> suggestions;

  factory _$VendorProductAnalyticsDetail(
          [void Function(VendorProductAnalyticsDetailBuilder)? updates]) =>
      (VendorProductAnalyticsDetailBuilder()..update(updates))._build();

  _$VendorProductAnalyticsDetail._(
      {required this.generatedAt,
      required this.period,
      required this.access,
      required this.definitions,
      required this.tracking,
      required this.product,
      required this.kpis,
      required this.series,
      required this.forecast,
      required this.unusualDays,
      required this.basketRules,
      required this.suggestions})
      : super._();
  @override
  VendorProductAnalyticsDetail rebuild(
          void Function(VendorProductAnalyticsDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductAnalyticsDetailBuilder toBuilder() =>
      VendorProductAnalyticsDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductAnalyticsDetail &&
        generatedAt == other.generatedAt &&
        period == other.period &&
        access == other.access &&
        definitions == other.definitions &&
        tracking == other.tracking &&
        product == other.product &&
        kpis == other.kpis &&
        series == other.series &&
        forecast == other.forecast &&
        unusualDays == other.unusualDays &&
        basketRules == other.basketRules &&
        suggestions == other.suggestions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, generatedAt.hashCode);
    _$hash = $jc(_$hash, period.hashCode);
    _$hash = $jc(_$hash, access.hashCode);
    _$hash = $jc(_$hash, definitions.hashCode);
    _$hash = $jc(_$hash, tracking.hashCode);
    _$hash = $jc(_$hash, product.hashCode);
    _$hash = $jc(_$hash, kpis.hashCode);
    _$hash = $jc(_$hash, series.hashCode);
    _$hash = $jc(_$hash, forecast.hashCode);
    _$hash = $jc(_$hash, unusualDays.hashCode);
    _$hash = $jc(_$hash, basketRules.hashCode);
    _$hash = $jc(_$hash, suggestions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorProductAnalyticsDetail')
          ..add('generatedAt', generatedAt)
          ..add('period', period)
          ..add('access', access)
          ..add('definitions', definitions)
          ..add('tracking', tracking)
          ..add('product', product)
          ..add('kpis', kpis)
          ..add('series', series)
          ..add('forecast', forecast)
          ..add('unusualDays', unusualDays)
          ..add('basketRules', basketRules)
          ..add('suggestions', suggestions))
        .toString();
  }
}

class VendorProductAnalyticsDetailBuilder
    implements
        Builder<VendorProductAnalyticsDetail,
            VendorProductAnalyticsDetailBuilder> {
  _$VendorProductAnalyticsDetail? _$v;

  DateTime? _generatedAt;
  DateTime? get generatedAt => _$this._generatedAt;
  set generatedAt(DateTime? generatedAt) => _$this._generatedAt = generatedAt;

  ProductAnalyticsPeriodBuilder? _period;
  ProductAnalyticsPeriodBuilder get period =>
      _$this._period ??= ProductAnalyticsPeriodBuilder();
  set period(ProductAnalyticsPeriodBuilder? period) => _$this._period = period;

  VendorProductAnalyticsAccessBuilder? _access;
  VendorProductAnalyticsAccessBuilder get access =>
      _$this._access ??= VendorProductAnalyticsAccessBuilder();
  set access(VendorProductAnalyticsAccessBuilder? access) =>
      _$this._access = access;

  MapBuilder<String, String>? _definitions;
  MapBuilder<String, String> get definitions =>
      _$this._definitions ??= MapBuilder<String, String>();
  set definitions(MapBuilder<String, String>? definitions) =>
      _$this._definitions = definitions;

  ProductAnalyticsTrackingBuilder? _tracking;
  ProductAnalyticsTrackingBuilder get tracking =>
      _$this._tracking ??= ProductAnalyticsTrackingBuilder();
  set tracking(ProductAnalyticsTrackingBuilder? tracking) =>
      _$this._tracking = tracking;

  ProductAnalyticsRowBuilder? _product;
  ProductAnalyticsRowBuilder get product =>
      _$this._product ??= ProductAnalyticsRowBuilder();
  set product(ProductAnalyticsRowBuilder? product) => _$this._product = product;

  VendorProductAnalyticsDetailKpisBuilder? _kpis;
  VendorProductAnalyticsDetailKpisBuilder get kpis =>
      _$this._kpis ??= VendorProductAnalyticsDetailKpisBuilder();
  set kpis(VendorProductAnalyticsDetailKpisBuilder? kpis) =>
      _$this._kpis = kpis;

  ListBuilder<ProductAnalyticsSeriesPoint>? _series;
  ListBuilder<ProductAnalyticsSeriesPoint> get series =>
      _$this._series ??= ListBuilder<ProductAnalyticsSeriesPoint>();
  set series(ListBuilder<ProductAnalyticsSeriesPoint>? series) =>
      _$this._series = series;

  VendorProductAnalyticsForecastBuilder? _forecast;
  VendorProductAnalyticsForecastBuilder get forecast =>
      _$this._forecast ??= VendorProductAnalyticsForecastBuilder();
  set forecast(VendorProductAnalyticsForecastBuilder? forecast) =>
      _$this._forecast = forecast;

  VendorProductAnalyticsDetailUnusualDaysBuilder? _unusualDays;
  VendorProductAnalyticsDetailUnusualDaysBuilder get unusualDays =>
      _$this._unusualDays ??= VendorProductAnalyticsDetailUnusualDaysBuilder();
  set unusualDays(
          VendorProductAnalyticsDetailUnusualDaysBuilder? unusualDays) =>
      _$this._unusualDays = unusualDays;

  VendorProductAnalyticsBasketRulesBuilder? _basketRules;
  VendorProductAnalyticsBasketRulesBuilder get basketRules =>
      _$this._basketRules ??= VendorProductAnalyticsBasketRulesBuilder();
  set basketRules(VendorProductAnalyticsBasketRulesBuilder? basketRules) =>
      _$this._basketRules = basketRules;

  ListBuilder<ProductAnalyticsSuggestion>? _suggestions;
  ListBuilder<ProductAnalyticsSuggestion> get suggestions =>
      _$this._suggestions ??= ListBuilder<ProductAnalyticsSuggestion>();
  set suggestions(ListBuilder<ProductAnalyticsSuggestion>? suggestions) =>
      _$this._suggestions = suggestions;

  VendorProductAnalyticsDetailBuilder() {
    VendorProductAnalyticsDetail._defaults(this);
  }

  VendorProductAnalyticsDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _generatedAt = $v.generatedAt;
      _period = $v.period.toBuilder();
      _access = $v.access.toBuilder();
      _definitions = $v.definitions.toBuilder();
      _tracking = $v.tracking.toBuilder();
      _product = $v.product.toBuilder();
      _kpis = $v.kpis.toBuilder();
      _series = $v.series.toBuilder();
      _forecast = $v.forecast.toBuilder();
      _unusualDays = $v.unusualDays.toBuilder();
      _basketRules = $v.basketRules.toBuilder();
      _suggestions = $v.suggestions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorProductAnalyticsDetail other) {
    _$v = other as _$VendorProductAnalyticsDetail;
  }

  @override
  void update(void Function(VendorProductAnalyticsDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductAnalyticsDetail build() => _build();

  _$VendorProductAnalyticsDetail _build() {
    _$VendorProductAnalyticsDetail _$result;
    try {
      _$result = _$v ??
          _$VendorProductAnalyticsDetail._(
            generatedAt: BuiltValueNullFieldError.checkNotNull(
                generatedAt, r'VendorProductAnalyticsDetail', 'generatedAt'),
            period: period.build(),
            access: access.build(),
            definitions: definitions.build(),
            tracking: tracking.build(),
            product: product.build(),
            kpis: kpis.build(),
            series: series.build(),
            forecast: forecast.build(),
            unusualDays: unusualDays.build(),
            basketRules: basketRules.build(),
            suggestions: suggestions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'period';
        period.build();
        _$failedField = 'access';
        access.build();
        _$failedField = 'definitions';
        definitions.build();
        _$failedField = 'tracking';
        tracking.build();
        _$failedField = 'product';
        product.build();
        _$failedField = 'kpis';
        kpis.build();
        _$failedField = 'series';
        series.build();
        _$failedField = 'forecast';
        forecast.build();
        _$failedField = 'unusualDays';
        unusualDays.build();
        _$failedField = 'basketRules';
        basketRules.build();
        _$failedField = 'suggestions';
        suggestions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorProductAnalyticsDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
