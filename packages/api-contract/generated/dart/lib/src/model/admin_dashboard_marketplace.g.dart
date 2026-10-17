// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_marketplace.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardMarketplace extends AdminDashboardMarketplace {
  @override
  final GeoScope scope;
  @override
  final GeoDataset dataset;
  @override
  final AdminDashboardMarketplacePeriod period;
  @override
  final AdminDashboardMarketplaceDisclosure disclosure;
  @override
  final GeoKpis kpis;
  @override
  final BuiltList<AdminDashboardSeriesPoint> series;
  @override
  final AdminDashboardMarketplaceForecast forecast;
  @override
  final BuiltList<AdminDashboardActivityPoint> activity;
  @override
  final AdminDashboardAreas areas;
  @override
  final AdminDashboardCategories categories;

  factory _$AdminDashboardMarketplace(
          [void Function(AdminDashboardMarketplaceBuilder)? updates]) =>
      (AdminDashboardMarketplaceBuilder()..update(updates))._build();

  _$AdminDashboardMarketplace._(
      {required this.scope,
      required this.dataset,
      required this.period,
      required this.disclosure,
      required this.kpis,
      required this.series,
      required this.forecast,
      required this.activity,
      required this.areas,
      required this.categories})
      : super._();
  @override
  AdminDashboardMarketplace rebuild(
          void Function(AdminDashboardMarketplaceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardMarketplaceBuilder toBuilder() =>
      AdminDashboardMarketplaceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardMarketplace &&
        scope == other.scope &&
        dataset == other.dataset &&
        period == other.period &&
        disclosure == other.disclosure &&
        kpis == other.kpis &&
        series == other.series &&
        forecast == other.forecast &&
        activity == other.activity &&
        areas == other.areas &&
        categories == other.categories;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, dataset.hashCode);
    _$hash = $jc(_$hash, period.hashCode);
    _$hash = $jc(_$hash, disclosure.hashCode);
    _$hash = $jc(_$hash, kpis.hashCode);
    _$hash = $jc(_$hash, series.hashCode);
    _$hash = $jc(_$hash, forecast.hashCode);
    _$hash = $jc(_$hash, activity.hashCode);
    _$hash = $jc(_$hash, areas.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardMarketplace')
          ..add('scope', scope)
          ..add('dataset', dataset)
          ..add('period', period)
          ..add('disclosure', disclosure)
          ..add('kpis', kpis)
          ..add('series', series)
          ..add('forecast', forecast)
          ..add('activity', activity)
          ..add('areas', areas)
          ..add('categories', categories))
        .toString();
  }
}

class AdminDashboardMarketplaceBuilder
    implements
        Builder<AdminDashboardMarketplace, AdminDashboardMarketplaceBuilder> {
  _$AdminDashboardMarketplace? _$v;

  GeoScopeBuilder? _scope;
  GeoScopeBuilder get scope => _$this._scope ??= GeoScopeBuilder();
  set scope(GeoScopeBuilder? scope) => _$this._scope = scope;

  GeoDatasetBuilder? _dataset;
  GeoDatasetBuilder get dataset => _$this._dataset ??= GeoDatasetBuilder();
  set dataset(GeoDatasetBuilder? dataset) => _$this._dataset = dataset;

  AdminDashboardMarketplacePeriodBuilder? _period;
  AdminDashboardMarketplacePeriodBuilder get period =>
      _$this._period ??= AdminDashboardMarketplacePeriodBuilder();
  set period(AdminDashboardMarketplacePeriodBuilder? period) =>
      _$this._period = period;

  AdminDashboardMarketplaceDisclosureBuilder? _disclosure;
  AdminDashboardMarketplaceDisclosureBuilder get disclosure =>
      _$this._disclosure ??= AdminDashboardMarketplaceDisclosureBuilder();
  set disclosure(AdminDashboardMarketplaceDisclosureBuilder? disclosure) =>
      _$this._disclosure = disclosure;

  GeoKpisBuilder? _kpis;
  GeoKpisBuilder get kpis => _$this._kpis ??= GeoKpisBuilder();
  set kpis(GeoKpisBuilder? kpis) => _$this._kpis = kpis;

  ListBuilder<AdminDashboardSeriesPoint>? _series;
  ListBuilder<AdminDashboardSeriesPoint> get series =>
      _$this._series ??= ListBuilder<AdminDashboardSeriesPoint>();
  set series(ListBuilder<AdminDashboardSeriesPoint>? series) =>
      _$this._series = series;

  AdminDashboardMarketplaceForecastBuilder? _forecast;
  AdminDashboardMarketplaceForecastBuilder get forecast =>
      _$this._forecast ??= AdminDashboardMarketplaceForecastBuilder();
  set forecast(AdminDashboardMarketplaceForecastBuilder? forecast) =>
      _$this._forecast = forecast;

  ListBuilder<AdminDashboardActivityPoint>? _activity;
  ListBuilder<AdminDashboardActivityPoint> get activity =>
      _$this._activity ??= ListBuilder<AdminDashboardActivityPoint>();
  set activity(ListBuilder<AdminDashboardActivityPoint>? activity) =>
      _$this._activity = activity;

  AdminDashboardAreasBuilder? _areas;
  AdminDashboardAreasBuilder get areas =>
      _$this._areas ??= AdminDashboardAreasBuilder();
  set areas(AdminDashboardAreasBuilder? areas) => _$this._areas = areas;

  AdminDashboardCategoriesBuilder? _categories;
  AdminDashboardCategoriesBuilder get categories =>
      _$this._categories ??= AdminDashboardCategoriesBuilder();
  set categories(AdminDashboardCategoriesBuilder? categories) =>
      _$this._categories = categories;

  AdminDashboardMarketplaceBuilder() {
    AdminDashboardMarketplace._defaults(this);
  }

  AdminDashboardMarketplaceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _scope = $v.scope.toBuilder();
      _dataset = $v.dataset.toBuilder();
      _period = $v.period.toBuilder();
      _disclosure = $v.disclosure.toBuilder();
      _kpis = $v.kpis.toBuilder();
      _series = $v.series.toBuilder();
      _forecast = $v.forecast.toBuilder();
      _activity = $v.activity.toBuilder();
      _areas = $v.areas.toBuilder();
      _categories = $v.categories.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardMarketplace other) {
    _$v = other as _$AdminDashboardMarketplace;
  }

  @override
  void update(void Function(AdminDashboardMarketplaceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardMarketplace build() => _build();

  _$AdminDashboardMarketplace _build() {
    _$AdminDashboardMarketplace _$result;
    try {
      _$result = _$v ??
          _$AdminDashboardMarketplace._(
            scope: scope.build(),
            dataset: dataset.build(),
            period: period.build(),
            disclosure: disclosure.build(),
            kpis: kpis.build(),
            series: series.build(),
            forecast: forecast.build(),
            activity: activity.build(),
            areas: areas.build(),
            categories: categories.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scope';
        scope.build();
        _$failedField = 'dataset';
        dataset.build();
        _$failedField = 'period';
        period.build();
        _$failedField = 'disclosure';
        disclosure.build();
        _$failedField = 'kpis';
        kpis.build();
        _$failedField = 'series';
        series.build();
        _$failedField = 'forecast';
        forecast.build();
        _$failedField = 'activity';
        activity.build();
        _$failedField = 'areas';
        areas.build();
        _$failedField = 'categories';
        categories.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminDashboardMarketplace', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
