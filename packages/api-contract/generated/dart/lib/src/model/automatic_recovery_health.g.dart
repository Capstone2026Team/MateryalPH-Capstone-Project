// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automatic_recovery_health.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AutomaticRecoveryHealthStatusEnum
    _$automaticRecoveryHealthStatusEnum_HEALTHY =
    const AutomaticRecoveryHealthStatusEnum._('HEALTHY');
const AutomaticRecoveryHealthStatusEnum
    _$automaticRecoveryHealthStatusEnum_RUNNING =
    const AutomaticRecoveryHealthStatusEnum._('RUNNING');
const AutomaticRecoveryHealthStatusEnum
    _$automaticRecoveryHealthStatusEnum_FAILED =
    const AutomaticRecoveryHealthStatusEnum._('FAILED');
const AutomaticRecoveryHealthStatusEnum
    _$automaticRecoveryHealthStatusEnum_OVERDUE =
    const AutomaticRecoveryHealthStatusEnum._('OVERDUE');
const AutomaticRecoveryHealthStatusEnum
    _$automaticRecoveryHealthStatusEnum_NO_RUN_RECORDED =
    const AutomaticRecoveryHealthStatusEnum._('NO_RUN_RECORDED');

AutomaticRecoveryHealthStatusEnum _$automaticRecoveryHealthStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'HEALTHY':
      return _$automaticRecoveryHealthStatusEnum_HEALTHY;
    case 'RUNNING':
      return _$automaticRecoveryHealthStatusEnum_RUNNING;
    case 'FAILED':
      return _$automaticRecoveryHealthStatusEnum_FAILED;
    case 'OVERDUE':
      return _$automaticRecoveryHealthStatusEnum_OVERDUE;
    case 'NO_RUN_RECORDED':
      return _$automaticRecoveryHealthStatusEnum_NO_RUN_RECORDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AutomaticRecoveryHealthStatusEnum>
    _$automaticRecoveryHealthStatusEnumValues = BuiltSet<
        AutomaticRecoveryHealthStatusEnum>(const <AutomaticRecoveryHealthStatusEnum>[
  _$automaticRecoveryHealthStatusEnum_HEALTHY,
  _$automaticRecoveryHealthStatusEnum_RUNNING,
  _$automaticRecoveryHealthStatusEnum_FAILED,
  _$automaticRecoveryHealthStatusEnum_OVERDUE,
  _$automaticRecoveryHealthStatusEnum_NO_RUN_RECORDED,
]);

const AutomaticRecoveryHealthMaxCyclesEnum
    _$automaticRecoveryHealthMaxCyclesEnum_number3 =
    const AutomaticRecoveryHealthMaxCyclesEnum._('number3');

