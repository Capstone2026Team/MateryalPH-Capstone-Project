// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_response_time.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DashboardResponseTime extends DashboardResponseTime {
  @override
  final int? meanSeconds;
  @override
  final int? medianSeconds;
  @override
  final int? p90Seconds;
  @override
  final int answered;
  @override
  final int unanswered;

  factory _$DashboardResponseTime(
          [void Function(DashboardResponseTimeBuilder)? updates]) =>
      (DashboardResponseTimeBuilder()..update(updates))._build();

  _$DashboardResponseTime._(
      {this.meanSeconds,
      this.medianSeconds,
      this.p90Seconds,
      required this.answered,
      required this.unanswered})
      : super._();
  @override
  DashboardResponseTime rebuild(
          void Function(DashboardResponseTimeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardResponseTimeBuilder toBuilder() =>
      DashboardResponseTimeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardResponseTime &&
        meanSeconds == other.meanSeconds &&
        medianSeconds == other.medianSeconds &&
        p90Seconds == other.p90Seconds &&
        answered == other.answered &&
        unanswered == other.unanswered;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, meanSeconds.hashCode);
    _$hash = $jc(_$hash, medianSeconds.hashCode);
    _$hash = $jc(_$hash, p90Seconds.hashCode);
    _$hash = $jc(_$hash, answered.hashCode);
    _$hash = $jc(_$hash, unanswered.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DashboardResponseTime')
          ..add('meanSeconds', meanSeconds)
          ..add('medianSeconds', medianSeconds)
          ..add('p90Seconds', p90Seconds)
          ..add('answered', answered)
          ..add('unanswered', unanswered))
        .toString();
  }
}

class DashboardResponseTimeBuilder
    implements Builder<DashboardResponseTime, DashboardResponseTimeBuilder> {
  _$DashboardResponseTime? _$v;

  int? _meanSeconds;
  int? get meanSeconds => _$this._meanSeconds;
  set meanSeconds(int? meanSeconds) => _$this._meanSeconds = meanSeconds;

  int? _medianSeconds;
  int? get medianSeconds => _$this._medianSeconds;
  set medianSeconds(int? medianSeconds) =>
      _$this._medianSeconds = medianSeconds;

  int? _p90Seconds;
  int? get p90Seconds => _$this._p90Seconds;
  set p90Seconds(int? p90Seconds) => _$this._p90Seconds = p90Seconds;

  int? _answered;
  int? get answered => _$this._answered;
  set answered(int? answered) => _$this._answered = answered;

  int? _unanswered;
  int? get unanswered => _$this._unanswered;
  set unanswered(int? unanswered) => _$this._unanswered = unanswered;

  DashboardResponseTimeBuilder() {
    DashboardResponseTime._defaults(this);
  }

  DashboardResponseTimeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meanSeconds = $v.meanSeconds;
      _medianSeconds = $v.medianSeconds;
      _p90Seconds = $v.p90Seconds;
      _answered = $v.answered;
      _unanswered = $v.unanswered;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DashboardResponseTime other) {
    _$v = other as _$DashboardResponseTime;
  }

  @override
  void update(void Function(DashboardResponseTimeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardResponseTime build() => _build();

  _$DashboardResponseTime _build() {
    final _$result = _$v ??
        _$DashboardResponseTime._(
          meanSeconds: meanSeconds,
          medianSeconds: medianSeconds,
          p90Seconds: p90Seconds,
          answered: BuiltValueNullFieldError.checkNotNull(
              answered, r'DashboardResponseTime', 'answered'),
          unanswered: BuiltValueNullFieldError.checkNotNull(
              unanswered, r'DashboardResponseTime', 'unanswered'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
