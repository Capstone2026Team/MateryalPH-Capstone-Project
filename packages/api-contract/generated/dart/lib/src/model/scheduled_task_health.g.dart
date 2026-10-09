// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_task_health.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ScheduledTaskHealthStatusEnum _$scheduledTaskHealthStatusEnum_HEALTHY =
    const ScheduledTaskHealthStatusEnum._('HEALTHY');
const ScheduledTaskHealthStatusEnum _$scheduledTaskHealthStatusEnum_RUNNING =
    const ScheduledTaskHealthStatusEnum._('RUNNING');
const ScheduledTaskHealthStatusEnum _$scheduledTaskHealthStatusEnum_FAILED =
    const ScheduledTaskHealthStatusEnum._('FAILED');
const ScheduledTaskHealthStatusEnum _$scheduledTaskHealthStatusEnum_OVERDUE =
    const ScheduledTaskHealthStatusEnum._('OVERDUE');
const ScheduledTaskHealthStatusEnum
    _$scheduledTaskHealthStatusEnum_NO_RUN_RECORDED =
    const ScheduledTaskHealthStatusEnum._('NO_RUN_RECORDED');

ScheduledTaskHealthStatusEnum _$scheduledTaskHealthStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'HEALTHY':
      return _$scheduledTaskHealthStatusEnum_HEALTHY;
    case 'RUNNING':
      return _$scheduledTaskHealthStatusEnum_RUNNING;
    case 'FAILED':
      return _$scheduledTaskHealthStatusEnum_FAILED;
    case 'OVERDUE':
      return _$scheduledTaskHealthStatusEnum_OVERDUE;
    case 'NO_RUN_RECORDED':
      return _$scheduledTaskHealthStatusEnum_NO_RUN_RECORDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ScheduledTaskHealthStatusEnum>
    _$scheduledTaskHealthStatusEnumValues = BuiltSet<
        ScheduledTaskHealthStatusEnum>(const <ScheduledTaskHealthStatusEnum>[
  _$scheduledTaskHealthStatusEnum_HEALTHY,
  _$scheduledTaskHealthStatusEnum_RUNNING,
  _$scheduledTaskHealthStatusEnum_FAILED,
  _$scheduledTaskHealthStatusEnum_OVERDUE,
  _$scheduledTaskHealthStatusEnum_NO_RUN_RECORDED,
]);

Serializer<ScheduledTaskHealthStatusEnum>
    _$scheduledTaskHealthStatusEnumSerializer =
    _$ScheduledTaskHealthStatusEnumSerializer();

class _$ScheduledTaskHealthStatusEnumSerializer
    implements PrimitiveSerializer<ScheduledTaskHealthStatusEnum> {
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
  final Iterable<Type> types = const <Type>[ScheduledTaskHealthStatusEnum];
  @override
  final String wireName = 'ScheduledTaskHealthStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ScheduledTaskHealthStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ScheduledTaskHealthStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ScheduledTaskHealthStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ScheduledTaskHealth extends ScheduledTaskHealth {
  @override
  final String task;
  @override
  final ScheduledTaskHealthStatusEnum status;
  @override
  final String? lastOutcome;
  @override
  final DateTime? lastStartedAt;
  @override
  final int? durationMs;
  @override
  final int expectedWithinMinutes;

  factory _$ScheduledTaskHealth(
          [void Function(ScheduledTaskHealthBuilder)? updates]) =>
      (ScheduledTaskHealthBuilder()..update(updates))._build();

  _$ScheduledTaskHealth._(
      {required this.task,
      required this.status,
      this.lastOutcome,
      this.lastStartedAt,
      this.durationMs,
      required this.expectedWithinMinutes})
      : super._();
  @override
  ScheduledTaskHealth rebuild(
          void Function(ScheduledTaskHealthBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScheduledTaskHealthBuilder toBuilder() =>
      ScheduledTaskHealthBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScheduledTaskHealth &&
        task == other.task &&
        status == other.status &&
        lastOutcome == other.lastOutcome &&
        lastStartedAt == other.lastStartedAt &&
        durationMs == other.durationMs &&
        expectedWithinMinutes == other.expectedWithinMinutes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, task.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, lastOutcome.hashCode);
    _$hash = $jc(_$hash, lastStartedAt.hashCode);
    _$hash = $jc(_$hash, durationMs.hashCode);
    _$hash = $jc(_$hash, expectedWithinMinutes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScheduledTaskHealth')
          ..add('task', task)
          ..add('status', status)
          ..add('lastOutcome', lastOutcome)
          ..add('lastStartedAt', lastStartedAt)
          ..add('durationMs', durationMs)
          ..add('expectedWithinMinutes', expectedWithinMinutes))
        .toString();
  }
}

class ScheduledTaskHealthBuilder
    implements Builder<ScheduledTaskHealth, ScheduledTaskHealthBuilder> {
  _$ScheduledTaskHealth? _$v;

  String? _task;
  String? get task => _$this._task;
  set task(String? task) => _$this._task = task;

  ScheduledTaskHealthStatusEnum? _status;
  ScheduledTaskHealthStatusEnum? get status => _$this._status;
  set status(ScheduledTaskHealthStatusEnum? status) => _$this._status = status;

  String? _lastOutcome;
  String? get lastOutcome => _$this._lastOutcome;
  set lastOutcome(String? lastOutcome) => _$this._lastOutcome = lastOutcome;

  DateTime? _lastStartedAt;
  DateTime? get lastStartedAt => _$this._lastStartedAt;
  set lastStartedAt(DateTime? lastStartedAt) =>
      _$this._lastStartedAt = lastStartedAt;

  int? _durationMs;
  int? get durationMs => _$this._durationMs;
  set durationMs(int? durationMs) => _$this._durationMs = durationMs;

  int? _expectedWithinMinutes;
  int? get expectedWithinMinutes => _$this._expectedWithinMinutes;
  set expectedWithinMinutes(int? expectedWithinMinutes) =>
      _$this._expectedWithinMinutes = expectedWithinMinutes;

  ScheduledTaskHealthBuilder() {
    ScheduledTaskHealth._defaults(this);
  }

  ScheduledTaskHealthBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _task = $v.task;
      _status = $v.status;
      _lastOutcome = $v.lastOutcome;
      _lastStartedAt = $v.lastStartedAt;
      _durationMs = $v.durationMs;
      _expectedWithinMinutes = $v.expectedWithinMinutes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScheduledTaskHealth other) {
    _$v = other as _$ScheduledTaskHealth;
  }

  @override
  void update(void Function(ScheduledTaskHealthBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScheduledTaskHealth build() => _build();

  _$ScheduledTaskHealth _build() {
    final _$result = _$v ??
        _$ScheduledTaskHealth._(
          task: BuiltValueNullFieldError.checkNotNull(
              task, r'ScheduledTaskHealth', 'task'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ScheduledTaskHealth', 'status'),
          lastOutcome: lastOutcome,
          lastStartedAt: lastStartedAt,
          durationMs: durationMs,
          expectedWithinMinutes: BuiltValueNullFieldError.checkNotNull(
              expectedWithinMinutes,
              r'ScheduledTaskHealth',
              'expectedWithinMinutes'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
