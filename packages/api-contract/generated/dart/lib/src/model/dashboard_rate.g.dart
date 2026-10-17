// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_rate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DashboardRate extends DashboardRate {
  @override
  final String? percent;
  @override
  final int numerator;
  @override
  final int denominator;

  factory _$DashboardRate([void Function(DashboardRateBuilder)? updates]) =>
      (DashboardRateBuilder()..update(updates))._build();

  _$DashboardRate._(
      {this.percent, required this.numerator, required this.denominator})
      : super._();
  @override
  DashboardRate rebuild(void Function(DashboardRateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardRateBuilder toBuilder() => DashboardRateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardRate &&
        percent == other.percent &&
        numerator == other.numerator &&
        denominator == other.denominator;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, percent.hashCode);
    _$hash = $jc(_$hash, numerator.hashCode);
    _$hash = $jc(_$hash, denominator.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DashboardRate')
          ..add('percent', percent)
          ..add('numerator', numerator)
          ..add('denominator', denominator))
        .toString();
  }
}

class DashboardRateBuilder
    implements Builder<DashboardRate, DashboardRateBuilder> {
  _$DashboardRate? _$v;

  String? _percent;
  String? get percent => _$this._percent;
  set percent(String? percent) => _$this._percent = percent;

  int? _numerator;
  int? get numerator => _$this._numerator;
  set numerator(int? numerator) => _$this._numerator = numerator;

  int? _denominator;
  int? get denominator => _$this._denominator;
  set denominator(int? denominator) => _$this._denominator = denominator;

  DashboardRateBuilder() {
    DashboardRate._defaults(this);
  }

  DashboardRateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _percent = $v.percent;
      _numerator = $v.numerator;
      _denominator = $v.denominator;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DashboardRate other) {
    _$v = other as _$DashboardRate;
  }

  @override
  void update(void Function(DashboardRateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardRate build() => _build();

  _$DashboardRate _build() {
    final _$result = _$v ??
        _$DashboardRate._(
          percent: percent,
          numerator: BuiltValueNullFieldError.checkNotNull(
              numerator, r'DashboardRate', 'numerator'),
          denominator: BuiltValueNullFieldError.checkNotNull(
              denominator, r'DashboardRate', 'denominator'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
