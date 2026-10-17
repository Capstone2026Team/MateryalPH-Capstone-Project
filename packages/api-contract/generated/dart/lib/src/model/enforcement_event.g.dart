// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enforcement_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EnforcementEventEventEnum _$enforcementEventEventEnum_RECORDED =
    const EnforcementEventEventEnum._('RECORDED');
const EnforcementEventEventEnum _$enforcementEventEventEnum_REFERRED =
    const EnforcementEventEventEnum._('REFERRED');
const EnforcementEventEventEnum _$enforcementEventEventEnum_APPLIED =
    const EnforcementEventEventEnum._('APPLIED');
const EnforcementEventEventEnum _$enforcementEventEventEnum_DECLINED =
    const EnforcementEventEventEnum._('DECLINED');
const EnforcementEventEventEnum _$enforcementEventEventEnum_LIFTED =
    const EnforcementEventEventEnum._('LIFTED');
const EnforcementEventEventEnum _$enforcementEventEventEnum_EXPIRED =
    const EnforcementEventEventEnum._('EXPIRED');
const EnforcementEventEventEnum _$enforcementEventEventEnum_SUPERSEDED =
    const EnforcementEventEventEnum._('SUPERSEDED');

EnforcementEventEventEnum _$enforcementEventEventEnumValueOf(String name) {
  switch (name) {
    case 'RECORDED':
      return _$enforcementEventEventEnum_RECORDED;
    case 'REFERRED':
      return _$enforcementEventEventEnum_REFERRED;
    case 'APPLIED':
      return _$enforcementEventEventEnum_APPLIED;
    case 'DECLINED':
      return _$enforcementEventEventEnum_DECLINED;
    case 'LIFTED':
      return _$enforcementEventEventEnum_LIFTED;
    case 'EXPIRED':
      return _$enforcementEventEventEnum_EXPIRED;
    case 'SUPERSEDED':
      return _$enforcementEventEventEnum_SUPERSEDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EnforcementEventEventEnum> _$enforcementEventEventEnumValues =
    BuiltSet<EnforcementEventEventEnum>(const <EnforcementEventEventEnum>[
  _$enforcementEventEventEnum_RECORDED,
  _$enforcementEventEventEnum_REFERRED,
  _$enforcementEventEventEnum_APPLIED,
  _$enforcementEventEventEnum_DECLINED,
  _$enforcementEventEventEnum_LIFTED,
  _$enforcementEventEventEnum_EXPIRED,
  _$enforcementEventEventEnum_SUPERSEDED,
]);

Serializer<EnforcementEventEventEnum> _$enforcementEventEventEnumSerializer =
    _$EnforcementEventEventEnumSerializer();

class _$EnforcementEventEventEnumSerializer
    implements PrimitiveSerializer<EnforcementEventEventEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RECORDED': 'RECORDED',
    'REFERRED': 'REFERRED',
    'APPLIED': 'APPLIED',
    'DECLINED': 'DECLINED',
    'LIFTED': 'LIFTED',
    'EXPIRED': 'EXPIRED',
    'SUPERSEDED': 'SUPERSEDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RECORDED': 'RECORDED',
    'REFERRED': 'REFERRED',
    'APPLIED': 'APPLIED',
    'DECLINED': 'DECLINED',
    'LIFTED': 'LIFTED',
    'EXPIRED': 'EXPIRED',
    'SUPERSEDED': 'SUPERSEDED',
  };

  @override
  final Iterable<Type> types = const <Type>[EnforcementEventEventEnum];
  @override
  final String wireName = 'EnforcementEventEventEnum';

  @override
  Object serialize(Serializers serializers, EnforcementEventEventEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EnforcementEventEventEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EnforcementEventEventEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EnforcementEvent extends EnforcementEvent {
  @override
  final EnforcementEventEventEnum event;
  @override
  final String? fromState;
  @override
  final String toState;
  @override
  final BuiltMap<String, JsonObject?>? before;
  @override
  final BuiltMap<String, JsonObject?>? after;
  @override
  final String reason;
  @override
  final String actor;
  @override
  final String actorRole;
  @override
  final String correlationId;
  @override
  final DateTime occurredAt;

  factory _$EnforcementEvent(
          [void Function(EnforcementEventBuilder)? updates]) =>
      (EnforcementEventBuilder()..update(updates))._build();

  _$EnforcementEvent._(
      {required this.event,
      this.fromState,
      required this.toState,
      this.before,
      this.after,
      required this.reason,
      required this.actor,
      required this.actorRole,
      required this.correlationId,
      required this.occurredAt})
      : super._();
  @override
  EnforcementEvent rebuild(void Function(EnforcementEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EnforcementEventBuilder toBuilder() =>
      EnforcementEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnforcementEvent &&
        event == other.event &&
        fromState == other.fromState &&
        toState == other.toState &&
        before == other.before &&
        after == other.after &&
        reason == other.reason &&
        actor == other.actor &&
        actorRole == other.actorRole &&
        correlationId == other.correlationId &&
        occurredAt == other.occurredAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, event.hashCode);
    _$hash = $jc(_$hash, fromState.hashCode);
    _$hash = $jc(_$hash, toState.hashCode);
    _$hash = $jc(_$hash, before.hashCode);
    _$hash = $jc(_$hash, after.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, actor.hashCode);
    _$hash = $jc(_$hash, actorRole.hashCode);
    _$hash = $jc(_$hash, correlationId.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EnforcementEvent')
          ..add('event', event)
          ..add('fromState', fromState)
          ..add('toState', toState)
          ..add('before', before)
          ..add('after', after)
          ..add('reason', reason)
          ..add('actor', actor)
          ..add('actorRole', actorRole)
          ..add('correlationId', correlationId)
          ..add('occurredAt', occurredAt))
        .toString();
  }
}

class EnforcementEventBuilder
    implements Builder<EnforcementEvent, EnforcementEventBuilder> {
  _$EnforcementEvent? _$v;

  EnforcementEventEventEnum? _event;
  EnforcementEventEventEnum? get event => _$this._event;
  set event(EnforcementEventEventEnum? event) => _$this._event = event;

  String? _fromState;
  String? get fromState => _$this._fromState;
  set fromState(String? fromState) => _$this._fromState = fromState;

  String? _toState;
  String? get toState => _$this._toState;
  set toState(String? toState) => _$this._toState = toState;

  MapBuilder<String, JsonObject?>? _before;
  MapBuilder<String, JsonObject?> get before =>
      _$this._before ??= MapBuilder<String, JsonObject?>();
  set before(MapBuilder<String, JsonObject?>? before) =>
      _$this._before = before;

  MapBuilder<String, JsonObject?>? _after;
  MapBuilder<String, JsonObject?> get after =>
      _$this._after ??= MapBuilder<String, JsonObject?>();
  set after(MapBuilder<String, JsonObject?>? after) => _$this._after = after;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _actor;
  String? get actor => _$this._actor;
  set actor(String? actor) => _$this._actor = actor;

  String? _actorRole;
  String? get actorRole => _$this._actorRole;
  set actorRole(String? actorRole) => _$this._actorRole = actorRole;

  String? _correlationId;
  String? get correlationId => _$this._correlationId;
  set correlationId(String? correlationId) =>
      _$this._correlationId = correlationId;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  EnforcementEventBuilder() {
    EnforcementEvent._defaults(this);
  }

  EnforcementEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _event = $v.event;
      _fromState = $v.fromState;
      _toState = $v.toState;
      _before = $v.before?.toBuilder();
      _after = $v.after?.toBuilder();
      _reason = $v.reason;
      _actor = $v.actor;
      _actorRole = $v.actorRole;
      _correlationId = $v.correlationId;
      _occurredAt = $v.occurredAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EnforcementEvent other) {
    _$v = other as _$EnforcementEvent;
  }

  @override
  void update(void Function(EnforcementEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnforcementEvent build() => _build();

  _$EnforcementEvent _build() {
    _$EnforcementEvent _$result;
    try {
      _$result = _$v ??
          _$EnforcementEvent._(
            event: BuiltValueNullFieldError.checkNotNull(
                event, r'EnforcementEvent', 'event'),
            fromState: fromState,
            toState: BuiltValueNullFieldError.checkNotNull(
                toState, r'EnforcementEvent', 'toState'),
            before: _before?.build(),
            after: _after?.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'EnforcementEvent', 'reason'),
            actor: BuiltValueNullFieldError.checkNotNull(
                actor, r'EnforcementEvent', 'actor'),
            actorRole: BuiltValueNullFieldError.checkNotNull(
                actorRole, r'EnforcementEvent', 'actorRole'),
            correlationId: BuiltValueNullFieldError.checkNotNull(
                correlationId, r'EnforcementEvent', 'correlationId'),
            occurredAt: BuiltValueNullFieldError.checkNotNull(
                occurredAt, r'EnforcementEvent', 'occurredAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'before';
        _before?.build();
        _$failedField = 'after';
        _after?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'EnforcementEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
