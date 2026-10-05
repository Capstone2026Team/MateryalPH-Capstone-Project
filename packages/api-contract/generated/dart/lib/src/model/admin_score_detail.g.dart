// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_score_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminScoreDetail extends AdminScoreDetail {
  @override
  final String? vendorId;
  @override
  final String? storeName;
  @override
  final bool? calculated;
  @override
  final Date? asOf;
  @override
  final String? label;
  @override
  final BuiltList<ScoreMetric>? scores;
  @override
  final BuiltMap<String, JsonObject?>? operations;
  @override
  final BuiltList<BadgeMetric>? badgeMetrics;
  @override
  final BuiltList<BadgeState>? badges;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>>? badgeHistory;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>>? suppressions;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>>? exclusions;
  @override
  final BuiltMap<String, JsonObject?>? sourceEvents;
  @override
  final BuiltList<ScoreHistoryPoint>? history;
  @override
  final bool? canInvestigate;

  factory _$AdminScoreDetail(
          [void Function(AdminScoreDetailBuilder)? updates]) =>
      (AdminScoreDetailBuilder()..update(updates))._build();

  _$AdminScoreDetail._(
      {this.vendorId,
      this.storeName,
      this.calculated,
      this.asOf,
      this.label,
      this.scores,
      this.operations,
      this.badgeMetrics,
      this.badges,
      this.badgeHistory,
      this.suppressions,
      this.exclusions,
      this.sourceEvents,
      this.history,
      this.canInvestigate})
      : super._();
  @override
  AdminScoreDetail rebuild(void Function(AdminScoreDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminScoreDetailBuilder toBuilder() =>
      AdminScoreDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminScoreDetail &&
        vendorId == other.vendorId &&
        storeName == other.storeName &&
        calculated == other.calculated &&
        asOf == other.asOf &&
        label == other.label &&
        scores == other.scores &&
        operations == other.operations &&
        badgeMetrics == other.badgeMetrics &&
        badges == other.badges &&
        badgeHistory == other.badgeHistory &&
        suppressions == other.suppressions &&
        exclusions == other.exclusions &&
        sourceEvents == other.sourceEvents &&
        history == other.history &&
        canInvestigate == other.canInvestigate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, storeName.hashCode);
    _$hash = $jc(_$hash, calculated.hashCode);
    _$hash = $jc(_$hash, asOf.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, scores.hashCode);
    _$hash = $jc(_$hash, operations.hashCode);
    _$hash = $jc(_$hash, badgeMetrics.hashCode);
    _$hash = $jc(_$hash, badges.hashCode);
    _$hash = $jc(_$hash, badgeHistory.hashCode);
    _$hash = $jc(_$hash, suppressions.hashCode);
    _$hash = $jc(_$hash, exclusions.hashCode);
    _$hash = $jc(_$hash, sourceEvents.hashCode);
    _$hash = $jc(_$hash, history.hashCode);
    _$hash = $jc(_$hash, canInvestigate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminScoreDetail')
          ..add('vendorId', vendorId)
          ..add('storeName', storeName)
          ..add('calculated', calculated)
          ..add('asOf', asOf)
          ..add('label', label)
          ..add('scores', scores)
          ..add('operations', operations)
          ..add('badgeMetrics', badgeMetrics)
          ..add('badges', badges)
          ..add('badgeHistory', badgeHistory)
          ..add('suppressions', suppressions)
          ..add('exclusions', exclusions)
          ..add('sourceEvents', sourceEvents)
          ..add('history', history)
          ..add('canInvestigate', canInvestigate))
        .toString();
  }
}

