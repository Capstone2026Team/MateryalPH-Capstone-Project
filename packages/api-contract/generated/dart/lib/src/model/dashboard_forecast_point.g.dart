// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_forecast_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DashboardForecastPoint extends DashboardForecastPoint {
  @override
  final Date date;
  @override
  final num value;
  @override
  final num lower;
  @override
  final num upper;

  factory _$DashboardForecastPoint(
          [void Function(DashboardForecastPointBuilder)? updates]) =>
      (DashboardForecastPointBuilder()..update(updates))._build();

  _$DashboardForecastPoint._(
      {required this.date,
      required this.value,
      required this.lower,
      required this.upper})
      : super._();
  @override
  DashboardForecastPoint rebuild(
          void Function(DashboardForecastPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardForecastPointBuilder toBuilder() =>
      DashboardForecastPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardForecastPoint &&
        date == other.date &&
        value == other.value &&
        lower == other.lower &&
        upper == other.upper;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, lower.hashCode);
    _$hash = $jc(_$hash, upper.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DashboardForecastPoint')
          ..add('date', date)
          ..add('value', value)
          ..add('lower', lower)
          ..add('upper', upper))
        .toString();
  }
}

class DashboardForecastPointBuilder
    implements Builder<DashboardForecastPoint, DashboardForecastPointBuilder> {
  _$DashboardForecastPoint? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  num? _value;
  num? get value => _$this._value;
  set value(num? value) => _$this._value = value;

  num? _lower;
  num? get lower => _$this._lower;
  set lower(num? lower) => _$this._lower = lower;

  num? _upper;
  num? get upper => _$this._upper;
  set upper(num? upper) => _$this._upper = upper;

  DashboardForecastPointBuilder() {
    DashboardForecastPoint._defaults(this);
  }

  DashboardForecastPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _value = $v.value;
      _lower = $v.lower;
      _upper = $v.upper;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DashboardForecastPoint other) {
    _$v = other as _$DashboardForecastPoint;
  }

  @override
  void update(void Function(DashboardForecastPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardForecastPoint build() => _build();

  _$DashboardForecastPoint _build() {
    final _$result = _$v ??
        _$DashboardForecastPoint._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'DashboardForecastPoint', 'date'),
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'DashboardForecastPoint', 'value'),
          lower: BuiltValueNullFieldError.checkNotNull(
              lower, r'DashboardForecastPoint', 'lower'),
          upper: BuiltValueNullFieldError.checkNotNull(
              upper, r'DashboardForecastPoint', 'upper'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
