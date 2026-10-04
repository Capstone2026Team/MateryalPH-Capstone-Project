//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_proposal.g.dart';

/// DisputeProposal
///
/// Properties:
/// * [id]
/// * [proposedByParty]
/// * [remedy]
/// * [amountCentavos]
/// * [terms]
/// * [state]
/// * [proposedAt]
/// * [answeredAt]
/// * [canAnswer]
@BuiltValue()
abstract class DisputeProposal implements Built<DisputeProposal, DisputeProposalBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'proposed_by_party')
  DisputeProposalProposedByPartyEnum get proposedByParty;
  // enum proposedByPartyEnum {  BUYER,  VENDOR,  };

  @BuiltValueField(wireName: r'remedy')
  DisputeProposalRemedyEnum get remedy;
  // enum remedyEnum {  REPLACEMENT,  FULL_REFUND,  PARTIAL_REFUND,  NO_FURTHER_ACTION,  };

  @BuiltValueField(wireName: r'amount_centavos')
  int? get amountCentavos;

  @BuiltValueField(wireName: r'terms')
  String get terms;

  @BuiltValueField(wireName: r'state')
  DisputeProposalStateEnum get state;
  // enum stateEnum {  PROPOSED,  ACCEPTED,  REJECTED,  SUPERSEDED,  EXPIRED,  };

  @BuiltValueField(wireName: r'proposed_at')
  DateTime? get proposedAt;

  @BuiltValueField(wireName: r'answered_at')
  DateTime? get answeredAt;

  @BuiltValueField(wireName: r'can_answer')
  bool get canAnswer;

  DisputeProposal._();

  factory DisputeProposal([void updates(DisputeProposalBuilder b)]) = _$DisputeProposal;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeProposalBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeProposal> get serializer => _$DisputeProposalSerializer();
}

class _$DisputeProposalSerializer implements PrimitiveSerializer<DisputeProposal> {
  @override
  final Iterable<Type> types = const [DisputeProposal, _$DisputeProposal];

  @override
  final String wireName = r'DisputeProposal';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeProposal object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'proposed_by_party';
    yield serializers.serialize(
      object.proposedByParty,
      specifiedType: const FullType(DisputeProposalProposedByPartyEnum),
    );
    yield r'remedy';
    yield serializers.serialize(
      object.remedy,
      specifiedType: const FullType(DisputeProposalRemedyEnum),
    );
    if (object.amountCentavos != null) {
      yield r'amount_centavos';
      yield serializers.serialize(
        object.amountCentavos,
        specifiedType: const FullType(int),
      );
    }
    yield r'terms';
    yield serializers.serialize(
      object.terms,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(DisputeProposalStateEnum),
    );
    if (object.proposedAt != null) {
      yield r'proposed_at';
      yield serializers.serialize(
        object.proposedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.answeredAt != null) {
      yield r'answered_at';
      yield serializers.serialize(
        object.answeredAt,
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
    DisputeProposal object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeProposalBuilder result,
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
        case r'proposed_by_party':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeProposalProposedByPartyEnum),
          ) as DisputeProposalProposedByPartyEnum;
          result.proposedByParty = valueDes;
          break;
        case r'remedy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeProposalRemedyEnum),
          ) as DisputeProposalRemedyEnum;
          result.remedy = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.amountCentavos = valueDes;
          break;
        case r'terms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.terms = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeProposalStateEnum),
          ) as DisputeProposalStateEnum;
          result.state = valueDes;
          break;
        case r'proposed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.proposedAt = valueDes;
          break;
        case r'answered_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.answeredAt = valueDes;
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
  DisputeProposal deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeProposalBuilder();
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


class DisputeProposalProposedByPartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const DisputeProposalProposedByPartyEnum BUYER = _$disputeProposalProposedByPartyEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const DisputeProposalProposedByPartyEnum VENDOR = _$disputeProposalProposedByPartyEnum_VENDOR;

  static Serializer<DisputeProposalProposedByPartyEnum> get serializer => _$disputeProposalProposedByPartyEnumSerializer;

  const DisputeProposalProposedByPartyEnum._(String name): super(name);

  static BuiltSet<DisputeProposalProposedByPartyEnum> get values => _$disputeProposalProposedByPartyEnumValues;
  static DisputeProposalProposedByPartyEnum valueOf(String name) => _$disputeProposalProposedByPartyEnumValueOf(name);
}

class DisputeProposalRemedyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REPLACEMENT')
  static const DisputeProposalRemedyEnum REPLACEMENT = _$disputeProposalRemedyEnum_REPLACEMENT;
  @BuiltValueEnumConst(wireName: r'FULL_REFUND')
  static const DisputeProposalRemedyEnum FULL_REFUND = _$disputeProposalRemedyEnum_FULL_REFUND;
  @BuiltValueEnumConst(wireName: r'PARTIAL_REFUND')
  static const DisputeProposalRemedyEnum PARTIAL_REFUND = _$disputeProposalRemedyEnum_PARTIAL_REFUND;
  @BuiltValueEnumConst(wireName: r'NO_FURTHER_ACTION')
  static const DisputeProposalRemedyEnum NO_FURTHER_ACTION = _$disputeProposalRemedyEnum_NO_FURTHER_ACTION;

  static Serializer<DisputeProposalRemedyEnum> get serializer => _$disputeProposalRemedyEnumSerializer;

  const DisputeProposalRemedyEnum._(String name): super(name);

  static BuiltSet<DisputeProposalRemedyEnum> get values => _$disputeProposalRemedyEnumValues;
  static DisputeProposalRemedyEnum valueOf(String name) => _$disputeProposalRemedyEnumValueOf(name);
}

class DisputeProposalStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PROPOSED')
  static const DisputeProposalStateEnum PROPOSED = _$disputeProposalStateEnum_PROPOSED;
  @BuiltValueEnumConst(wireName: r'ACCEPTED')
  static const DisputeProposalStateEnum ACCEPTED = _$disputeProposalStateEnum_ACCEPTED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const DisputeProposalStateEnum REJECTED = _$disputeProposalStateEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'SUPERSEDED')
  static const DisputeProposalStateEnum SUPERSEDED = _$disputeProposalStateEnum_SUPERSEDED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const DisputeProposalStateEnum EXPIRED = _$disputeProposalStateEnum_EXPIRED;

  static Serializer<DisputeProposalStateEnum> get serializer => _$disputeProposalStateEnumSerializer;

  const DisputeProposalStateEnum._(String name): super(name);

  static BuiltSet<DisputeProposalStateEnum> get values => _$disputeProposalStateEnumValues;
  static DisputeProposalStateEnum valueOf(String name) => _$disputeProposalStateEnumValueOf(name);
}

