// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_analytics.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorProductAnalytics extends VendorProductAnalytics {
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
  final VendorProductAnalyticsKpis kpis;
  @override
  final BuiltList<ProductAnalyticsSeriesPoint> series;
  @override
  final VendorProductAnalyticsForecast forecast;
  @override
  final BuiltList<ProductAnalyticsRow> topSelling;
  @override
  final BuiltList<ProductAnalyticsRow> topPerforming;
  @override
  final BuiltList<ProductAnalyticsRow> mostViewed;
  @override
  final BuiltList<VendorProductAnalyticsCategoriesInner> categories;
  @override
  final ProductAnalyticsSegments segments;
  @override
  final VendorProductAnalyticsBasketRules basketRules;
  @override
  final BuiltList<ProductAnalyticsSuggestion> suggestions;
  @override
  final VendorProductAnalyticsProducts products;

  factory _$VendorProductAnalytics(
          [void Function(VendorProductAnalyticsBuilder)? updates]) =>
      (VendorProductAnalyticsBuilder()..update(updates))._build();

  _$VendorProductAnalytics._(
      {required this.generatedAt,
      required this.period,
      required this.access,
      required this.definitions,
      required this.tracking,
      required this.kpis,
      required this.series,
      required this.forecast,
      required this.topSelling,
      required this.topPerforming,
      required this.mostViewed,
      required this.categories,
      required this.segments,
      required this.basketRules,
      required this.suggestions,
      required this.products})
      : super._();
  @override
  VendorProductAnalytics rebuild(
          void Function(VendorProductAnalyticsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductAnalyticsBuilder toBuilder() =>
      VendorProductAnalyticsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductAnalytics &&
        generatedAt == other.generatedAt &&
        period == other.period &&
        access == other.access &&
        definitions == other.definitions &&
        tracking == other.tracking &&
        kpis == other.kpis &&
        series == other.series &&
        forecast == other.forecast &&
        topSelling == other.topSelling &&
        topPerforming == other.topPerforming &&
        mostViewed == other.mostViewed &&
        categories == other.categories &&
        segments == other.segments &&
        basketRules == other.basketRules &&
        suggestions == other.suggestions &&
        products == other.products;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, generatedAt.hashCode);
    _$hash = $jc(_$hash, period.hashCode);
    _$hash = $jc(_$hash, access.hashCode);
    _$hash = $jc(_$hash, definitions.hashCode);
    _$hash = $jc(_$hash, tracking.hashCode);
    _$hash = $jc(_$hash, kpis.hashCode);
    _$hash = $jc(_$hash, series.hashCode);
    _$hash = $jc(_$hash, forecast.hashCode);
    _$hash = $jc(_$hash, topSelling.hashCode);
    _$hash = $jc(_$hash, topPerforming.hashCode);
    _$hash = $jc(_$hash, mostViewed.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, segments.hashCode);
    _$hash = $jc(_$hash, basketRules.hashCode);
    _$hash = $jc(_$hash, suggestions.hashCode);
    _$hash = $jc(_$hash, products.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorProductAnalytics')
          ..add('generatedAt', generatedAt)
          ..add('period', period)
          ..add('access', access)
          ..add('definitions', definitions)
          ..add('tracking', tracking)
          ..add('kpis', kpis)
          ..add('series', series)
          ..add('forecast', forecast)
          ..add('topSelling', topSelling)
          ..add('topPerforming', topPerforming)
          ..add('mostViewed', mostViewed)
          ..add('categories', categories)
          ..add('segments', segments)
          ..add('basketRules', basketRules)
          ..add('suggestions', suggestions)
          ..add('products', products))
        .toString();
  }
}

