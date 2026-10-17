//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'privacy_request_event.g.dart';

/// PrivacyRequestEvent
///
/// Properties:
/// * [event]
/// * [fromState]
/// * [toState]
/// * [note]
/// * [actor]
/// * [actorRole]
/// * [correlationId]
/// * [occurredAt]
@BuiltValue()
abstract class PrivacyRequestEvent implements Built<PrivacyRequestEvent, PrivacyRequestEventBuilder> {
  @BuiltValueField(wireName: r'event')
  String get event;

  @BuiltValueField(wireName: r'from_state')
  String? get fromState;

  @BuiltValueField(wireName: r'to_state')
  String get toState;

  @BuiltValueField(wireName: r'note')
  String get note;

  @BuiltValueField(wireName: r'actor')
  String get actor;

  @BuiltValueField(wireName: r'actor_role')
  String get actorRole;

  @BuiltValueField(wireName: r'correlation_id')
  String get correlationId;

  @BuiltValueField(wireName: r'occurred_at')
  DateTime get occurredAt;

  PrivacyRequestEvent._();

  factory PrivacyRequestEvent([void updates(PrivacyRequestEventBuilder b)]) = _$PrivacyRequestEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PrivacyRequestEventBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PrivacyRequestEvent> get serializer => _$PrivacyRequestEventSerializer();
}

class _$PrivacyRequestEventSerializer implements PrimitiveSerializer<PrivacyRequestEvent> {
  @override
  final Iterable<Type> types = const [PrivacyRequestEvent, _$PrivacyRequestEvent];

  @override
  final String wireName = r'PrivacyRequestEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PrivacyRequestEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'event';
    yield serializers.serialize(
      object.event,
      specifiedType: const FullType(String),
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
    yield r'note';
    yield serializers.serialize(
      object.note,
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
    PrivacyRequestEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PrivacyRequestEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'event':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
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
  PrivacyRequestEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PrivacyRequestEventBuilder();
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


