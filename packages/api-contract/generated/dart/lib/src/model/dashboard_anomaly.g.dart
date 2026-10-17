// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_anomaly.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DashboardAnomaly extends DashboardAnomaly {
  @override
  final Date date;
  @override
  final num value;
  @override
  final num expected;
  @override
  final num deviation;

  factory _$DashboardAnomaly(
          [void Function(DashboardAnomalyBuilder)? updates]) =>
      (DashboardAnomalyBuilder()..update(updates))._build();

  _$DashboardAnomaly._(
      {required this.date,
      required this.value,
      required this.expected,
      required this.deviation})
      : super._();
  @override
  DashboardAnomaly rebuild(void Function(DashboardAnomalyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardAnomalyBuilder toBuilder() =>
      DashboardAnomalyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardAnomaly &&
        date == other.date &&
        value == other.value &&
        expected == other.expected &&
        deviation == other.deviation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, expected.hashCode);
    _$hash = $jc(_$hash, deviation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DashboardAnomaly')
          ..add('date', date)
          ..add('value', value)
          ..add('expected', expected)
          ..add('deviation', deviation))
        .toString();
  }
}

class DashboardAnomalyBuilder
    implements Builder<DashboardAnomaly, DashboardAnomalyBuilder> {
  _$DashboardAnomaly? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  num? _value;
  num? get value => _$this._value;
  set value(num? value) => _$this._value = value;

  num? _expected;
  num? get expected => _$this._expected;
  set expected(num? expected) => _$this._expected = expected;

  num? _deviation;
  num? get deviation => _$this._deviation;
  set deviation(num? deviation) => _$this._deviation = deviation;

  DashboardAnomalyBuilder() {
    DashboardAnomaly._defaults(this);
  }

  DashboardAnomalyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _value = $v.value;
      _expected = $v.expected;
      _deviation = $v.deviation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DashboardAnomaly other) {
    _$v = other as _$DashboardAnomaly;
  }

  @override
  void update(void Function(DashboardAnomalyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardAnomaly build() => _build();

  _$DashboardAnomaly _build() {
    final _$result = _$v ??
        _$DashboardAnomaly._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'DashboardAnomaly', 'date'),
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'DashboardAnomaly', 'value'),
          expected: BuiltValueNullFieldError.checkNotNull(
              expected, r'DashboardAnomaly', 'expected'),
          deviation: BuiltValueNullFieldError.checkNotNull(
              deviation, r'DashboardAnomaly', 'deviation'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
