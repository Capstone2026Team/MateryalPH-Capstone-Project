//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_timeline_actor.g.dart';

/// DisputeTimelineActor
///
/// Properties:
/// * [party]
/// * [role]
/// * [displayName]
@BuiltValue()
abstract class DisputeTimelineActor implements Built<DisputeTimelineActor, DisputeTimelineActorBuilder> {
  @BuiltValueField(wireName: r'party')
  DisputeTimelineActorPartyEnum get party;
  // enum partyEnum {  BUYER,  VENDOR,  ADMIN,  SYSTEM,  };

  @BuiltValueField(wireName: r'role')
  String? get role;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  DisputeTimelineActor._();

  factory DisputeTimelineActor([void updates(DisputeTimelineActorBuilder b)]) = _$DisputeTimelineActor;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeTimelineActorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeTimelineActor> get serializer => _$DisputeTimelineActorSerializer();
}

class _$DisputeTimelineActorSerializer implements PrimitiveSerializer<DisputeTimelineActor> {
  @override
  final Iterable<Type> types = const [DisputeTimelineActor, _$DisputeTimelineActor];

  @override
  final String wireName = r'DisputeTimelineActor';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeTimelineActor object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'party';
    yield serializers.serialize(
      object.party,
      specifiedType: const FullType(DisputeTimelineActorPartyEnum),
    );
    if (object.role != null) {
      yield r'role';
      yield serializers.serialize(
        object.role,
        specifiedType: const FullType(String),
      );
    }
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeTimelineActor object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeTimelineActorBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'party':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeTimelineActorPartyEnum),
          ) as DisputeTimelineActorPartyEnum;
          result.party = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.role = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeTimelineActor deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeTimelineActorBuilder();
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


class DisputeTimelineActorPartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const DisputeTimelineActorPartyEnum BUYER = _$disputeTimelineActorPartyEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const DisputeTimelineActorPartyEnum VENDOR = _$disputeTimelineActorPartyEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const DisputeTimelineActorPartyEnum ADMIN = _$disputeTimelineActorPartyEnum_ADMIN;
  @BuiltValueEnumConst(wireName: r'SYSTEM')
  static const DisputeTimelineActorPartyEnum SYSTEM = _$disputeTimelineActorPartyEnum_SYSTEM;

  static Serializer<DisputeTimelineActorPartyEnum> get serializer => _$disputeTimelineActorPartyEnumSerializer;

  const DisputeTimelineActorPartyEnum._(String name): super(name);

  static BuiltSet<DisputeTimelineActorPartyEnum> get values => _$disputeTimelineActorPartyEnumValues;
  static DisputeTimelineActorPartyEnum valueOf(String name) => _$disputeTimelineActorPartyEnumValueOf(name);
}

