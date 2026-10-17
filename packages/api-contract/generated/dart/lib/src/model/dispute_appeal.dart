//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_appeal.g.dart';

/// DisputeAppeal
///
/// Properties:
/// * [id]
/// * [appellantParty]
/// * [grounds]
/// * [statement]
/// * [state]
/// * [filedAt]
/// * [decidedAt]
/// * [appealedDecisionId]
/// * [resultDecisionId]
@BuiltValue()
abstract class DisputeAppeal implements Built<DisputeAppeal, DisputeAppealBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'appellant_party')
  DisputeAppealAppellantPartyEnum get appellantParty;
  // enum appellantPartyEnum {  BUYER,  VENDOR,  };

  @BuiltValueField(wireName: r'grounds')
  DisputeAppealGroundsEnum get grounds;
  // enum groundsEnum {  NEW_EVIDENCE,  MATERIAL_PROCESS_ERROR,  };

  @BuiltValueField(wireName: r'statement')
  String get statement;

  @BuiltValueField(wireName: r'state')
  DisputeAppealStateEnum get state;
  // enum stateEnum {  OPEN,  DECIDED,  };

  @BuiltValueField(wireName: r'filed_at')
  DateTime? get filedAt;

  @BuiltValueField(wireName: r'decided_at')
  DateTime? get decidedAt;

  @BuiltValueField(wireName: r'appealed_decision_id')
  String get appealedDecisionId;

  @BuiltValueField(wireName: r'result_decision_id')
  String? get resultDecisionId;

  DisputeAppeal._();

  factory DisputeAppeal([void updates(DisputeAppealBuilder b)]) = _$DisputeAppeal;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeAppealBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeAppeal> get serializer => _$DisputeAppealSerializer();
}

class _$DisputeAppealSerializer implements PrimitiveSerializer<DisputeAppeal> {
  @override
  final Iterable<Type> types = const [DisputeAppeal, _$DisputeAppeal];

  @override
  final String wireName = r'DisputeAppeal';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeAppeal object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'appellant_party';
    yield serializers.serialize(
      object.appellantParty,
      specifiedType: const FullType(DisputeAppealAppellantPartyEnum),
    );
    yield r'grounds';
    yield serializers.serialize(
      object.grounds,
      specifiedType: const FullType(DisputeAppealGroundsEnum),
    );
    yield r'statement';
    yield serializers.serialize(
      object.statement,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(DisputeAppealStateEnum),
    );
    if (object.filedAt != null) {
      yield r'filed_at';
      yield serializers.serialize(
        object.filedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.decidedAt != null) {
      yield r'decided_at';
      yield serializers.serialize(
        object.decidedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'appealed_decision_id';
    yield serializers.serialize(
      object.appealedDecisionId,
      specifiedType: const FullType(String),
    );
    if (object.resultDecisionId != null) {
      yield r'result_decision_id';
      yield serializers.serialize(
        object.resultDecisionId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeAppeal object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeAppealBuilder result,
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
        case r'appellant_party':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeAppealAppellantPartyEnum),
          ) as DisputeAppealAppellantPartyEnum;
          result.appellantParty = valueDes;
          break;
        case r'grounds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeAppealGroundsEnum),
          ) as DisputeAppealGroundsEnum;
          result.grounds = valueDes;
          break;
        case r'statement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.statement = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeAppealStateEnum),
          ) as DisputeAppealStateEnum;
          result.state = valueDes;
          break;
        case r'filed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.filedAt = valueDes;
          break;
        case r'decided_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.decidedAt = valueDes;
          break;
        case r'appealed_decision_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.appealedDecisionId = valueDes;
          break;
        case r'result_decision_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.resultDecisionId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeAppeal deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeAppealBuilder();
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


class DisputeAppealAppellantPartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const DisputeAppealAppellantPartyEnum BUYER = _$disputeAppealAppellantPartyEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const DisputeAppealAppellantPartyEnum VENDOR = _$disputeAppealAppellantPartyEnum_VENDOR;

  static Serializer<DisputeAppealAppellantPartyEnum> get serializer => _$disputeAppealAppellantPartyEnumSerializer;

  const DisputeAppealAppellantPartyEnum._(String name): super(name);

  static BuiltSet<DisputeAppealAppellantPartyEnum> get values => _$disputeAppealAppellantPartyEnumValues;
  static DisputeAppealAppellantPartyEnum valueOf(String name) => _$disputeAppealAppellantPartyEnumValueOf(name);
}

class DisputeAppealGroundsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NEW_EVIDENCE')
  static const DisputeAppealGroundsEnum NEW_EVIDENCE = _$disputeAppealGroundsEnum_NEW_EVIDENCE;
  @BuiltValueEnumConst(wireName: r'MATERIAL_PROCESS_ERROR')
  static const DisputeAppealGroundsEnum MATERIAL_PROCESS_ERROR = _$disputeAppealGroundsEnum_MATERIAL_PROCESS_ERROR;

  static Serializer<DisputeAppealGroundsEnum> get serializer => _$disputeAppealGroundsEnumSerializer;

  const DisputeAppealGroundsEnum._(String name): super(name);

  static BuiltSet<DisputeAppealGroundsEnum> get values => _$disputeAppealGroundsEnumValues;
  static DisputeAppealGroundsEnum valueOf(String name) => _$disputeAppealGroundsEnumValueOf(name);
}

class DisputeAppealStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const DisputeAppealStateEnum OPEN = _$disputeAppealStateEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'DECIDED')
  static const DisputeAppealStateEnum DECIDED = _$disputeAppealStateEnum_DECIDED;

  static Serializer<DisputeAppealStateEnum> get serializer => _$disputeAppealStateEnumSerializer;

  const DisputeAppealStateEnum._(String name): super(name);

  static BuiltSet<DisputeAppealStateEnum> get values => _$disputeAppealStateEnumValues;
  static DisputeAppealStateEnum valueOf(String name) => _$disputeAppealStateEnumValueOf(name);
}

