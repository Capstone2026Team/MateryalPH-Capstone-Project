// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ExploreSummaryCountScopeEnum
    _$exploreSummaryCountScopeEnum_ALL_CATEGORIES_AT_LOCATION_RADIUS =
    const ExploreSummaryCountScopeEnum._('ALL_CATEGORIES_AT_LOCATION_RADIUS');

ExploreSummaryCountScopeEnum _$exploreSummaryCountScopeEnumValueOf(
    String name) {
  switch (name) {
    case 'ALL_CATEGORIES_AT_LOCATION_RADIUS':
      return _$exploreSummaryCountScopeEnum_ALL_CATEGORIES_AT_LOCATION_RADIUS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ExploreSummaryCountScopeEnum>
    _$exploreSummaryCountScopeEnumValues =
    BuiltSet<ExploreSummaryCountScopeEnum>(const <ExploreSummaryCountScopeEnum>[
  _$exploreSummaryCountScopeEnum_ALL_CATEGORIES_AT_LOCATION_RADIUS,
]);

Serializer<ExploreSummaryCountScopeEnum>
    _$exploreSummaryCountScopeEnumSerializer =
    _$ExploreSummaryCountScopeEnumSerializer();

class _$ExploreSummaryCountScopeEnumSerializer
    implements PrimitiveSerializer<ExploreSummaryCountScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ALL_CATEGORIES_AT_LOCATION_RADIUS': 'ALL_CATEGORIES_AT_LOCATION_RADIUS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ALL_CATEGORIES_AT_LOCATION_RADIUS': 'ALL_CATEGORIES_AT_LOCATION_RADIUS',
  };

  @override
  final Iterable<Type> types = const <Type>[ExploreSummaryCountScopeEnum];
  @override
  final String wireName = 'ExploreSummaryCountScopeEnum';

  @override
  Object serialize(Serializers serializers, ExploreSummaryCountScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ExploreSummaryCountScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ExploreSummaryCountScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ExploreSummary extends ExploreSummary {
  @override
  final DiscoveryScope scope;
  @override
  final ExploreSummaryCountScopeEnum countScope;
  @override
  final String scopeLabel;
  @override
  final DateTime currentAsOf;
  @override
  final String eligibilityVersion;
  @override
  final ExploreCounts counts;
  @override
  final ExploreLabels labels;
  @override
  final BuiltList<ExploreCategoryCount> categories;
  @override
  final FeatureAvailability materialsAnalytics;
  @override
  final DatasetLabel dataset;

  factory _$ExploreSummary([void Function(ExploreSummaryBuilder)? updates]) =>
      (ExploreSummaryBuilder()..update(updates))._build();

  _$ExploreSummary._(
      {required this.scope,
      required this.countScope,
      required this.scopeLabel,
      required this.currentAsOf,
      required this.eligibilityVersion,
      required this.counts,
      required this.labels,
      required this.categories,
      required this.materialsAnalytics,
      required this.dataset})
      : super._();
  @override
  ExploreSummary rebuild(void Function(ExploreSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExploreSummaryBuilder toBuilder() => ExploreSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExploreSummary &&
        scope == other.scope &&
        countScope == other.countScope &&
        scopeLabel == other.scopeLabel &&
        currentAsOf == other.currentAsOf &&
        eligibilityVersion == other.eligibilityVersion &&
        counts == other.counts &&
        labels == other.labels &&
        categories == other.categories &&
        materialsAnalytics == other.materialsAnalytics &&
        dataset == other.dataset;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, countScope.hashCode);
    _$hash = $jc(_$hash, scopeLabel.hashCode);
    _$hash = $jc(_$hash, currentAsOf.hashCode);
    _$hash = $jc(_$hash, eligibilityVersion.hashCode);
    _$hash = $jc(_$hash, counts.hashCode);
    _$hash = $jc(_$hash, labels.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, materialsAnalytics.hashCode);
    _$hash = $jc(_$hash, dataset.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExploreSummary')
          ..add('scope', scope)
          ..add('countScope', countScope)
          ..add('scopeLabel', scopeLabel)
          ..add('currentAsOf', currentAsOf)
          ..add('eligibilityVersion', eligibilityVersion)
          ..add('counts', counts)
          ..add('labels', labels)
          ..add('categories', categories)
          ..add('materialsAnalytics', materialsAnalytics)
          ..add('dataset', dataset))
        .toString();
  }
}

class ExploreSummaryBuilder
    implements Builder<ExploreSummary, ExploreSummaryBuilder> {
  _$ExploreSummary? _$v;

  DiscoveryScopeBuilder? _scope;
  DiscoveryScopeBuilder get scope => _$this._scope ??= DiscoveryScopeBuilder();
  set scope(DiscoveryScopeBuilder? scope) => _$this._scope = scope;

  ExploreSummaryCountScopeEnum? _countScope;
  ExploreSummaryCountScopeEnum? get countScope => _$this._countScope;
  set countScope(ExploreSummaryCountScopeEnum? countScope) =>
      _$this._countScope = countScope;

  String? _scopeLabel;
  String? get scopeLabel => _$this._scopeLabel;
  set scopeLabel(String? scopeLabel) => _$this._scopeLabel = scopeLabel;

  DateTime? _currentAsOf;
  DateTime? get currentAsOf => _$this._currentAsOf;
  set currentAsOf(DateTime? currentAsOf) => _$this._currentAsOf = currentAsOf;

  String? _eligibilityVersion;
  String? get eligibilityVersion => _$this._eligibilityVersion;
  set eligibilityVersion(String? eligibilityVersion) =>
      _$this._eligibilityVersion = eligibilityVersion;

  ExploreCountsBuilder? _counts;
  ExploreCountsBuilder get counts => _$this._counts ??= ExploreCountsBuilder();
  set counts(ExploreCountsBuilder? counts) => _$this._counts = counts;

  ExploreLabelsBuilder? _labels;
  ExploreLabelsBuilder get labels => _$this._labels ??= ExploreLabelsBuilder();
  set labels(ExploreLabelsBuilder? labels) => _$this._labels = labels;

  ListBuilder<ExploreCategoryCount>? _categories;
  ListBuilder<ExploreCategoryCount> get categories =>
      _$this._categories ??= ListBuilder<ExploreCategoryCount>();
  set categories(ListBuilder<ExploreCategoryCount>? categories) =>
      _$this._categories = categories;

  FeatureAvailabilityBuilder? _materialsAnalytics;
  FeatureAvailabilityBuilder get materialsAnalytics =>
      _$this._materialsAnalytics ??= FeatureAvailabilityBuilder();
  set materialsAnalytics(FeatureAvailabilityBuilder? materialsAnalytics) =>
      _$this._materialsAnalytics = materialsAnalytics;

  DatasetLabelBuilder? _dataset;
  DatasetLabelBuilder get dataset => _$this._dataset ??= DatasetLabelBuilder();
  set dataset(DatasetLabelBuilder? dataset) => _$this._dataset = dataset;

  ExploreSummaryBuilder() {
    ExploreSummary._defaults(this);
  }

  ExploreSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _scope = $v.scope.toBuilder();
      _countScope = $v.countScope;
      _scopeLabel = $v.scopeLabel;
      _currentAsOf = $v.currentAsOf;
      _eligibilityVersion = $v.eligibilityVersion;
      _counts = $v.counts.toBuilder();
      _labels = $v.labels.toBuilder();
      _categories = $v.categories.toBuilder();
      _materialsAnalytics = $v.materialsAnalytics.toBuilder();
      _dataset = $v.dataset.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExploreSummary other) {
    _$v = other as _$ExploreSummary;
  }

  @override
  void update(void Function(ExploreSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExploreSummary build() => _build();

  _$ExploreSummary _build() {
    _$ExploreSummary _$result;
    try {
      _$result = _$v ??
          _$ExploreSummary._(
            scope: scope.build(),
            countScope: BuiltValueNullFieldError.checkNotNull(
                countScope, r'ExploreSummary', 'countScope'),
            scopeLabel: BuiltValueNullFieldError.checkNotNull(
                scopeLabel, r'ExploreSummary', 'scopeLabel'),
            currentAsOf: BuiltValueNullFieldError.checkNotNull(
                currentAsOf, r'ExploreSummary', 'currentAsOf'),
            eligibilityVersion: BuiltValueNullFieldError.checkNotNull(
                eligibilityVersion, r'ExploreSummary', 'eligibilityVersion'),
            counts: counts.build(),
            labels: labels.build(),
            categories: categories.build(),
            materialsAnalytics: materialsAnalytics.build(),
            dataset: dataset.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scope';
        scope.build();

        _$failedField = 'counts';
        counts.build();
        _$failedField = 'labels';
        labels.build();
        _$failedField = 'categories';
        categories.build();
        _$failedField = 'materialsAnalytics';
        materialsAnalytics.build();
        _$failedField = 'dataset';
        dataset.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ExploreSummary', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
