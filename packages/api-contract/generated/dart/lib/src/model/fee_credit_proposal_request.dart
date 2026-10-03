//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fee_credit_proposal_request.g.dart';

/// FeeCreditProposalRequest
///
/// Properties:
/// * [feeAssessmentId]
/// * [returnedExclusiveCentavos]
/// * [reason]
@BuiltValue()
abstract class FeeCreditProposalRequest implements Built<FeeCreditProposalRequest, FeeCreditProposalRequestBuilder> {
  @BuiltValueField(wireName: r'fee_assessment_id')
  String get feeAssessmentId;

  @BuiltValueField(wireName: r'returned_exclusive_centavos')
  int get returnedExclusiveCentavos;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  FeeCreditProposalRequest._();

  factory FeeCreditProposalRequest([void updates(FeeCreditProposalRequestBuilder b)]) = _$FeeCreditProposalRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FeeCreditProposalRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FeeCreditProposalRequest> get serializer => _$FeeCreditProposalRequestSerializer();
}

class _$FeeCreditProposalRequestSerializer implements PrimitiveSerializer<FeeCreditProposalRequest> {
  @override
  final Iterable<Type> types = const [FeeCreditProposalRequest, _$FeeCreditProposalRequest];

  @override
  final String wireName = r'FeeCreditProposalRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FeeCreditProposalRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fee_assessment_id';
    yield serializers.serialize(
      object.feeAssessmentId,
      specifiedType: const FullType(String),
    );
    yield r'returned_exclusive_centavos';
    yield serializers.serialize(
      object.returnedExclusiveCentavos,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FeeCreditProposalRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FeeCreditProposalRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fee_assessment_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.feeAssessmentId = valueDes;
          break;
        case r'returned_exclusive_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.returnedExclusiveCentavos = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FeeCreditProposalRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FeeCreditProposalRequestBuilder();
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


