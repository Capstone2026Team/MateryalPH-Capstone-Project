// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_dashboard.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoDashboard extends GeoDashboard {
  @override
  final GeoScope scope;
  @override
  final GeoDataset dataset;
  @override
  final GeoDashboardPeriod period;
  @override
  final BuiltMap<String, JsonObject?> filters;
  @override
  final BuiltList<GeoFilterApplicability> filterApplicability;
  @override
  final GeoDashboardDisclosure disclosure;
  @override
  final GeoKpis kpis;
  @override
  final BuiltList<GeoTrendPoint> trends;
  @override
  final BuiltList<GeoActivityPoint> activityTrend;
  @override
  final BuiltList<GeoChild> children;
  @override
  final GeoDashboardUnresolved unresolved;
  @override
  final BuiltMap<String, String> definitions;

  factory _$GeoDashboard([void Function(GeoDashboardBuilder)? updates]) =>
      (GeoDashboardBuilder()..update(updates))._build();

  _$GeoDashboard._(
      {required this.scope,
      required this.dataset,
      required this.period,
      required this.filters,
      required this.filterApplicability,
      required this.disclosure,
      required this.kpis,
      required this.trends,
      required this.activityTrend,
      required this.children,
      required this.unresolved,
      required this.definitions})
      : super._();
  @override
  GeoDashboard rebuild(void Function(GeoDashboardBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoDashboardBuilder toBuilder() => GeoDashboardBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoDashboard &&
        scope == other.scope &&
        dataset == other.dataset &&
        period == other.period &&
        filters == other.filters &&
        filterApplicability == other.filterApplicability &&
        disclosure == other.disclosure &&
        kpis == other.kpis &&
        trends == other.trends &&
        activityTrend == other.activityTrend &&
        children == other.children &&
        unresolved == other.unresolved &&
        definitions == other.definitions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, dataset.hashCode);
    _$hash = $jc(_$hash, period.hashCode);
    _$hash = $jc(_$hash, filters.hashCode);
    _$hash = $jc(_$hash, filterApplicability.hashCode);
    _$hash = $jc(_$hash, disclosure.hashCode);
    _$hash = $jc(_$hash, kpis.hashCode);
    _$hash = $jc(_$hash, trends.hashCode);
    _$hash = $jc(_$hash, activityTrend.hashCode);
    _$hash = $jc(_$hash, children.hashCode);
    _$hash = $jc(_$hash, unresolved.hashCode);
    _$hash = $jc(_$hash, definitions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoDashboard')
          ..add('scope', scope)
          ..add('dataset', dataset)
          ..add('period', period)
          ..add('filters', filters)
          ..add('filterApplicability', filterApplicability)
          ..add('disclosure', disclosure)
          ..add('kpis', kpis)
          ..add('trends', trends)
          ..add('activityTrend', activityTrend)
          ..add('children', children)
          ..add('unresolved', unresolved)
          ..add('definitions', definitions))
        .toString();
  }
}

