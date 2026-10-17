//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_proposal_request.g.dart';

/// DisputeProposalRequest
///
/// Properties:
/// * [remedy]
/// * [amountCentavos]
/// * [terms]
@BuiltValue()
abstract class DisputeProposalRequest implements Built<DisputeProposalRequest, DisputeProposalRequestBuilder> {
  @BuiltValueField(wireName: r'remedy')
  DisputeProposalRequestRemedyEnum get remedy;
  // enum remedyEnum {  REPLACEMENT,  FULL_REFUND,  PARTIAL_REFUND,  NO_FURTHER_ACTION,  };

  @BuiltValueField(wireName: r'amount_centavos')
  int? get amountCentavos;

  @BuiltValueField(wireName: r'terms')
  String get terms;

  DisputeProposalRequest._();

  factory DisputeProposalRequest([void updates(DisputeProposalRequestBuilder b)]) = _$DisputeProposalRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeProposalRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeProposalRequest> get serializer => _$DisputeProposalRequestSerializer();
}

class _$DisputeProposalRequestSerializer implements PrimitiveSerializer<DisputeProposalRequest> {
  @override
  final Iterable<Type> types = const [DisputeProposalRequest, _$DisputeProposalRequest];

  @override
  final String wireName = r'DisputeProposalRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeProposalRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'remedy';
    yield serializers.serialize(
      object.remedy,
      specifiedType: const FullType(DisputeProposalRequestRemedyEnum),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeProposalRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeProposalRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'remedy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeProposalRequestRemedyEnum),
          ) as DisputeProposalRequestRemedyEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeProposalRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeProposalRequestBuilder();
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


class DisputeProposalRequestRemedyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REPLACEMENT')
  static const DisputeProposalRequestRemedyEnum REPLACEMENT = _$disputeProposalRequestRemedyEnum_REPLACEMENT;
  @BuiltValueEnumConst(wireName: r'FULL_REFUND')
  static const DisputeProposalRequestRemedyEnum FULL_REFUND = _$disputeProposalRequestRemedyEnum_FULL_REFUND;
  @BuiltValueEnumConst(wireName: r'PARTIAL_REFUND')
  static const DisputeProposalRequestRemedyEnum PARTIAL_REFUND = _$disputeProposalRequestRemedyEnum_PARTIAL_REFUND;
  @BuiltValueEnumConst(wireName: r'NO_FURTHER_ACTION')
  static const DisputeProposalRequestRemedyEnum NO_FURTHER_ACTION = _$disputeProposalRequestRemedyEnum_NO_FURTHER_ACTION;

  static Serializer<DisputeProposalRequestRemedyEnum> get serializer => _$disputeProposalRequestRemedyEnumSerializer;

  const DisputeProposalRequestRemedyEnum._(String name): super(name);

  static BuiltSet<DisputeProposalRequestRemedyEnum> get values => _$disputeProposalRequestRemedyEnumValues;
  static DisputeProposalRequestRemedyEnum valueOf(String name) => _$disputeProposalRequestRemedyEnumValueOf(name);
}