class AdminScoreDetailBuilder
    implements Builder<AdminScoreDetail, AdminScoreDetailBuilder> {
  _$AdminScoreDetail? _$v;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  String? _storeName;
  String? get storeName => _$this._storeName;
  set storeName(String? storeName) => _$this._storeName = storeName;

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

  MapBuilder<String, JsonObject?>? _operations;
  MapBuilder<String, JsonObject?> get operations =>
      _$this._operations ??= MapBuilder<String, JsonObject?>();
  set operations(MapBuilder<String, JsonObject?>? operations) =>
      _$this._operations = operations;

  ListBuilder<BadgeMetric>? _badgeMetrics;
  ListBuilder<BadgeMetric> get badgeMetrics =>
      _$this._badgeMetrics ??= ListBuilder<BadgeMetric>();
  set badgeMetrics(ListBuilder<BadgeMetric>? badgeMetrics) =>
      _$this._badgeMetrics = badgeMetrics;

  ListBuilder<BadgeState>? _badges;
  ListBuilder<BadgeState> get badges =>
      _$this._badges ??= ListBuilder<BadgeState>();
  set badges(ListBuilder<BadgeState>? badges) => _$this._badges = badges;

  ListBuilder<BuiltMap<String, JsonObject?>>? _badgeHistory;
  ListBuilder<BuiltMap<String, JsonObject?>> get badgeHistory =>
      _$this._badgeHistory ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set badgeHistory(ListBuilder<BuiltMap<String, JsonObject?>>? badgeHistory) =>
      _$this._badgeHistory = badgeHistory;

  ListBuilder<BuiltMap<String, JsonObject?>>? _suppressions;
  ListBuilder<BuiltMap<String, JsonObject?>> get suppressions =>
      _$this._suppressions ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set suppressions(ListBuilder<BuiltMap<String, JsonObject?>>? suppressions) =>
      _$this._suppressions = suppressions;

  ListBuilder<BuiltMap<String, JsonObject?>>? _exclusions;
  ListBuilder<BuiltMap<String, JsonObject?>> get exclusions =>
      _$this._exclusions ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set exclusions(ListBuilder<BuiltMap<String, JsonObject?>>? exclusions) =>
      _$this._exclusions = exclusions;

  MapBuilder<String, JsonObject?>? _sourceEvents;
  MapBuilder<String, JsonObject?> get sourceEvents =>
      _$this._sourceEvents ??= MapBuilder<String, JsonObject?>();
  set sourceEvents(MapBuilder<String, JsonObject?>? sourceEvents) =>
      _$this._sourceEvents = sourceEvents;

  ListBuilder<ScoreHistoryPoint>? _history;
  ListBuilder<ScoreHistoryPoint> get history =>
      _$this._history ??= ListBuilder<ScoreHistoryPoint>();
  set history(ListBuilder<ScoreHistoryPoint>? history) =>
      _$this._history = history;

  bool? _canInvestigate;
  bool? get canInvestigate => _$this._canInvestigate;
  set canInvestigate(bool? canInvestigate) =>
      _$this._canInvestigate = canInvestigate;

  AdminScoreDetailBuilder() {
    AdminScoreDetail._defaults(this);
  }

  AdminScoreDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorId = $v.vendorId;
      _storeName = $v.storeName;
      _calculated = $v.calculated;
      _asOf = $v.asOf;
      _label = $v.label;
      _scores = $v.scores?.toBuilder();
      _operations = $v.operations?.toBuilder();
      _badgeMetrics = $v.badgeMetrics?.toBuilder();
      _badges = $v.badges?.toBuilder();
      _badgeHistory = $v.badgeHistory?.toBuilder();
      _suppressions = $v.suppressions?.toBuilder();
      _exclusions = $v.exclusions?.toBuilder();
      _sourceEvents = $v.sourceEvents?.toBuilder();
      _history = $v.history?.toBuilder();
      _canInvestigate = $v.canInvestigate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminScoreDetail other) {
    _$v = other as _$AdminScoreDetail;
  }

  @override
  void update(void Function(AdminScoreDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminScoreDetail build() => _build();

  _$AdminScoreDetail _build() {
    _$AdminScoreDetail _$result;
    try {
      _$result = _$v ??
          _$AdminScoreDetail._(
            vendorId: vendorId,
            storeName: storeName,
            calculated: calculated,
            asOf: asOf,
            label: label,
            scores: _scores?.build(),
            operations: _operations?.build(),
            badgeMetrics: _badgeMetrics?.build(),
            badges: _badges?.build(),
            badgeHistory: _badgeHistory?.build(),
            suppressions: _suppressions?.build(),
            exclusions: _exclusions?.build(),
            sourceEvents: _sourceEvents?.build(),
            history: _history?.build(),
            canInvestigate: canInvestigate,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scores';
        _scores?.build();
        _$failedField = 'operations';
        _operations?.build();
        _$failedField = 'badgeMetrics';
        _badgeMetrics?.build();
        _$failedField = 'badges';
        _badges?.build();
        _$failedField = 'badgeHistory';
        _badgeHistory?.build();
        _$failedField = 'suppressions';
        _suppressions?.build();
        _$failedField = 'exclusions';
        _exclusions?.build();
        _$failedField = 'sourceEvents';
        _sourceEvents?.build();
        _$failedField = 'history';
        _history?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminScoreDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
