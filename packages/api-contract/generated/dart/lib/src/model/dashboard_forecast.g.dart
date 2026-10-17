// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_forecast.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DashboardForecastStateEnum _$dashboardForecastStateEnum_OK =
    const DashboardForecastStateEnum._('OK');
const DashboardForecastStateEnum
    _$dashboardForecastStateEnum_INSUFFICIENT_DATA =
    const DashboardForecastStateEnum._('INSUFFICIENT_DATA');

DashboardForecastStateEnum _$dashboardForecastStateEnumValueOf(String name) {
  switch (name) {
    case 'OK':
      return _$dashboardForecastStateEnum_OK;
    case 'INSUFFICIENT_DATA':
      return _$dashboardForecastStateEnum_INSUFFICIENT_DATA;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DashboardForecastStateEnum> _$dashboardForecastStateEnumValues =
    BuiltSet<DashboardForecastStateEnum>(const <DashboardForecastStateEnum>[
  _$dashboardForecastStateEnum_OK,
  _$dashboardForecastStateEnum_INSUFFICIENT_DATA,
]);

const DashboardForecastDirectionEnum
    _$dashboardForecastDirectionEnum_INCREASING =
    const DashboardForecastDirectionEnum._('INCREASING');
const DashboardForecastDirectionEnum
    _$dashboardForecastDirectionEnum_DECREASING =
    const DashboardForecastDirectionEnum._('DECREASING');
const DashboardForecastDirectionEnum _$dashboardForecastDirectionEnum_FLAT =
    const DashboardForecastDirectionEnum._('FLAT');
const DashboardForecastDirectionEnum _$dashboardForecastDirectionEnum_UNKNOWN =
    const DashboardForecastDirectionEnum._('UNKNOWN');

DashboardForecastDirectionEnum _$dashboardForecastDirectionEnumValueOf(
    String name) {
  switch (name) {
    case 'INCREASING':
      return _$dashboardForecastDirectionEnum_INCREASING;
    case 'DECREASING':
      return _$dashboardForecastDirectionEnum_DECREASING;
    case 'FLAT':
      return _$dashboardForecastDirectionEnum_FLAT;
    case 'UNKNOWN':
      return _$dashboardForecastDirectionEnum_UNKNOWN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DashboardForecastDirectionEnum>
    _$dashboardForecastDirectionEnumValues = BuiltSet<
        DashboardForecastDirectionEnum>(const <DashboardForecastDirectionEnum>[
  _$dashboardForecastDirectionEnum_INCREASING,
  _$dashboardForecastDirectionEnum_DECREASING,
  _$dashboardForecastDirectionEnum_FLAT,
  _$dashboardForecastDirectionEnum_UNKNOWN,
]);

Serializer<DashboardForecastStateEnum> _$dashboardForecastStateEnumSerializer =
    _$DashboardForecastStateEnumSerializer();
Serializer<DashboardForecastDirectionEnum>
    _$dashboardForecastDirectionEnumSerializer =
    _$DashboardForecastDirectionEnumSerializer();

class _$DashboardForecastStateEnumSerializer
    implements PrimitiveSerializer<DashboardForecastStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OK': 'OK',
    'INSUFFICIENT_DATA': 'INSUFFICIENT_DATA',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OK': 'OK',
    'INSUFFICIENT_DATA': 'INSUFFICIENT_DATA',
  };

  @override
  final Iterable<Type> types = const <Type>[DashboardForecastStateEnum];
  @override
  final String wireName = 'DashboardForecastStateEnum';

  @override
  Object serialize(Serializers serializers, DashboardForecastStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DashboardForecastStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DashboardForecastStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DashboardForecastDirectionEnumSerializer
    implements PrimitiveSerializer<DashboardForecastDirectionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INCREASING': 'INCREASING',
    'DECREASING': 'DECREASING',
    'FLAT': 'FLAT',
    'UNKNOWN': 'UNKNOWN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INCREASING': 'INCREASING',
    'DECREASING': 'DECREASING',
    'FLAT': 'FLAT',
    'UNKNOWN': 'UNKNOWN',
  };

  @override
  final Iterable<Type> types = const <Type>[DashboardForecastDirectionEnum];
  @override
  final String wireName = 'DashboardForecastDirectionEnum';

  @override
  Object serialize(
          Serializers serializers, DashboardForecastDirectionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DashboardForecastDirectionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DashboardForecastDirectionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DashboardForecast extends DashboardForecast {
  @override
  final DashboardForecastStateEnum state;
  @override
  final int observedDays;
  @override
  final DashboardForecastDirectionEnum direction;
  @override
  final num? changePercent;
  @override
  final num? rSquared;
  @override
  final num? weekdayStrength;
  @override
  final num? expectedTotal;
  @override
  final BuiltList<DashboardForecastPoint> points;
  @override
  final BuiltList<DashboardAnomaly> anomalies;

  factory _$DashboardForecast(
          [void Function(DashboardForecastBuilder)? updates]) =>
      (DashboardForecastBuilder()..update(updates))._build();

  _$DashboardForecast._(
      {required this.state,
      required this.observedDays,
      required this.direction,
      this.changePercent,
      this.rSquared,
      this.weekdayStrength,
      this.expectedTotal,
      required this.points,
      required this.anomalies})
      : super._();
  @override
  DashboardForecast rebuild(void Function(DashboardForecastBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardForecastBuilder toBuilder() =>
      DashboardForecastBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardForecast &&
        state == other.state &&
        observedDays == other.observedDays &&
        direction == other.direction &&
        changePercent == other.changePercent &&
        rSquared == other.rSquared &&
        weekdayStrength == other.weekdayStrength &&
        expectedTotal == other.expectedTotal &&
        points == other.points &&
        anomalies == other.anomalies;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, observedDays.hashCode);
    _$hash = $jc(_$hash, direction.hashCode);
    _$hash = $jc(_$hash, changePercent.hashCode);
    _$hash = $jc(_$hash, rSquared.hashCode);
    _$hash = $jc(_$hash, weekdayStrength.hashCode);
    _$hash = $jc(_$hash, expectedTotal.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jc(_$hash, anomalies.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DashboardForecast')
          ..add('state', state)
          ..add('observedDays', observedDays)
          ..add('direction', direction)
          ..add('changePercent', changePercent)
          ..add('rSquared', rSquared)
          ..add('weekdayStrength', weekdayStrength)
          ..add('expectedTotal', expectedTotal)
          ..add('points', points)
          ..add('anomalies', anomalies))
        .toString();
  }
}

class DashboardForecastBuilder
    implements Builder<DashboardForecast, DashboardForecastBuilder> {
  _$DashboardForecast? _$v;

  DashboardForecastStateEnum? _state;
  DashboardForecastStateEnum? get state => _$this._state;
  set state(DashboardForecastStateEnum? state) => _$this._state = state;

  int? _observedDays;
  int? get observedDays => _$this._observedDays;
  set observedDays(int? observedDays) => _$this._observedDays = observedDays;

  DashboardForecastDirectionEnum? _direction;
  DashboardForecastDirectionEnum? get direction => _$this._direction;
  set direction(DashboardForecastDirectionEnum? direction) =>
      _$this._direction = direction;

  num? _changePercent;
  num? get changePercent => _$this._changePercent;
  set changePercent(num? changePercent) =>
      _$this._changePercent = changePercent;

  num? _rSquared;
  num? get rSquared => _$this._rSquared;
  set rSquared(num? rSquared) => _$this._rSquared = rSquared;

  num? _weekdayStrength;
  num? get weekdayStrength => _$this._weekdayStrength;
  set weekdayStrength(num? weekdayStrength) =>
      _$this._weekdayStrength = weekdayStrength;

  num? _expectedTotal;
  num? get expectedTotal => _$this._expectedTotal;
  set expectedTotal(num? expectedTotal) =>
      _$this._expectedTotal = expectedTotal;

  ListBuilder<DashboardForecastPoint>? _points;
  ListBuilder<DashboardForecastPoint> get points =>
      _$this._points ??= ListBuilder<DashboardForecastPoint>();
  set points(ListBuilder<DashboardForecastPoint>? points) =>
      _$this._points = points;

  ListBuilder<DashboardAnomaly>? _anomalies;
  ListBuilder<DashboardAnomaly> get anomalies =>
      _$this._anomalies ??= ListBuilder<DashboardAnomaly>();
  set anomalies(ListBuilder<DashboardAnomaly>? anomalies) =>
      _$this._anomalies = anomalies;

  DashboardForecastBuilder() {
    DashboardForecast._defaults(this);
  }

  DashboardForecastBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _observedDays = $v.observedDays;
      _direction = $v.direction;
      _changePercent = $v.changePercent;
      _rSquared = $v.rSquared;
      _weekdayStrength = $v.weekdayStrength;
      _expectedTotal = $v.expectedTotal;
      _points = $v.points.toBuilder();
      _anomalies = $v.anomalies.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DashboardForecast other) {
    _$v = other as _$DashboardForecast;
  }

  @override
  void update(void Function(DashboardForecastBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardForecast build() => _build();

  _$DashboardForecast _build() {
    _$DashboardForecast _$result;
    try {
      _$result = _$v ??
          _$DashboardForecast._(
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'DashboardForecast', 'state'),
            observedDays: BuiltValueNullFieldError.checkNotNull(
                observedDays, r'DashboardForecast', 'observedDays'),
            direction: BuiltValueNullFieldError.checkNotNull(
                direction, r'DashboardForecast', 'direction'),
            changePercent: changePercent,
            rSquared: rSquared,
            weekdayStrength: weekdayStrength,
            expectedTotal: expectedTotal,
            points: points.build(),
            anomalies: anomalies.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'points';
        points.build();
        _$failedField = 'anomalies';
        anomalies.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DashboardForecast', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