class GeoDashboardBuilder
    implements Builder<GeoDashboard, GeoDashboardBuilder> {
  _$GeoDashboard? _$v;

  GeoScopeBuilder? _scope;
  GeoScopeBuilder get scope => _$this._scope ??= GeoScopeBuilder();
  set scope(GeoScopeBuilder? scope) => _$this._scope = scope;

  GeoDatasetBuilder? _dataset;
  GeoDatasetBuilder get dataset => _$this._dataset ??= GeoDatasetBuilder();
  set dataset(GeoDatasetBuilder? dataset) => _$this._dataset = dataset;

  GeoDashboardPeriodBuilder? _period;
  GeoDashboardPeriodBuilder get period =>
      _$this._period ??= GeoDashboardPeriodBuilder();
  set period(GeoDashboardPeriodBuilder? period) => _$this._period = period;

  MapBuilder<String, JsonObject?>? _filters;
  MapBuilder<String, JsonObject?> get filters =>
      _$this._filters ??= MapBuilder<String, JsonObject?>();
  set filters(MapBuilder<String, JsonObject?>? filters) =>
      _$this._filters = filters;

  ListBuilder<GeoFilterApplicability>? _filterApplicability;
  ListBuilder<GeoFilterApplicability> get filterApplicability =>
      _$this._filterApplicability ??= ListBuilder<GeoFilterApplicability>();
  set filterApplicability(
          ListBuilder<GeoFilterApplicability>? filterApplicability) =>
      _$this._filterApplicability = filterApplicability;

  GeoDashboardDisclosureBuilder? _disclosure;
  GeoDashboardDisclosureBuilder get disclosure =>
      _$this._disclosure ??= GeoDashboardDisclosureBuilder();
  set disclosure(GeoDashboardDisclosureBuilder? disclosure) =>
      _$this._disclosure = disclosure;

  GeoKpisBuilder? _kpis;
  GeoKpisBuilder get kpis => _$this._kpis ??= GeoKpisBuilder();
  set kpis(GeoKpisBuilder? kpis) => _$this._kpis = kpis;

  ListBuilder<GeoTrendPoint>? _trends;
  ListBuilder<GeoTrendPoint> get trends =>
      _$this._trends ??= ListBuilder<GeoTrendPoint>();
  set trends(ListBuilder<GeoTrendPoint>? trends) => _$this._trends = trends;

  ListBuilder<GeoActivityPoint>? _activityTrend;
  ListBuilder<GeoActivityPoint> get activityTrend =>
      _$this._activityTrend ??= ListBuilder<GeoActivityPoint>();
  set activityTrend(ListBuilder<GeoActivityPoint>? activityTrend) =>
      _$this._activityTrend = activityTrend;

  ListBuilder<GeoChild>? _children;
  ListBuilder<GeoChild> get children =>
      _$this._children ??= ListBuilder<GeoChild>();
  set children(ListBuilder<GeoChild>? children) => _$this._children = children;

  GeoDashboardUnresolvedBuilder? _unresolved;
  GeoDashboardUnresolvedBuilder get unresolved =>
      _$this._unresolved ??= GeoDashboardUnresolvedBuilder();
  set unresolved(GeoDashboardUnresolvedBuilder? unresolved) =>
      _$this._unresolved = unresolved;

  MapBuilder<String, String>? _definitions;
  MapBuilder<String, String> get definitions =>
      _$this._definitions ??= MapBuilder<String, String>();
  set definitions(MapBuilder<String, String>? definitions) =>
      _$this._definitions = definitions;

  GeoDashboardBuilder() {
    GeoDashboard._defaults(this);
  }

  GeoDashboardBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _scope = $v.scope.toBuilder();
      _dataset = $v.dataset.toBuilder();
      _period = $v.period.toBuilder();
      _filters = $v.filters.toBuilder();
      _filterApplicability = $v.filterApplicability.toBuilder();
      _disclosure = $v.disclosure.toBuilder();
      _kpis = $v.kpis.toBuilder();
      _trends = $v.trends.toBuilder();
      _activityTrend = $v.activityTrend.toBuilder();
      _children = $v.children.toBuilder();
      _unresolved = $v.unresolved.toBuilder();
      _definitions = $v.definitions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoDashboard other) {
    _$v = other as _$GeoDashboard;
  }

  @override
  void update(void Function(GeoDashboardBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoDashboard build() => _build();

  _$GeoDashboard _build() {
    _$GeoDashboard _$result;
    try {
      _$result = _$v ??
          _$GeoDashboard._(
            scope: scope.build(),
            dataset: dataset.build(),
            period: period.build(),
            filters: filters.build(),
            filterApplicability: filterApplicability.build(),
            disclosure: disclosure.build(),
            kpis: kpis.build(),
            trends: trends.build(),
            activityTrend: activityTrend.build(),
            children: children.build(),
            unresolved: unresolved.build(),
            definitions: definitions.build(),
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
        _$failedField = 'filters';
        filters.build();
        _$failedField = 'filterApplicability';
        filterApplicability.build();
        _$failedField = 'disclosure';
        disclosure.build();
        _$failedField = 'kpis';
        kpis.build();
        _$failedField = 'trends';
        trends.build();
        _$failedField = 'activityTrend';
        activityTrend.build();
        _$failedField = 'children';
        children.build();
        _$failedField = 'unresolved';
        unresolved.build();
        _$failedField = 'definitions';
        definitions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GeoDashboard', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