class VendorProductAnalyticsBuilder
    implements Builder<VendorProductAnalytics, VendorProductAnalyticsBuilder> {
  _$VendorProductAnalytics? _$v;

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

  VendorProductAnalyticsKpisBuilder? _kpis;
  VendorProductAnalyticsKpisBuilder get kpis =>
      _$this._kpis ??= VendorProductAnalyticsKpisBuilder();
  set kpis(VendorProductAnalyticsKpisBuilder? kpis) => _$this._kpis = kpis;

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

  ListBuilder<ProductAnalyticsRow>? _topSelling;
  ListBuilder<ProductAnalyticsRow> get topSelling =>
      _$this._topSelling ??= ListBuilder<ProductAnalyticsRow>();
  set topSelling(ListBuilder<ProductAnalyticsRow>? topSelling) =>
      _$this._topSelling = topSelling;

  ListBuilder<ProductAnalyticsRow>? _topPerforming;
  ListBuilder<ProductAnalyticsRow> get topPerforming =>
      _$this._topPerforming ??= ListBuilder<ProductAnalyticsRow>();
  set topPerforming(ListBuilder<ProductAnalyticsRow>? topPerforming) =>
      _$this._topPerforming = topPerforming;

  ListBuilder<ProductAnalyticsRow>? _mostViewed;
  ListBuilder<ProductAnalyticsRow> get mostViewed =>
      _$this._mostViewed ??= ListBuilder<ProductAnalyticsRow>();
  set mostViewed(ListBuilder<ProductAnalyticsRow>? mostViewed) =>
      _$this._mostViewed = mostViewed;

  ListBuilder<VendorProductAnalyticsCategoriesInner>? _categories;
  ListBuilder<VendorProductAnalyticsCategoriesInner> get categories =>
      _$this._categories ??=
          ListBuilder<VendorProductAnalyticsCategoriesInner>();
  set categories(
          ListBuilder<VendorProductAnalyticsCategoriesInner>? categories) =>
      _$this._categories = categories;

  ProductAnalyticsSegmentsBuilder? _segments;
  ProductAnalyticsSegmentsBuilder get segments =>
      _$this._segments ??= ProductAnalyticsSegmentsBuilder();
  set segments(ProductAnalyticsSegmentsBuilder? segments) =>
      _$this._segments = segments;

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

  VendorProductAnalyticsProductsBuilder? _products;
  VendorProductAnalyticsProductsBuilder get products =>
      _$this._products ??= VendorProductAnalyticsProductsBuilder();
  set products(VendorProductAnalyticsProductsBuilder? products) =>
      _$this._products = products;

  VendorProductAnalyticsBuilder() {
    VendorProductAnalytics._defaults(this);
  }

  VendorProductAnalyticsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _generatedAt = $v.generatedAt;
      _period = $v.period.toBuilder();
      _access = $v.access.toBuilder();
      _definitions = $v.definitions.toBuilder();
      _tracking = $v.tracking.toBuilder();
      _kpis = $v.kpis.toBuilder();
      _series = $v.series.toBuilder();
      _forecast = $v.forecast.toBuilder();
      _topSelling = $v.topSelling.toBuilder();
      _topPerforming = $v.topPerforming.toBuilder();
      _mostViewed = $v.mostViewed.toBuilder();
      _categories = $v.categories.toBuilder();
      _segments = $v.segments.toBuilder();
      _basketRules = $v.basketRules.toBuilder();
      _suggestions = $v.suggestions.toBuilder();
      _products = $v.products.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorProductAnalytics other) {
    _$v = other as _$VendorProductAnalytics;
  }

  @override
  void update(void Function(VendorProductAnalyticsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductAnalytics build() => _build();

  _$VendorProductAnalytics _build() {
    _$VendorProductAnalytics _$result;
    try {
      _$result = _$v ??
          _$VendorProductAnalytics._(
            generatedAt: BuiltValueNullFieldError.checkNotNull(
                generatedAt, r'VendorProductAnalytics', 'generatedAt'),
            period: period.build(),
            access: access.build(),
            definitions: definitions.build(),
            tracking: tracking.build(),
            kpis: kpis.build(),
            series: series.build(),
            forecast: forecast.build(),
            topSelling: topSelling.build(),
            topPerforming: topPerforming.build(),
            mostViewed: mostViewed.build(),
            categories: categories.build(),
            segments: segments.build(),
            basketRules: basketRules.build(),
            suggestions: suggestions.build(),
            products: products.build(),
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
        _$failedField = 'kpis';
        kpis.build();
        _$failedField = 'series';
        series.build();
        _$failedField = 'forecast';
        forecast.build();
        _$failedField = 'topSelling';
        topSelling.build();
        _$failedField = 'topPerforming';
        topPerforming.build();
        _$failedField = 'mostViewed';
        mostViewed.build();
        _$failedField = 'categories';
        categories.build();
        _$failedField = 'segments';
        segments.build();
        _$failedField = 'basketRules';
        basketRules.build();
        _$failedField = 'suggestions';
        suggestions.build();
        _$failedField = 'products';
        products.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorProductAnalytics', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
