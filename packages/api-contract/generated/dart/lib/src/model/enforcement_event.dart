//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'enforcement_event.g.dart';

/// EnforcementEvent
///
/// Properties:
/// * [event]
/// * [fromState]
/// * [toState]
/// * [before]
/// * [after]
/// * [reason]
/// * [actor]
/// * [actorRole]
/// * [correlationId]
/// * [occurredAt]
@BuiltValue()
abstract class EnforcementEvent implements Built<EnforcementEvent, EnforcementEventBuilder> {
  @BuiltValueField(wireName: r'event')
  EnforcementEventEventEnum get event;
  // enum eventEnum {  RECORDED,  REFERRED,  APPLIED,  DECLINED,  LIFTED,  EXPIRED,  SUPERSEDED,  };

  @BuiltValueField(wireName: r'from_state')
  String? get fromState;

  @BuiltValueField(wireName: r'to_state')
  String get toState;

  @BuiltValueField(wireName: r'before')
  BuiltMap<String, JsonObject?>? get before;

  @BuiltValueField(wireName: r'after')
  BuiltMap<String, JsonObject?>? get after;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'actor')
  String get actor;

  @BuiltValueField(wireName: r'actor_role')
  String get actorRole;

  @BuiltValueField(wireName: r'correlation_id')
  String get correlationId;

  @BuiltValueField(wireName: r'occurred_at')
  DateTime get occurredAt;

  EnforcementEvent._();

  factory EnforcementEvent([void updates(EnforcementEventBuilder b)]) = _$EnforcementEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EnforcementEventBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnforcementEvent> get serializer => _$EnforcementEventSerializer();
}

class _$EnforcementEventSerializer implements PrimitiveSerializer<EnforcementEvent> {
  @override
  final Iterable<Type> types = const [EnforcementEvent, _$EnforcementEvent];

  @override
  final String wireName = r'EnforcementEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EnforcementEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'event';
    yield serializers.serialize(
      object.event,
      specifiedType: const FullType(EnforcementEventEventEnum),
    );
    if (object.fromState != null) {
      yield r'from_state';
      yield serializers.serialize(
        object.fromState,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'to_state';
    yield serializers.serialize(
      object.toState,
      specifiedType: const FullType(String),
    );
    if (object.before != null) {
      yield r'before';
      yield serializers.serialize(
        object.before,
        specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.after != null) {
      yield r'after';
      yield serializers.serialize(
        object.after,
        specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'actor';
    yield serializers.serialize(
      object.actor,
      specifiedType: const FullType(String),
    );
    yield r'actor_role';
    yield serializers.serialize(
      object.actorRole,
      specifiedType: const FullType(String),
    );
    yield r'correlation_id';
    yield serializers.serialize(
      object.correlationId,
      specifiedType: const FullType(String),
    );
    yield r'occurred_at';
    yield serializers.serialize(
      object.occurredAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EnforcementEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EnforcementEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'event':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EnforcementEventEventEnum),
          ) as EnforcementEventEventEnum;
          result.event = valueDes;
          break;
        case r'from_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fromState = valueDes;
          break;
        case r'to_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.toState = valueDes;
          break;
        case r'before':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.before.replace(valueDes);
          break;
        case r'after':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.after.replace(valueDes);
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'actor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actor = valueDes;
          break;
        case r'actor_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actorRole = valueDes;
          break;
        case r'correlation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.correlationId = valueDes;
          break;
        case r'occurred_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.occurredAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EnforcementEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EnforcementEventBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


class EnforcementEventEventEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RECORDED')
  static const EnforcementEventEventEnum RECORDED = _$enforcementEventEventEnum_RECORDED;
  @BuiltValueEnumConst(wireName: r'REFERRED')
  static const EnforcementEventEventEnum REFERRED = _$enforcementEventEventEnum_REFERRED;
  @BuiltValueEnumConst(wireName: r'APPLIED')
  static const EnforcementEventEventEnum APPLIED = _$enforcementEventEventEnum_APPLIED;
  @BuiltValueEnumConst(wireName: r'DECLINED')
  static const EnforcementEventEventEnum DECLINED = _$enforcementEventEventEnum_DECLINED;
  @BuiltValueEnumConst(wireName: r'LIFTED')
  static const EnforcementEventEventEnum LIFTED = _$enforcementEventEventEnum_LIFTED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const EnforcementEventEventEnum EXPIRED = _$enforcementEventEventEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'SUPERSEDED')
  static const EnforcementEventEventEnum SUPERSEDED = _$enforcementEventEventEnum_SUPERSEDED;

  static Serializer<EnforcementEventEventEnum> get serializer => _$enforcementEventEventEnumSerializer;

  const EnforcementEventEventEnum._(String name): super(name);

  static BuiltSet<EnforcementEventEventEnum> get values => _$enforcementEventEventEnumValues;
  static EnforcementEventEventEnum valueOf(String name) => _$enforcementEventEventEnumValueOf(name);
}

