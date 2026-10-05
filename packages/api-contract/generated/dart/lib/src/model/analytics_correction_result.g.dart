// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_correction_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AnalyticsCorrectionResult extends AnalyticsCorrectionResult {
  @override
  final String? state;
  @override
  final Date? snapshotDate;
  @override
  final String? runId;
  @override
  final int? revision;
  @override
  final int? observations;
  @override
  final int? selected;
  @override
  final int? vendors;

  factory _$AnalyticsCorrectionResult(
          [void Function(AnalyticsCorrectionResultBuilder)? updates]) =>
      (AnalyticsCorrectionResultBuilder()..update(updates))._build();

  _$AnalyticsCorrectionResult._(
      {this.state,
      this.snapshotDate,
      this.runId,
      this.revision,
      this.observations,
      this.selected,
      this.vendors})
      : super._();
  @override
  AnalyticsCorrectionResult rebuild(
          void Function(AnalyticsCorrectionResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnalyticsCorrectionResultBuilder toBuilder() =>
      AnalyticsCorrectionResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnalyticsCorrectionResult &&
        state == other.state &&
        snapshotDate == other.snapshotDate &&
        runId == other.runId &&
        revision == other.revision &&
        observations == other.observations &&
        selected == other.selected &&
        vendors == other.vendors;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, snapshotDate.hashCode);
    _$hash = $jc(_$hash, runId.hashCode);
    _$hash = $jc(_$hash, revision.hashCode);
    _$hash = $jc(_$hash, observations.hashCode);
    _$hash = $jc(_$hash, selected.hashCode);
    _$hash = $jc(_$hash, vendors.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AnalyticsCorrectionResult')
          ..add('state', state)
          ..add('snapshotDate', snapshotDate)
          ..add('runId', runId)
          ..add('revision', revision)
          ..add('observations', observations)
          ..add('selected', selected)
          ..add('vendors', vendors))
        .toString();
  }
}

class AnalyticsCorrectionResultBuilder
    implements
        Builder<AnalyticsCorrectionResult, AnalyticsCorrectionResultBuilder> {
  _$AnalyticsCorrectionResult? _$v;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

  Date? _snapshotDate;
  Date? get snapshotDate => _$this._snapshotDate;
  set snapshotDate(Date? snapshotDate) => _$this._snapshotDate = snapshotDate;

  String? _runId;
  String? get runId => _$this._runId;
  set runId(String? runId) => _$this._runId = runId;

  int? _revision;
  int? get revision => _$this._revision;
  set revision(int? revision) => _$this._revision = revision;

  int? _observations;
  int? get observations => _$this._observations;
  set observations(int? observations) => _$this._observations = observations;

  int? _selected;
  int? get selected => _$this._selected;
  set selected(int? selected) => _$this._selected = selected;

  int? _vendors;
  int? get vendors => _$this._vendors;
  set vendors(int? vendors) => _$this._vendors = vendors;

  AnalyticsCorrectionResultBuilder() {
    AnalyticsCorrectionResult._defaults(this);
  }

  AnalyticsCorrectionResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _snapshotDate = $v.snapshotDate;
      _runId = $v.runId;
      _revision = $v.revision;
      _observations = $v.observations;
      _selected = $v.selected;
      _vendors = $v.vendors;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnalyticsCorrectionResult other) {
    _$v = other as _$AnalyticsCorrectionResult;
  }

  @override
  void update(void Function(AnalyticsCorrectionResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnalyticsCorrectionResult build() => _build();

  _$AnalyticsCorrectionResult _build() {
    final _$result = _$v ??
        _$AnalyticsCorrectionResult._(
          state: state,
          snapshotDate: snapshotDate,
          runId: runId,
          revision: revision,
          observations: observations,
          selected: selected,
          vendors: vendors,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
