//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tax_adjustment_review_request.g.dart';

/// 409 PREPARER_CANNOT_REVIEW when the reviewer prepared the adjustment.
///
/// Properties:
/// * [decision]
/// * [reason]
@BuiltValue()
abstract class TaxAdjustmentReviewRequest implements Built<TaxAdjustmentReviewRequest, TaxAdjustmentReviewRequestBuilder> {
  @BuiltValueField(wireName: r'decision')
  TaxAdjustmentReviewRequestDecisionEnum get decision;
  // enum decisionEnum {  APPROVED,  REJECTED,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  TaxAdjustmentReviewRequest._();

  factory TaxAdjustmentReviewRequest([void updates(TaxAdjustmentReviewRequestBuilder b)]) = _$TaxAdjustmentReviewRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TaxAdjustmentReviewRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TaxAdjustmentReviewRequest> get serializer => _$TaxAdjustmentReviewRequestSerializer();
}

class _$TaxAdjustmentReviewRequestSerializer implements PrimitiveSerializer<TaxAdjustmentReviewRequest> {
  @override
  final Iterable<Type> types = const [TaxAdjustmentReviewRequest, _$TaxAdjustmentReviewRequest];

  @override
  final String wireName = r'TaxAdjustmentReviewRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TaxAdjustmentReviewRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'decision';
    yield serializers.serialize(
      object.decision,
      specifiedType: const FullType(TaxAdjustmentReviewRequestDecisionEnum),
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
    TaxAdjustmentReviewRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TaxAdjustmentReviewRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'decision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TaxAdjustmentReviewRequestDecisionEnum),
          ) as TaxAdjustmentReviewRequestDecisionEnum;
          result.decision = valueDes;
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
  TaxAdjustmentReviewRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TaxAdjustmentReviewRequestBuilder();
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


class TaxAdjustmentReviewRequestDecisionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const TaxAdjustmentReviewRequestDecisionEnum APPROVED = _$taxAdjustmentReviewRequestDecisionEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const TaxAdjustmentReviewRequestDecisionEnum REJECTED = _$taxAdjustmentReviewRequestDecisionEnum_REJECTED;

  static Serializer<TaxAdjustmentReviewRequestDecisionEnum> get serializer => _$taxAdjustmentReviewRequestDecisionEnumSerializer;

  const TaxAdjustmentReviewRequestDecisionEnum._(String name): super(name);

  static BuiltSet<TaxAdjustmentReviewRequestDecisionEnum> get values => _$taxAdjustmentReviewRequestDecisionEnumValues;
  static TaxAdjustmentReviewRequestDecisionEnum valueOf(String name) => _$taxAdjustmentReviewRequestDecisionEnumValueOf(name);
}

