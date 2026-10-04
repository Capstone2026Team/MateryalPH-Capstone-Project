//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_proposal_answer.g.dart';

/// DisputeProposalAnswer
///
/// Properties:
/// * [decision]
@BuiltValue()
abstract class DisputeProposalAnswer implements Built<DisputeProposalAnswer, DisputeProposalAnswerBuilder> {
  @BuiltValueField(wireName: r'decision')
  DisputeProposalAnswerDecisionEnum get decision;
  // enum decisionEnum {  ACCEPT,  REJECT,  };

  DisputeProposalAnswer._();

  factory DisputeProposalAnswer([void updates(DisputeProposalAnswerBuilder b)]) = _$DisputeProposalAnswer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeProposalAnswerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeProposalAnswer> get serializer => _$DisputeProposalAnswerSerializer();
}

class _$DisputeProposalAnswerSerializer implements PrimitiveSerializer<DisputeProposalAnswer> {
  @override
  final Iterable<Type> types = const [DisputeProposalAnswer, _$DisputeProposalAnswer];

  @override
  final String wireName = r'DisputeProposalAnswer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeProposalAnswer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'decision';
    yield serializers.serialize(
      object.decision,
      specifiedType: const FullType(DisputeProposalAnswerDecisionEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeProposalAnswer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeProposalAnswerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'decision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeProposalAnswerDecisionEnum),
          ) as DisputeProposalAnswerDecisionEnum;
          result.decision = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeProposalAnswer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeProposalAnswerBuilder();
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


class DisputeProposalAnswerDecisionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACCEPT')
  static const DisputeProposalAnswerDecisionEnum ACCEPT = _$disputeProposalAnswerDecisionEnum_ACCEPT;
  @BuiltValueEnumConst(wireName: r'REJECT')
  static const DisputeProposalAnswerDecisionEnum REJECT = _$disputeProposalAnswerDecisionEnum_REJECT;

  static Serializer<DisputeProposalAnswerDecisionEnum> get serializer => _$disputeProposalAnswerDecisionEnumSerializer;

  const DisputeProposalAnswerDecisionEnum._(String name): super(name);

  static BuiltSet<DisputeProposalAnswerDecisionEnum> get values => _$disputeProposalAnswerDecisionEnumValues;
  static DisputeProposalAnswerDecisionEnum valueOf(String name) => _$disputeProposalAnswerDecisionEnumValueOf(name);
}

