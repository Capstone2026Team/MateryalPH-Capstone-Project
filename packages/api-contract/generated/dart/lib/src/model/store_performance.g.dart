// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_performance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StorePerformance extends StorePerformance {
  @override
  final bool calculated;
  @override
  final Date? asOf;
  @override
  final DateTime? calculatedAt;
  @override
  final String label;
  @override
  final BuiltList<ScoreMetric> scores;
  @override
  final BuiltMap<String, JsonObject?> ratingComponents;
  @override
  final BuiltMap<String, JsonObject?>? operations;
  @override
  final Date? ohsCalculatedOn;
  @override
  final Date nextOhsRecalculationOn;
  @override
  final BuiltList<BadgeMetric> badgeMetrics;
  @override
  final BuiltMap<String, JsonObject?> completedOrders;
  @override
  final BuiltList<ScoreHistoryPoint> history;
  @override
  final BuiltList<BadgeState> badges;

  factory _$StorePerformance(
          [void Function(StorePerformanceBuilder)? updates]) =>
      (StorePerformanceBuilder()..update(updates))._build();

  _$StorePerformance._(
      {required this.calculated,
      this.asOf,
      this.calculatedAt,
      required this.label,
      required this.scores,
      required this.ratingComponents,
      this.operations,
      this.ohsCalculatedOn,
      required this.nextOhsRecalculationOn,
      required this.badgeMetrics,
      required this.completedOrders,
      required this.history,
      required this.badges})
      : super._();
  @override
  StorePerformance rebuild(void Function(StorePerformanceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StorePerformanceBuilder toBuilder() =>
      StorePerformanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StorePerformance &&
        calculated == other.calculated &&
        asOf == other.asOf &&
        calculatedAt == other.calculatedAt &&
        label == other.label &&
        scores == other.scores &&
        ratingComponents == other.ratingComponents &&
        operations == other.operations &&
        ohsCalculatedOn == other.ohsCalculatedOn &&
        nextOhsRecalculationOn == other.nextOhsRecalculationOn &&
        badgeMetrics == other.badgeMetrics &&
        completedOrders == other.completedOrders &&
        history == other.history &&
        badges == other.badges;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, calculated.hashCode);
    _$hash = $jc(_$hash, asOf.hashCode);
    _$hash = $jc(_$hash, calculatedAt.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, scores.hashCode);
    _$hash = $jc(_$hash, ratingComponents.hashCode);
    _$hash = $jc(_$hash, operations.hashCode);
    _$hash = $jc(_$hash, ohsCalculatedOn.hashCode);
    _$hash = $jc(_$hash, nextOhsRecalculationOn.hashCode);
    _$hash = $jc(_$hash, badgeMetrics.hashCode);
    _$hash = $jc(_$hash, completedOrders.hashCode);
    _$hash = $jc(_$hash, history.hashCode);
    _$hash = $jc(_$hash, badges.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StorePerformance')
          ..add('calculated', calculated)
          ..add('asOf', asOf)
          ..add('calculatedAt', calculatedAt)
          ..add('label', label)
          ..add('scores', scores)
          ..add('ratingComponents', ratingComponents)
          ..add('operations', operations)
          ..add('ohsCalculatedOn', ohsCalculatedOn)
          ..add('nextOhsRecalculationOn', nextOhsRecalculationOn)
          ..add('badgeMetrics', badgeMetrics)
          ..add('completedOrders', completedOrders)
          ..add('history', history)
          ..add('badges', badges))
        .toString();
  }
}

