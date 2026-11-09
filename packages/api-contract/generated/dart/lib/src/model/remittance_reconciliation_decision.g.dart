// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remittance_reconciliation_decision.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RemittanceReconciliationDecisionEnvironmentEnum
    _$remittanceReconciliationDecisionEnvironmentEnum_TEST =
    const RemittanceReconciliationDecisionEnvironmentEnum._('TEST');

RemittanceReconciliationDecisionEnvironmentEnum
    _$remittanceReconciliationDecisionEnvironmentEnumValueOf(String name) {
  switch (name) {
    case 'TEST':
      return _$remittanceReconciliationDecisionEnvironmentEnum_TEST;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RemittanceReconciliationDecisionEnvironmentEnum>
    _$remittanceReconciliationDecisionEnvironmentEnumValues = BuiltSet<
        RemittanceReconciliationDecisionEnvironmentEnum>(const <RemittanceReconciliationDecisionEnvironmentEnum>[
  _$remittanceReconciliationDecisionEnvironmentEnum_TEST,
]);

const RemittanceReconciliationDecisionOriginEnum
    _$remittanceReconciliationDecisionOriginEnum_SIMULATED =
    const RemittanceReconciliationDecisionOriginEnum._('SIMULATED');

RemittanceReconciliationDecisionOriginEnum
    _$remittanceReconciliationDecisionOriginEnumValueOf(String name) {
  switch (name) {
    case 'SIMULATED':
      return _$remittanceReconciliationDecisionOriginEnum_SIMULATED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RemittanceReconciliationDecisionOriginEnum>
    _$remittanceReconciliationDecisionOriginEnumValues = BuiltSet<
        RemittanceReconciliationDecisionOriginEnum>(const <RemittanceReconciliationDecisionOriginEnum>[
  _$remittanceReconciliationDecisionOriginEnum_SIMULATED,
]);

const RemittanceReconciliationDecisionMethodEnum
    _$remittanceReconciliationDecisionMethodEnum_AUTOMATIC =
    const RemittanceReconciliationDecisionMethodEnum._('AUTOMATIC');
const RemittanceReconciliationDecisionMethodEnum
    _$remittanceReconciliationDecisionMethodEnum_BACKUP_APPROVAL =
    const RemittanceReconciliationDecisionMethodEnum._('BACKUP_APPROVAL');

RemittanceReconciliationDecisionMethodEnum
    _$remittanceReconciliationDecisionMethodEnumValueOf(String name) {
  switch (name) {
    case 'AUTOMATIC':
      return _$remittanceReconciliationDecisionMethodEnum_AUTOMATIC;
    case 'BACKUP_APPROVAL':
      return _$remittanceReconciliationDecisionMethodEnum_BACKUP_APPROVAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RemittanceReconciliationDecisionMethodEnum>
    _$remittanceReconciliationDecisionMethodEnumValues = BuiltSet<
        RemittanceReconciliationDecisionMethodEnum>(const <RemittanceReconciliationDecisionMethodEnum>[
  _$remittanceReconciliationDecisionMethodEnum_AUTOMATIC,
  _$remittanceReconciliationDecisionMethodEnum_BACKUP_APPROVAL,
]);

const RemittanceReconciliationDecisionActorRoleEnum
    _$remittanceReconciliationDecisionActorRoleEnum_SYSTEM =
    const RemittanceReconciliationDecisionActorRoleEnum._('SYSTEM');
const RemittanceReconciliationDecisionActorRoleEnum
    _$remittanceReconciliationDecisionActorRoleEnum_ADMIN_SUPERADMIN =
    const RemittanceReconciliationDecisionActorRoleEnum._('ADMIN_SUPERADMIN');
const RemittanceReconciliationDecisionActorRoleEnum
    _$remittanceReconciliationDecisionActorRoleEnum_ADMIN_FINANCE =
    const RemittanceReconciliationDecisionActorRoleEnum._('ADMIN_FINANCE');

RemittanceReconciliationDecisionActorRoleEnum
    _$remittanceReconciliationDecisionActorRoleEnumValueOf(String name) {
  switch (name) {
    case 'SYSTEM':
      return _$remittanceReconciliationDecisionActorRoleEnum_SYSTEM;
    case 'ADMIN_SUPERADMIN':
      return _$remittanceReconciliationDecisionActorRoleEnum_ADMIN_SUPERADMIN;
    case 'ADMIN_FINANCE':
      return _$remittanceReconciliationDecisionActorRoleEnum_ADMIN_FINANCE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RemittanceReconciliationDecisionActorRoleEnum>
    _$remittanceReconciliationDecisionActorRoleEnumValues = BuiltSet<
        RemittanceReconciliationDecisionActorRoleEnum>(const <RemittanceReconciliationDecisionActorRoleEnum>[
  _$remittanceReconciliationDecisionActorRoleEnum_SYSTEM,
  _$remittanceReconciliationDecisionActorRoleEnum_ADMIN_SUPERADMIN,
  _$remittanceReconciliationDecisionActorRoleEnum_ADMIN_FINANCE,
]);

Serializer<RemittanceReconciliationDecisionEnvironmentEnum>
    _$remittanceReconciliationDecisionEnvironmentEnumSerializer =
    _$RemittanceReconciliationDecisionEnvironmentEnumSerializer();
Serializer<RemittanceReconciliationDecisionOriginEnum>
    _$remittanceReconciliationDecisionOriginEnumSerializer =
    _$RemittanceReconciliationDecisionOriginEnumSerializer();
Serializer<RemittanceReconciliationDecisionMethodEnum>
    _$remittanceReconciliationDecisionMethodEnumSerializer =
    _$RemittanceReconciliationDecisionMethodEnumSerializer();
Serializer<RemittanceReconciliationDecisionActorRoleEnum>
    _$remittanceReconciliationDecisionActorRoleEnumSerializer =
    _$RemittanceReconciliationDecisionActorRoleEnumSerializer();

class _$RemittanceReconciliationDecisionEnvironmentEnumSerializer
    implements
        PrimitiveSerializer<RemittanceReconciliationDecisionEnvironmentEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TEST': 'TEST',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TEST': 'TEST',
  };

  @override
  final Iterable<Type> types = const <Type>[
    RemittanceReconciliationDecisionEnvironmentEnum
  ];
  @override
  final String wireName = 'RemittanceReconciliationDecisionEnvironmentEnum';

  @override
  Object serialize(Serializers serializers,
          RemittanceReconciliationDecisionEnvironmentEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RemittanceReconciliationDecisionEnvironmentEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RemittanceReconciliationDecisionEnvironmentEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RemittanceReconciliationDecisionOriginEnumSerializer
    implements PrimitiveSerializer<RemittanceReconciliationDecisionOriginEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SIMULATED': 'SIMULATED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SIMULATED': 'SIMULATED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    RemittanceReconciliationDecisionOriginEnum
  ];
  @override
  final String wireName = 'RemittanceReconciliationDecisionOriginEnum';

  @override
  Object serialize(Serializers serializers,
          RemittanceReconciliationDecisionOriginEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RemittanceReconciliationDecisionOriginEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RemittanceReconciliationDecisionOriginEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RemittanceReconciliationDecisionMethodEnumSerializer
    implements PrimitiveSerializer<RemittanceReconciliationDecisionMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AUTOMATIC': 'AUTOMATIC',
    'BACKUP_APPROVAL': 'BACKUP_APPROVAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AUTOMATIC': 'AUTOMATIC',
    'BACKUP_APPROVAL': 'BACKUP_APPROVAL',
  };

  @override
  final Iterable<Type> types = const <Type>[
    RemittanceReconciliationDecisionMethodEnum
  ];
  @override
  final String wireName = 'RemittanceReconciliationDecisionMethodEnum';

  @override
  Object serialize(Serializers serializers,
          RemittanceReconciliationDecisionMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RemittanceReconciliationDecisionMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RemittanceReconciliationDecisionMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RemittanceReconciliationDecisionActorRoleEnumSerializer
    implements
        PrimitiveSerializer<RemittanceReconciliationDecisionActorRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SYSTEM': 'SYSTEM',
    'ADMIN_SUPERADMIN': 'ADMIN_SUPERADMIN',
    'ADMIN_FINANCE': 'ADMIN_FINANCE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SYSTEM': 'SYSTEM',
    'ADMIN_SUPERADMIN': 'ADMIN_SUPERADMIN',
    'ADMIN_FINANCE': 'ADMIN_FINANCE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    RemittanceReconciliationDecisionActorRoleEnum
  ];
  @override
  final String wireName = 'RemittanceReconciliationDecisionActorRoleEnum';

  @override
  Object serialize(Serializers serializers,
          RemittanceReconciliationDecisionActorRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RemittanceReconciliationDecisionActorRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RemittanceReconciliationDecisionActorRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RemittanceReconciliationDecision
    extends RemittanceReconciliationDecision {
  @override
  final String id;
  @override
  final String assessmentId;
  @override
  final RemittanceReconciliationDecisionEnvironmentEnum environment;
  @override
  final RemittanceReconciliationDecisionOriginEnum origin;
  @override
  final RemittanceReconciliationDecisionMethodEnum method;
  @override
  final RemittanceReconciliationDecisionActorRoleEnum actorRole;
  @override
  final String reason;
  @override
  final DateTime reconciledAt;

  factory _$RemittanceReconciliationDecision(
          [void Function(RemittanceReconciliationDecisionBuilder)? updates]) =>
      (RemittanceReconciliationDecisionBuilder()..update(updates))._build();

  _$RemittanceReconciliationDecision._(
      {required this.id,
      required this.assessmentId,
      required this.environment,
      required this.origin,
      required this.method,
      required this.actorRole,
      required this.reason,
      required this.reconciledAt})
      : super._();
  @override
  RemittanceReconciliationDecision rebuild(
          void Function(RemittanceReconciliationDecisionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RemittanceReconciliationDecisionBuilder toBuilder() =>
      RemittanceReconciliationDecisionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RemittanceReconciliationDecision &&
        id == other.id &&
        assessmentId == other.assessmentId &&
        environment == other.environment &&
        origin == other.origin &&
        method == other.method &&
        actorRole == other.actorRole &&
        reason == other.reason &&
        reconciledAt == other.reconciledAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, assessmentId.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, origin.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, actorRole.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, reconciledAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RemittanceReconciliationDecision')
          ..add('id', id)
          ..add('assessmentId', assessmentId)
          ..add('environment', environment)
          ..add('origin', origin)
          ..add('method', method)
          ..add('actorRole', actorRole)
          ..add('reason', reason)
          ..add('reconciledAt', reconciledAt))
        .toString();
  }
}

class RemittanceReconciliationDecisionBuilder
    implements
        Builder<RemittanceReconciliationDecision,
            RemittanceReconciliationDecisionBuilder> {
  _$RemittanceReconciliationDecision? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _assessmentId;
  String? get assessmentId => _$this._assessmentId;
  set assessmentId(String? assessmentId) => _$this._assessmentId = assessmentId;

  RemittanceReconciliationDecisionEnvironmentEnum? _environment;
  RemittanceReconciliationDecisionEnvironmentEnum? get environment =>
      _$this._environment;
  set environment(
          RemittanceReconciliationDecisionEnvironmentEnum? environment) =>
      _$this._environment = environment;

  RemittanceReconciliationDecisionOriginEnum? _origin;
  RemittanceReconciliationDecisionOriginEnum? get origin => _$this._origin;
  set origin(RemittanceReconciliationDecisionOriginEnum? origin) =>
      _$this._origin = origin;

  RemittanceReconciliationDecisionMethodEnum? _method;
  RemittanceReconciliationDecisionMethodEnum? get method => _$this._method;
  set method(RemittanceReconciliationDecisionMethodEnum? method) =>
      _$this._method = method;

  RemittanceReconciliationDecisionActorRoleEnum? _actorRole;
  RemittanceReconciliationDecisionActorRoleEnum? get actorRole =>
      _$this._actorRole;
  set actorRole(RemittanceReconciliationDecisionActorRoleEnum? actorRole) =>
      _$this._actorRole = actorRole;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _reconciledAt;
  DateTime? get reconciledAt => _$this._reconciledAt;
  set reconciledAt(DateTime? reconciledAt) =>
      _$this._reconciledAt = reconciledAt;

  RemittanceReconciliationDecisionBuilder() {
    RemittanceReconciliationDecision._defaults(this);
  }

  RemittanceReconciliationDecisionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _assessmentId = $v.assessmentId;
      _environment = $v.environment;
      _origin = $v.origin;
      _method = $v.method;
      _actorRole = $v.actorRole;
      _reason = $v.reason;
      _reconciledAt = $v.reconciledAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RemittanceReconciliationDecision other) {
    _$v = other as _$RemittanceReconciliationDecision;
  }

  @override
  void update(void Function(RemittanceReconciliationDecisionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RemittanceReconciliationDecision build() => _build();

  _$RemittanceReconciliationDecision _build() {
    final _$result = _$v ??
        _$RemittanceReconciliationDecision._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'RemittanceReconciliationDecision', 'id'),
          assessmentId: BuiltValueNullFieldError.checkNotNull(assessmentId,
              r'RemittanceReconciliationDecision', 'assessmentId'),
          environment: BuiltValueNullFieldError.checkNotNull(
              environment, r'RemittanceReconciliationDecision', 'environment'),
          origin: BuiltValueNullFieldError.checkNotNull(
              origin, r'RemittanceReconciliationDecision', 'origin'),
          method: BuiltValueNullFieldError.checkNotNull(
              method, r'RemittanceReconciliationDecision', 'method'),
          actorRole: BuiltValueNullFieldError.checkNotNull(
              actorRole, r'RemittanceReconciliationDecision', 'actorRole'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'RemittanceReconciliationDecision', 'reason'),
          reconciledAt: BuiltValueNullFieldError.checkNotNull(reconciledAt,
              r'RemittanceReconciliationDecision', 'reconciledAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
