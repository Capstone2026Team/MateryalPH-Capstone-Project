// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integration_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const IntegrationStatusStatusEnum _$integrationStatusStatusEnum_HEALTHY =
    const IntegrationStatusStatusEnum._('HEALTHY');
const IntegrationStatusStatusEnum _$integrationStatusStatusEnum_DEGRADED =
    const IntegrationStatusStatusEnum._('DEGRADED');
const IntegrationStatusStatusEnum _$integrationStatusStatusEnum_NOT_CONFIGURED =
    const IntegrationStatusStatusEnum._('NOT_CONFIGURED');
const IntegrationStatusStatusEnum _$integrationStatusStatusEnum_SIMULATED =
    const IntegrationStatusStatusEnum._('SIMULATED');

IntegrationStatusStatusEnum _$integrationStatusStatusEnumValueOf(String name) {
  switch (name) {
    case 'HEALTHY':
      return _$integrationStatusStatusEnum_HEALTHY;
    case 'DEGRADED':
      return _$integrationStatusStatusEnum_DEGRADED;
    case 'NOT_CONFIGURED':
      return _$integrationStatusStatusEnum_NOT_CONFIGURED;
    case 'SIMULATED':
      return _$integrationStatusStatusEnum_SIMULATED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<IntegrationStatusStatusEnum>
    _$integrationStatusStatusEnumValues =
    BuiltSet<IntegrationStatusStatusEnum>(const <IntegrationStatusStatusEnum>[
  _$integrationStatusStatusEnum_HEALTHY,
  _$integrationStatusStatusEnum_DEGRADED,
  _$integrationStatusStatusEnum_NOT_CONFIGURED,
  _$integrationStatusStatusEnum_SIMULATED,
]);

Serializer<IntegrationStatusStatusEnum>
    _$integrationStatusStatusEnumSerializer =
    _$IntegrationStatusStatusEnumSerializer();

class _$IntegrationStatusStatusEnumSerializer
    implements PrimitiveSerializer<IntegrationStatusStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'HEALTHY': 'HEALTHY',
    'DEGRADED': 'DEGRADED',
    'NOT_CONFIGURED': 'NOT_CONFIGURED',
    'SIMULATED': 'SIMULATED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'HEALTHY': 'HEALTHY',
    'DEGRADED': 'DEGRADED',
    'NOT_CONFIGURED': 'NOT_CONFIGURED',
    'SIMULATED': 'SIMULATED',
  };

  @override
  final Iterable<Type> types = const <Type>[IntegrationStatusStatusEnum];
  @override
  final String wireName = 'IntegrationStatusStatusEnum';

  @override
  Object serialize(Serializers serializers, IntegrationStatusStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  IntegrationStatusStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      IntegrationStatusStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$IntegrationStatus extends IntegrationStatus {
  @override
  final String key;
  @override
  final String label;
  @override
  final IntegrationStatusStatusEnum status;
  @override
  final String detail;
  @override
  final String? environment;
  @override
  final DateTime? lastEventAt;

  factory _$IntegrationStatus(
          [void Function(IntegrationStatusBuilder)? updates]) =>
      (IntegrationStatusBuilder()..update(updates))._build();

  _$IntegrationStatus._(
      {required this.key,
      required this.label,
      required this.status,
      required this.detail,
      this.environment,
      this.lastEventAt})
      : super._();
  @override
  IntegrationStatus rebuild(void Function(IntegrationStatusBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IntegrationStatusBuilder toBuilder() =>
      IntegrationStatusBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IntegrationStatus &&
        key == other.key &&
        label == other.label &&
        status == other.status &&
        detail == other.detail &&
        environment == other.environment &&
        lastEventAt == other.lastEventAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, detail.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, lastEventAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IntegrationStatus')
          ..add('key', key)
          ..add('label', label)
          ..add('status', status)
          ..add('detail', detail)
          ..add('environment', environment)
          ..add('lastEventAt', lastEventAt))
        .toString();
  }
}

class IntegrationStatusBuilder
    implements Builder<IntegrationStatus, IntegrationStatusBuilder> {
  _$IntegrationStatus? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  IntegrationStatusStatusEnum? _status;
  IntegrationStatusStatusEnum? get status => _$this._status;
  set status(IntegrationStatusStatusEnum? status) => _$this._status = status;

  String? _detail;
  String? get detail => _$this._detail;
  set detail(String? detail) => _$this._detail = detail;

  String? _environment;
  String? get environment => _$this._environment;
  set environment(String? environment) => _$this._environment = environment;

  DateTime? _lastEventAt;
  DateTime? get lastEventAt => _$this._lastEventAt;
  set lastEventAt(DateTime? lastEventAt) => _$this._lastEventAt = lastEventAt;

  IntegrationStatusBuilder() {
    IntegrationStatus._defaults(this);
  }

  IntegrationStatusBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _label = $v.label;
      _status = $v.status;
      _detail = $v.detail;
      _environment = $v.environment;
      _lastEventAt = $v.lastEventAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IntegrationStatus other) {
    _$v = other as _$IntegrationStatus;
  }

  @override
  void update(void Function(IntegrationStatusBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IntegrationStatus build() => _build();

  _$IntegrationStatus _build() {
    final _$result = _$v ??
        _$IntegrationStatus._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'IntegrationStatus', 'key'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'IntegrationStatus', 'label'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'IntegrationStatus', 'status'),
          detail: BuiltValueNullFieldError.checkNotNull(
              detail, r'IntegrationStatus', 'detail'),
          environment: environment,
          lastEventAt: lastEventAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