class StorePerformanceBuilder
    implements Builder<StorePerformance, StorePerformanceBuilder> {
  _$StorePerformance? _$v;

  bool? _calculated;
  bool? get calculated => _$this._calculated;
  set calculated(bool? calculated) => _$this._calculated = calculated;

  Date? _asOf;
  Date? get asOf => _$this._asOf;
  set asOf(Date? asOf) => _$this._asOf = asOf;

  DateTime? _calculatedAt;
  DateTime? get calculatedAt => _$this._calculatedAt;
  set calculatedAt(DateTime? calculatedAt) =>
      _$this._calculatedAt = calculatedAt;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  ListBuilder<ScoreMetric>? _scores;
  ListBuilder<ScoreMetric> get scores =>
      _$this._scores ??= ListBuilder<ScoreMetric>();
  set scores(ListBuilder<ScoreMetric>? scores) => _$this._scores = scores;

  MapBuilder<String, JsonObject?>? _ratingComponents;
  MapBuilder<String, JsonObject?> get ratingComponents =>
      _$this._ratingComponents ??= MapBuilder<String, JsonObject?>();
  set ratingComponents(MapBuilder<String, JsonObject?>? ratingComponents) =>
      _$this._ratingComponents = ratingComponents;

  MapBuilder<String, JsonObject?>? _operations;
  MapBuilder<String, JsonObject?> get operations =>
      _$this._operations ??= MapBuilder<String, JsonObject?>();
  set operations(MapBuilder<String, JsonObject?>? operations) =>
      _$this._operations = operations;

  Date? _ohsCalculatedOn;
  Date? get ohsCalculatedOn => _$this._ohsCalculatedOn;
  set ohsCalculatedOn(Date? ohsCalculatedOn) =>
      _$this._ohsCalculatedOn = ohsCalculatedOn;

  Date? _nextOhsRecalculationOn;
  Date? get nextOhsRecalculationOn => _$this._nextOhsRecalculationOn;
  set nextOhsRecalculationOn(Date? nextOhsRecalculationOn) =>
      _$this._nextOhsRecalculationOn = nextOhsRecalculationOn;

  ListBuilder<BadgeMetric>? _badgeMetrics;
  ListBuilder<BadgeMetric> get badgeMetrics =>
      _$this._badgeMetrics ??= ListBuilder<BadgeMetric>();
  set badgeMetrics(ListBuilder<BadgeMetric>? badgeMetrics) =>
      _$this._badgeMetrics = badgeMetrics;

  MapBuilder<String, JsonObject?>? _completedOrders;
  MapBuilder<String, JsonObject?> get completedOrders =>
      _$this._completedOrders ??= MapBuilder<String, JsonObject?>();
  set completedOrders(MapBuilder<String, JsonObject?>? completedOrders) =>
      _$this._completedOrders = completedOrders;

  ListBuilder<ScoreHistoryPoint>? _history;
  ListBuilder<ScoreHistoryPoint> get history =>
      _$this._history ??= ListBuilder<ScoreHistoryPoint>();
  set history(ListBuilder<ScoreHistoryPoint>? history) =>
      _$this._history = history;

  ListBuilder<BadgeState>? _badges;
  ListBuilder<BadgeState> get badges =>
      _$this._badges ??= ListBuilder<BadgeState>();
  set badges(ListBuilder<BadgeState>? badges) => _$this._badges = badges;

  StorePerformanceBuilder() {
    StorePerformance._defaults(this);
  }

  StorePerformanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _calculated = $v.calculated;
      _asOf = $v.asOf;
      _calculatedAt = $v.calculatedAt;
      _label = $v.label;
      _scores = $v.scores.toBuilder();
      _ratingComponents = $v.ratingComponents.toBuilder();
      _operations = $v.operations?.toBuilder();
      _ohsCalculatedOn = $v.ohsCalculatedOn;
      _nextOhsRecalculationOn = $v.nextOhsRecalculationOn;
      _badgeMetrics = $v.badgeMetrics.toBuilder();
      _completedOrders = $v.completedOrders.toBuilder();
      _history = $v.history.toBuilder();
      _badges = $v.badges.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StorePerformance other) {
    _$v = other as _$StorePerformance;
  }

  @override
  void update(void Function(StorePerformanceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StorePerformance build() => _build();

  _$StorePerformance _build() {
    _$StorePerformance _$result;
    try {
      _$result = _$v ??
          _$StorePerformance._(
            calculated: BuiltValueNullFieldError.checkNotNull(
                calculated, r'StorePerformance', 'calculated'),
            asOf: asOf,
            calculatedAt: calculatedAt,
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'StorePerformance', 'label'),
            scores: scores.build(),
            ratingComponents: ratingComponents.build(),
            operations: _operations?.build(),
            ohsCalculatedOn: ohsCalculatedOn,
            nextOhsRecalculationOn: BuiltValueNullFieldError.checkNotNull(
                nextOhsRecalculationOn,
                r'StorePerformance',
                'nextOhsRecalculationOn'),
            badgeMetrics: badgeMetrics.build(),
            completedOrders: completedOrders.build(),
            history: history.build(),
            badges: badges.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scores';
        scores.build();
        _$failedField = 'ratingComponents';
        ratingComponents.build();
        _$failedField = 'operations';
        _operations?.build();

        _$failedField = 'badgeMetrics';
        badgeMetrics.build();
        _$failedField = 'completedOrders';
        completedOrders.build();
        _$failedField = 'history';
        history.build();
        _$failedField = 'badges';
        badges.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'StorePerformance', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
