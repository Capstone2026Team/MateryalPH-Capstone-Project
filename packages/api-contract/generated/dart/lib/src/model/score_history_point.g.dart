// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_history_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ScoreHistoryPoint extends ScoreHistoryPoint {
  @override
  final Date date;
  @override
  final String? vps;
  @override
  final String? vcs;
  @override
  final String? mqs;
  @override
  final String? ohs;

  factory _$ScoreHistoryPoint(
          [void Function(ScoreHistoryPointBuilder)? updates]) =>
      (ScoreHistoryPointBuilder()..update(updates))._build();

  _$ScoreHistoryPoint._(
      {required this.date, this.vps, this.vcs, this.mqs, this.ohs})
      : super._();
  @override
  ScoreHistoryPoint rebuild(void Function(ScoreHistoryPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScoreHistoryPointBuilder toBuilder() =>
      ScoreHistoryPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScoreHistoryPoint &&
        date == other.date &&
        vps == other.vps &&
        vcs == other.vcs &&
        mqs == other.mqs &&
        ohs == other.ohs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, vps.hashCode);
    _$hash = $jc(_$hash, vcs.hashCode);
    _$hash = $jc(_$hash, mqs.hashCode);
    _$hash = $jc(_$hash, ohs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScoreHistoryPoint')
          ..add('date', date)
          ..add('vps', vps)
          ..add('vcs', vcs)
          ..add('mqs', mqs)
          ..add('ohs', ohs))
        .toString();
  }
}

class ScoreHistoryPointBuilder
    implements Builder<ScoreHistoryPoint, ScoreHistoryPointBuilder> {
  _$ScoreHistoryPoint? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  String? _vps;
  String? get vps => _$this._vps;
  set vps(String? vps) => _$this._vps = vps;

  String? _vcs;
  String? get vcs => _$this._vcs;
  set vcs(String? vcs) => _$this._vcs = vcs;

  String? _mqs;
  String? get mqs => _$this._mqs;
  set mqs(String? mqs) => _$this._mqs = mqs;

  String? _ohs;
  String? get ohs => _$this._ohs;
  set ohs(String? ohs) => _$this._ohs = ohs;

  ScoreHistoryPointBuilder() {
    ScoreHistoryPoint._defaults(this);
  }

  ScoreHistoryPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _vps = $v.vps;
      _vcs = $v.vcs;
      _mqs = $v.mqs;
      _ohs = $v.ohs;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScoreHistoryPoint other) {
    _$v = other as _$ScoreHistoryPoint;
  }

  @override
  void update(void Function(ScoreHistoryPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScoreHistoryPoint build() => _build();

  _$ScoreHistoryPoint _build() {
    final _$result = _$v ??
        _$ScoreHistoryPoint._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'ScoreHistoryPoint', 'date'),
          vps: vps,
          vcs: vcs,
          mqs: mqs,
          ohs: ohs,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
