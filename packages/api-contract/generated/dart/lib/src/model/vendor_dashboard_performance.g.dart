// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_performance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardPerformance extends VendorDashboardPerformance {
  @override
  final bool calculated;
  @override
  final Date? asOf;
  @override
  final String label;
  @override
  final BuiltList<ScoreMetric> scores;
  @override
  final BuiltList<BadgeMetric> badgeMetrics;
  @override
  final BuiltMap<String, JsonObject?>? operations;
  @override
  final BuiltList<ScoreHistoryPoint> history;
  @override
  final DashboardClassification classification;
  @override
  final BuiltList<BadgeState> badges;

  factory _$VendorDashboardPerformance(
          [void Function(VendorDashboardPerformanceBuilder)? updates]) =>
      (VendorDashboardPerformanceBuilder()..update(updates))._build();

  _$VendorDashboardPerformance._(
      {required this.calculated,
      this.asOf,
      required this.label,
      required this.scores,
      required this.badgeMetrics,
      this.operations,
      required this.history,
      required this.classification,
      required this.badges})
      : super._();
  @override
  VendorDashboardPerformance rebuild(
          void Function(VendorDashboardPerformanceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardPerformanceBuilder toBuilder() =>
      VendorDashboardPerformanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardPerformance &&
        calculated == other.calculated &&
        asOf == other.asOf &&
        label == other.label &&
        scores == other.scores &&
        badgeMetrics == other.badgeMetrics &&
        operations == other.operations &&
        history == other.history &&
        classification == other.classification &&
        badges == other.badges;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, calculated.hashCode);
    _$hash = $jc(_$hash, asOf.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, scores.hashCode);
    _$hash = $jc(_$hash, badgeMetrics.hashCode);
    _$hash = $jc(_$hash, operations.hashCode);
    _$hash = $jc(_$hash, history.hashCode);
    _$hash = $jc(_$hash, classification.hashCode);
    _$hash = $jc(_$hash, badges.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardPerformance')
          ..add('calculated', calculated)
          ..add('asOf', asOf)
          ..add('label', label)
          ..add('scores', scores)
          ..add('badgeMetrics', badgeMetrics)
          ..add('operations', operations)
          ..add('history', history)
          ..add('classification', classification)
          ..add('badges', badges))
        .toString();
  }
}

class VendorDashboardPerformanceBuilder
    implements
        Builder<VendorDashboardPerformance, VendorDashboardPerformanceBuilder> {
  _$VendorDashboardPerformance? _$v;

  bool? _calculated;
  bool? get calculated => _$this._calculated;
  set calculated(bool? calculated) => _$this._calculated = calculated;

  Date? _asOf;
  Date? get asOf => _$this._asOf;
  set asOf(Date? asOf) => _$this._asOf = asOf;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  ListBuilder<ScoreMetric>? _scores;
  ListBuilder<ScoreMetric> get scores =>
      _$this._scores ??= ListBuilder<ScoreMetric>();
  set scores(ListBuilder<ScoreMetric>? scores) => _$this._scores = scores;

  ListBuilder<BadgeMetric>? _badgeMetrics;
  ListBuilder<BadgeMetric> get badgeMetrics =>
      _$this._badgeMetrics ??= ListBuilder<BadgeMetric>();
  set badgeMetrics(ListBuilder<BadgeMetric>? badgeMetrics) =>
      _$this._badgeMetrics = badgeMetrics;

  MapBuilder<String, JsonObject?>? _operations;
  MapBuilder<String, JsonObject?> get operations =>
      _$this._operations ??= MapBuilder<String, JsonObject?>();
  set operations(MapBuilder<String, JsonObject?>? operations) =>
      _$this._operations = operations;

  ListBuilder<ScoreHistoryPoint>? _history;
  ListBuilder<ScoreHistoryPoint> get history =>
      _$this._history ??= ListBuilder<ScoreHistoryPoint>();
  set history(ListBuilder<ScoreHistoryPoint>? history) =>
      _$this._history = history;

  DashboardClassificationBuilder? _classification;
  DashboardClassificationBuilder get classification =>
      _$this._classification ??= DashboardClassificationBuilder();
  set classification(DashboardClassificationBuilder? classification) =>
      _$this._classification = classification;

  ListBuilder<BadgeState>? _badges;
  ListBuilder<BadgeState> get badges =>
      _$this._badges ??= ListBuilder<BadgeState>();
  set badges(ListBuilder<BadgeState>? badges) => _$this._badges = badges;

  VendorDashboardPerformanceBuilder() {
    VendorDashboardPerformance._defaults(this);
  }

  VendorDashboardPerformanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _calculated = $v.calculated;
      _asOf = $v.asOf;
      _label = $v.label;
      _scores = $v.scores.toBuilder();
      _badgeMetrics = $v.badgeMetrics.toBuilder();
      _operations = $v.operations?.toBuilder();
      _history = $v.history.toBuilder();
      _classification = $v.classification.toBuilder();
      _badges = $v.badges.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardPerformance other) {
    _$v = other as _$VendorDashboardPerformance;
  }

  @override
  void update(void Function(VendorDashboardPerformanceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardPerformance build() => _build();

  _$VendorDashboardPerformance _build() {
    _$VendorDashboardPerformance _$result;
    try {
      _$result = _$v ??
          _$VendorDashboardPerformance._(
            calculated: BuiltValueNullFieldError.checkNotNull(
                calculated, r'VendorDashboardPerformance', 'calculated'),
            asOf: asOf,
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'VendorDashboardPerformance', 'label'),
            scores: scores.build(),
            badgeMetrics: badgeMetrics.build(),
            operations: _operations?.build(),
            history: history.build(),
            classification: classification.build(),
            badges: badges.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scores';
        scores.build();
        _$failedField = 'badgeMetrics';
        badgeMetrics.build();
        _$failedField = 'operations';
        _operations?.build();
        _$failedField = 'history';
        history.build();
        _$failedField = 'classification';
        classification.build();
        _$failedField = 'badges';
        badges.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorDashboardPerformance', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
