//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_deadline.g.dart';

/// An exact stored instant for a countdown plus its Asia/Manila date and time label.
///
/// Properties:
/// * [kind]
/// * [at]
/// * [responsibleParty]
/// * [label]
@BuiltValue()
abstract class DisputeDeadline implements Built<DisputeDeadline, DisputeDeadlineBuilder> {
  @BuiltValueField(wireName: r'kind')
  DisputeDeadlineKindEnum get kind;
  // enum kindEnum {  RESPONSE,  MUTUAL_RESOLUTION,  CLARIFICATION,  APPEAL,  };

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'responsible_party')
  DisputeDeadlineResponsiblePartyEnum get responsibleParty;
  // enum responsiblePartyEnum {  BUYER,  VENDOR,  BOTH,  REQUESTED_PARTY,  EITHER,  };

  @BuiltValueField(wireName: r'label')
  String get label;

  DisputeDeadline._();

  factory DisputeDeadline([void updates(DisputeDeadlineBuilder b)]) = _$DisputeDeadline;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeDeadlineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeDeadline> get serializer => _$DisputeDeadlineSerializer();
}

class _$DisputeDeadlineSerializer implements PrimitiveSerializer<DisputeDeadline> {
  @override
  final Iterable<Type> types = const [DisputeDeadline, _$DisputeDeadline];

  @override
  final String wireName = r'DisputeDeadline';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeDeadline object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(DisputeDeadlineKindEnum),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'responsible_party';
    yield serializers.serialize(
      object.responsibleParty,
      specifiedType: const FullType(DisputeDeadlineResponsiblePartyEnum),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeDeadline object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeDeadlineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDeadlineKindEnum),
          ) as DisputeDeadlineKindEnum;
          result.kind = valueDes;
          break;
        case r'at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.at = valueDes;
          break;
        case r'responsible_party':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDeadlineResponsiblePartyEnum),
          ) as DisputeDeadlineResponsiblePartyEnum;
          result.responsibleParty = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeDeadline deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeDeadlineBuilder();
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


class DisputeDeadlineKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RESPONSE')
  static const DisputeDeadlineKindEnum RESPONSE = _$disputeDeadlineKindEnum_RESPONSE;
  @BuiltValueEnumConst(wireName: r'MUTUAL_RESOLUTION')
  static const DisputeDeadlineKindEnum MUTUAL_RESOLUTION = _$disputeDeadlineKindEnum_MUTUAL_RESOLUTION;
  @BuiltValueEnumConst(wireName: r'CLARIFICATION')
  static const DisputeDeadlineKindEnum CLARIFICATION = _$disputeDeadlineKindEnum_CLARIFICATION;
  @BuiltValueEnumConst(wireName: r'APPEAL')
  static const DisputeDeadlineKindEnum APPEAL = _$disputeDeadlineKindEnum_APPEAL;

  static Serializer<DisputeDeadlineKindEnum> get serializer => _$disputeDeadlineKindEnumSerializer;

  const DisputeDeadlineKindEnum._(String name): super(name);

  static BuiltSet<DisputeDeadlineKindEnum> get values => _$disputeDeadlineKindEnumValues;
  static DisputeDeadlineKindEnum valueOf(String name) => _$disputeDeadlineKindEnumValueOf(name);
}

class DisputeDeadlineResponsiblePartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const DisputeDeadlineResponsiblePartyEnum BUYER = _$disputeDeadlineResponsiblePartyEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const DisputeDeadlineResponsiblePartyEnum VENDOR = _$disputeDeadlineResponsiblePartyEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'BOTH')
  static const DisputeDeadlineResponsiblePartyEnum BOTH = _$disputeDeadlineResponsiblePartyEnum_BOTH;
  @BuiltValueEnumConst(wireName: r'REQUESTED_PARTY')
  static const DisputeDeadlineResponsiblePartyEnum REQUESTED_PARTY = _$disputeDeadlineResponsiblePartyEnum_REQUESTED_PARTY;
  @BuiltValueEnumConst(wireName: r'EITHER')
  static const DisputeDeadlineResponsiblePartyEnum EITHER = _$disputeDeadlineResponsiblePartyEnum_EITHER;

  static Serializer<DisputeDeadlineResponsiblePartyEnum> get serializer => _$disputeDeadlineResponsiblePartyEnumSerializer;

  const DisputeDeadlineResponsiblePartyEnum._(String name): super(name);

  static BuiltSet<DisputeDeadlineResponsiblePartyEnum> get values => _$disputeDeadlineResponsiblePartyEnumValues;
  static DisputeDeadlineResponsiblePartyEnum valueOf(String name) => _$disputeDeadlineResponsiblePartyEnumValueOf(name);
}

