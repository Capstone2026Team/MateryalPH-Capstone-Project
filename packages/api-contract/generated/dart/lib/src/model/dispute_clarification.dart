//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_clarification.g.dart';

/// DisputeClarification
///
/// Properties:
/// * [id]
/// * [requestedParty]
/// * [question]
/// * [dueAt]
/// * [state]
/// * [response]
/// * [respondedAt]
/// * [canAnswer]
@BuiltValue()
abstract class DisputeClarification implements Built<DisputeClarification, DisputeClarificationBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'requested_party')
  DisputeClarificationRequestedPartyEnum get requestedParty;
  // enum requestedPartyEnum {  BUYER,  VENDOR,  };

  @BuiltValueField(wireName: r'question')
  String get question;

  @BuiltValueField(wireName: r'due_at')
  DateTime? get dueAt;

  @BuiltValueField(wireName: r'state')
  DisputeClarificationStateEnum get state;
  // enum stateEnum {  OPEN,  ANSWERED,  EXPIRED,  };

  @BuiltValueField(wireName: r'response')
  String? get response;

  @BuiltValueField(wireName: r'responded_at')
  DateTime? get respondedAt;

  @BuiltValueField(wireName: r'can_answer')
  bool get canAnswer;

  DisputeClarification._();

  factory DisputeClarification([void updates(DisputeClarificationBuilder b)]) = _$DisputeClarification;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeClarificationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeClarification> get serializer => _$DisputeClarificationSerializer();
}

class _$DisputeClarificationSerializer implements PrimitiveSerializer<DisputeClarification> {
  @override
  final Iterable<Type> types = const [DisputeClarification, _$DisputeClarification];

  @override
  final String wireName = r'DisputeClarification';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeClarification object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'requested_party';
    yield serializers.serialize(
      object.requestedParty,
      specifiedType: const FullType(DisputeClarificationRequestedPartyEnum),
    );
    yield r'question';
    yield serializers.serialize(
      object.question,
      specifiedType: const FullType(String),
    );
    if (object.dueAt != null) {
      yield r'due_at';
      yield serializers.serialize(
        object.dueAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(DisputeClarificationStateEnum),
    );
    if (object.response != null) {
      yield r'response';
      yield serializers.serialize(
        object.response,
        specifiedType: const FullType(String),
      );
    }
    if (object.respondedAt != null) {
      yield r'responded_at';
      yield serializers.serialize(
        object.respondedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'can_answer';
    yield serializers.serialize(
      object.canAnswer,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeClarification object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeClarificationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'requested_party':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeClarificationRequestedPartyEnum),
          ) as DisputeClarificationRequestedPartyEnum;
          result.requestedParty = valueDes;
          break;
        case r'question':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.question = valueDes;
          break;
        case r'due_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.dueAt = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeClarificationStateEnum),
          ) as DisputeClarificationStateEnum;
          result.state = valueDes;
          break;
        case r'response':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.response = valueDes;
          break;
        case r'responded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.respondedAt = valueDes;
          break;
        case r'can_answer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canAnswer = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeClarification deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeClarificationBuilder();
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


class DisputeClarificationRequestedPartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const DisputeClarificationRequestedPartyEnum BUYER = _$disputeClarificationRequestedPartyEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const DisputeClarificationRequestedPartyEnum VENDOR = _$disputeClarificationRequestedPartyEnum_VENDOR;

  static Serializer<DisputeClarificationRequestedPartyEnum> get serializer => _$disputeClarificationRequestedPartyEnumSerializer;

  const DisputeClarificationRequestedPartyEnum._(String name): super(name);

  static BuiltSet<DisputeClarificationRequestedPartyEnum> get values => _$disputeClarificationRequestedPartyEnumValues;
  static DisputeClarificationRequestedPartyEnum valueOf(String name) => _$disputeClarificationRequestedPartyEnumValueOf(name);
}

class DisputeClarificationStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const DisputeClarificationStateEnum OPEN = _$disputeClarificationStateEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'ANSWERED')
  static const DisputeClarificationStateEnum ANSWERED = _$disputeClarificationStateEnum_ANSWERED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const DisputeClarificationStateEnum EXPIRED = _$disputeClarificationStateEnum_EXPIRED;

  static Serializer<DisputeClarificationStateEnum> get serializer => _$disputeClarificationStateEnumSerializer;

  const DisputeClarificationStateEnum._(String name): super(name);

  static BuiltSet<DisputeClarificationStateEnum> get values => _$disputeClarificationStateEnumValues;
  static DisputeClarificationStateEnum valueOf(String name) => _$disputeClarificationStateEnumValueOf(name);
}

