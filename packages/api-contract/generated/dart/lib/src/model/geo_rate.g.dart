// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_rate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoRate extends GeoRate {
  @override
  final String? percent;
  @override
  final int? numerator;
  @override
  final int? denominator;
  @override
  final bool? suppressed;
  @override
  final String? reason;

  factory _$GeoRate([void Function(GeoRateBuilder)? updates]) =>
      (GeoRateBuilder()..update(updates))._build();

  _$GeoRate._(
      {this.percent,
      this.numerator,
      this.denominator,
      this.suppressed,
      this.reason})
      : super._();
  @override
  GeoRate rebuild(void Function(GeoRateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoRateBuilder toBuilder() => GeoRateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoRate &&
        percent == other.percent &&
        numerator == other.numerator &&
        denominator == other.denominator &&
        suppressed == other.suppressed &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, percent.hashCode);
    _$hash = $jc(_$hash, numerator.hashCode);
    _$hash = $jc(_$hash, denominator.hashCode);
    _$hash = $jc(_$hash, suppressed.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoRate')
          ..add('percent', percent)
          ..add('numerator', numerator)
          ..add('denominator', denominator)
          ..add('suppressed', suppressed)
          ..add('reason', reason))
        .toString();
  }
}

class GeoRateBuilder implements Builder<GeoRate, GeoRateBuilder> {
  _$GeoRate? _$v;

  String? _percent;
  String? get percent => _$this._percent;
  set percent(String? percent) => _$this._percent = percent;

  int? _numerator;
  int? get numerator => _$this._numerator;
  set numerator(int? numerator) => _$this._numerator = numerator;

  int? _denominator;
  int? get denominator => _$this._denominator;
  set denominator(int? denominator) => _$this._denominator = denominator;

  bool? _suppressed;
  bool? get suppressed => _$this._suppressed;
  set suppressed(bool? suppressed) => _$this._suppressed = suppressed;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  GeoRateBuilder() {
    GeoRate._defaults(this);
  }

  GeoRateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _percent = $v.percent;
      _numerator = $v.numerator;
      _denominator = $v.denominator;
      _suppressed = $v.suppressed;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoRate other) {
    _$v = other as _$GeoRate;
  }

  @override
  void update(void Function(GeoRateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoRate build() => _build();

  _$GeoRate _build() {
    final _$result = _$v ??
        _$GeoRate._(
          percent: percent,
          numerator: numerator,
          denominator: denominator,
          suppressed: suppressed,
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
