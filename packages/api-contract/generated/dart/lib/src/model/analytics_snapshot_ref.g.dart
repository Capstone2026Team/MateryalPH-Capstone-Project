// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_snapshot_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AnalyticsSnapshotRef extends AnalyticsSnapshotRef {
  @override
  final Date date;
  @override
  final DateTime observedAt;
  @override
  final int revision;

  factory _$AnalyticsSnapshotRef(
          [void Function(AnalyticsSnapshotRefBuilder)? updates]) =>
      (AnalyticsSnapshotRefBuilder()..update(updates))._build();

  _$AnalyticsSnapshotRef._(
      {required this.date, required this.observedAt, required this.revision})
      : super._();
  @override
  AnalyticsSnapshotRef rebuild(
          void Function(AnalyticsSnapshotRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnalyticsSnapshotRefBuilder toBuilder() =>
      AnalyticsSnapshotRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnalyticsSnapshotRef &&
        date == other.date &&
        observedAt == other.observedAt &&
        revision == other.revision;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, observedAt.hashCode);
    _$hash = $jc(_$hash, revision.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AnalyticsSnapshotRef')
          ..add('date', date)
          ..add('observedAt', observedAt)
          ..add('revision', revision))
        .toString();
  }
}

class AnalyticsSnapshotRefBuilder
    implements Builder<AnalyticsSnapshotRef, AnalyticsSnapshotRefBuilder> {
  _$AnalyticsSnapshotRef? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  DateTime? _observedAt;
  DateTime? get observedAt => _$this._observedAt;
  set observedAt(DateTime? observedAt) => _$this._observedAt = observedAt;

  int? _revision;
  int? get revision => _$this._revision;
  set revision(int? revision) => _$this._revision = revision;

  AnalyticsSnapshotRefBuilder() {
    AnalyticsSnapshotRef._defaults(this);
  }

  AnalyticsSnapshotRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _observedAt = $v.observedAt;
      _revision = $v.revision;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnalyticsSnapshotRef other) {
    _$v = other as _$AnalyticsSnapshotRef;
  }

  @override
  void update(void Function(AnalyticsSnapshotRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnalyticsSnapshotRef build() => _build();

  _$AnalyticsSnapshotRef _build() {
    final _$result = _$v ??
        _$AnalyticsSnapshotRef._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'AnalyticsSnapshotRef', 'date'),
          observedAt: BuiltValueNullFieldError.checkNotNull(
              observedAt, r'AnalyticsSnapshotRef', 'observedAt'),
          revision: BuiltValueNullFieldError.checkNotNull(
              revision, r'AnalyticsSnapshotRef', 'revision'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
