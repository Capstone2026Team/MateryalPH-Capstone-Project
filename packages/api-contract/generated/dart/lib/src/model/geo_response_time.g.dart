// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_response_time.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoResponseTime extends GeoResponseTime {
  @override
  final bool suppressed;
  @override
  final String? reason;
  @override
  final int? meanSeconds;
  @override
  final int? medianSeconds;
  @override
  final int? p90Seconds;
  @override
  final int? answered;
  @override
  final int? unanswered;

  factory _$GeoResponseTime([void Function(GeoResponseTimeBuilder)? updates]) =>
      (GeoResponseTimeBuilder()..update(updates))._build();

  _$GeoResponseTime._(
      {required this.suppressed,
      this.reason,
      this.meanSeconds,
      this.medianSeconds,
      this.p90Seconds,
      this.answered,
      this.unanswered})
      : super._();
  @override
  GeoResponseTime rebuild(void Function(GeoResponseTimeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoResponseTimeBuilder toBuilder() => GeoResponseTimeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoResponseTime &&
        suppressed == other.suppressed &&
        reason == other.reason &&
        meanSeconds == other.meanSeconds &&
        medianSeconds == other.medianSeconds &&
        p90Seconds == other.p90Seconds &&
        answered == other.answered &&
        unanswered == other.unanswered;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, suppressed.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
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
    return (newBuiltValueToStringHelper(r'GeoResponseTime')
          ..add('suppressed', suppressed)
          ..add('reason', reason)
          ..add('meanSeconds', meanSeconds)
          ..add('medianSeconds', medianSeconds)
          ..add('p90Seconds', p90Seconds)
          ..add('answered', answered)
          ..add('unanswered', unanswered))
        .toString();
  }
}

class GeoResponseTimeBuilder
    implements Builder<GeoResponseTime, GeoResponseTimeBuilder> {
  _$GeoResponseTime? _$v;

  bool? _suppressed;
  bool? get suppressed => _$this._suppressed;
  set suppressed(bool? suppressed) => _$this._suppressed = suppressed;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

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

  GeoResponseTimeBuilder() {
    GeoResponseTime._defaults(this);
  }

  GeoResponseTimeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _suppressed = $v.suppressed;
      _reason = $v.reason;
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
  void replace(GeoResponseTime other) {
    _$v = other as _$GeoResponseTime;
  }

  @override
  void update(void Function(GeoResponseTimeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoResponseTime build() => _build();

  _$GeoResponseTime _build() {
    final _$result = _$v ??
        _$GeoResponseTime._(
          suppressed: BuiltValueNullFieldError.checkNotNull(
              suppressed, r'GeoResponseTime', 'suppressed'),
          reason: reason,
          meanSeconds: meanSeconds,
          medianSeconds: medianSeconds,
          p90Seconds: p90Seconds,
          answered: answered,
          unanswered: unanswered,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