AutomaticRecoveryHealthMaxCyclesEnum
    _$automaticRecoveryHealthMaxCyclesEnumValueOf(String name) {
  switch (name) {
    case 'number3':
      return _$automaticRecoveryHealthMaxCyclesEnum_number3;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AutomaticRecoveryHealthMaxCyclesEnum>
    _$automaticRecoveryHealthMaxCyclesEnumValues = BuiltSet<
        AutomaticRecoveryHealthMaxCyclesEnum>(const <AutomaticRecoveryHealthMaxCyclesEnum>[
  _$automaticRecoveryHealthMaxCyclesEnum_number3,
]);

Serializer<AutomaticRecoveryHealthStatusEnum>
    _$automaticRecoveryHealthStatusEnumSerializer =
    _$AutomaticRecoveryHealthStatusEnumSerializer();
Serializer<AutomaticRecoveryHealthMaxCyclesEnum>
    _$automaticRecoveryHealthMaxCyclesEnumSerializer =
    _$AutomaticRecoveryHealthMaxCyclesEnumSerializer();

class _$AutomaticRecoveryHealthStatusEnumSerializer
    implements PrimitiveSerializer<AutomaticRecoveryHealthStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'HEALTHY': 'HEALTHY',
    'RUNNING': 'RUNNING',
    'FAILED': 'FAILED',
    'OVERDUE': 'OVERDUE',
    'NO_RUN_RECORDED': 'NO_RUN_RECORDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'HEALTHY': 'HEALTHY',
    'RUNNING': 'RUNNING',
    'FAILED': 'FAILED',
    'OVERDUE': 'OVERDUE',
    'NO_RUN_RECORDED': 'NO_RUN_RECORDED',
  };

  @override
  final Iterable<Type> types = const <Type>[AutomaticRecoveryHealthStatusEnum];
  @override
  final String wireName = 'AutomaticRecoveryHealthStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AutomaticRecoveryHealthStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AutomaticRecoveryHealthStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AutomaticRecoveryHealthStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AutomaticRecoveryHealthMaxCyclesEnumSerializer
    implements PrimitiveSerializer<AutomaticRecoveryHealthMaxCyclesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number3': 3,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    3: 'number3',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AutomaticRecoveryHealthMaxCyclesEnum
  ];
  @override
  final String wireName = 'AutomaticRecoveryHealthMaxCyclesEnum';

  @override
  Object serialize(
          Serializers serializers, AutomaticRecoveryHealthMaxCyclesEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AutomaticRecoveryHealthMaxCyclesEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AutomaticRecoveryHealthMaxCyclesEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AutomaticRecoveryHealth extends AutomaticRecoveryHealth {
  @override
  final AutomaticRecoveryHealthStatusEnum status;
  @override
  final AutomaticRecoveryHealthMaxCyclesEnum maxCycles;
  @override
  final BuiltList<int> delaysMinutes;
  @override
  final DateTime? lastStartedAt;

  factory _$AutomaticRecoveryHealth(
          [void Function(AutomaticRecoveryHealthBuilder)? updates]) =>
      (AutomaticRecoveryHealthBuilder()..update(updates))._build();

  _$AutomaticRecoveryHealth._(
      {required this.status,
      required this.maxCycles,
      required this.delaysMinutes,
      this.lastStartedAt})
      : super._();
  @override
  AutomaticRecoveryHealth rebuild(
          void Function(AutomaticRecoveryHealthBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutomaticRecoveryHealthBuilder toBuilder() =>
      AutomaticRecoveryHealthBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutomaticRecoveryHealth &&
        status == other.status &&
        maxCycles == other.maxCycles &&
        delaysMinutes == other.delaysMinutes &&
        lastStartedAt == other.lastStartedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, maxCycles.hashCode);
    _$hash = $jc(_$hash, delaysMinutes.hashCode);
    _$hash = $jc(_$hash, lastStartedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutomaticRecoveryHealth')
          ..add('status', status)
          ..add('maxCycles', maxCycles)
          ..add('delaysMinutes', delaysMinutes)
          ..add('lastStartedAt', lastStartedAt))
        .toString();
  }
}

class AutomaticRecoveryHealthBuilder
    implements
        Builder<AutomaticRecoveryHealth, AutomaticRecoveryHealthBuilder> {
  _$AutomaticRecoveryHealth? _$v;

  AutomaticRecoveryHealthStatusEnum? _status;
  AutomaticRecoveryHealthStatusEnum? get status => _$this._status;
  set status(AutomaticRecoveryHealthStatusEnum? status) =>
      _$this._status = status;

  AutomaticRecoveryHealthMaxCyclesEnum? _maxCycles;
  AutomaticRecoveryHealthMaxCyclesEnum? get maxCycles => _$this._maxCycles;
  set maxCycles(AutomaticRecoveryHealthMaxCyclesEnum? maxCycles) =>
      _$this._maxCycles = maxCycles;

  ListBuilder<int>? _delaysMinutes;
  ListBuilder<int> get delaysMinutes =>
      _$this._delaysMinutes ??= ListBuilder<int>();
  set delaysMinutes(ListBuilder<int>? delaysMinutes) =>
      _$this._delaysMinutes = delaysMinutes;

  DateTime? _lastStartedAt;
  DateTime? get lastStartedAt => _$this._lastStartedAt;
  set lastStartedAt(DateTime? lastStartedAt) =>
      _$this._lastStartedAt = lastStartedAt;

  AutomaticRecoveryHealthBuilder() {
    AutomaticRecoveryHealth._defaults(this);
  }

  AutomaticRecoveryHealthBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _maxCycles = $v.maxCycles;
      _delaysMinutes = $v.delaysMinutes.toBuilder();
      _lastStartedAt = $v.lastStartedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutomaticRecoveryHealth other) {
    _$v = other as _$AutomaticRecoveryHealth;
  }

  @override
  void update(void Function(AutomaticRecoveryHealthBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutomaticRecoveryHealth build() => _build();

  _$AutomaticRecoveryHealth _build() {
    _$AutomaticRecoveryHealth _$result;
    try {
      _$result = _$v ??
          _$AutomaticRecoveryHealth._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AutomaticRecoveryHealth', 'status'),
            maxCycles: BuiltValueNullFieldError.checkNotNull(
                maxCycles, r'AutomaticRecoveryHealth', 'maxCycles'),
            delaysMinutes: delaysMinutes.build(),
            lastStartedAt: lastStartedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'delaysMinutes';
        delaysMinutes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AutomaticRecoveryHealth', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
