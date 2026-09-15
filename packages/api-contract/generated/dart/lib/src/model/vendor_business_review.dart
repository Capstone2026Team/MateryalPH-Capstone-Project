//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_business_review.g.dart';

/// VendorBusinessReview
///
/// Properties:
/// * [lockVersion]
/// * [decision]
/// * [reason]
/// * [regulatoryEvidenceRequired]
/// * [regulatoryReviewBasis]
@BuiltValue()
abstract class VendorBusinessReview implements Built<VendorBusinessReview, VendorBusinessReviewBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'decision')
  VendorBusinessReviewDecisionEnum get decision;
  // enum decisionEnum {  APPROVE,  RETURN_FOR_CORRECTION,  REJECT,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'regulatory_evidence_required')
  bool? get regulatoryEvidenceRequired;

  @BuiltValueField(wireName: r'regulatory_review_basis')
  String? get regulatoryReviewBasis;

  VendorBusinessReview._();

  factory VendorBusinessReview([void updates(VendorBusinessReviewBuilder b)]) = _$VendorBusinessReview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorBusinessReviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorBusinessReview> get serializer => _$VendorBusinessReviewSerializer();
}

class _$VendorBusinessReviewSerializer implements PrimitiveSerializer<VendorBusinessReview> {
  @override
  final Iterable<Type> types = const [VendorBusinessReview, _$VendorBusinessReview];

  @override
  final String wireName = r'VendorBusinessReview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorBusinessReview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'decision';
    yield serializers.serialize(
      object.decision,
      specifiedType: const FullType(VendorBusinessReviewDecisionEnum),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.regulatoryEvidenceRequired != null) {
      yield r'regulatory_evidence_required';
      yield serializers.serialize(
        object.regulatoryEvidenceRequired,
        specifiedType: const FullType(bool),
      );
    }
    if (object.regulatoryReviewBasis != null) {
      yield r'regulatory_review_basis';
      yield serializers.serialize(
        object.regulatoryReviewBasis,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorBusinessReview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorBusinessReviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'decision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorBusinessReviewDecisionEnum),
          ) as VendorBusinessReviewDecisionEnum;
          result.decision = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'regulatory_evidence_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.regulatoryEvidenceRequired = valueDes;
          break;
        case r'regulatory_review_basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.regulatoryReviewBasis = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorBusinessReview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorBusinessReviewBuilder();
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


class VendorBusinessReviewDecisionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'APPROVE')
  static const VendorBusinessReviewDecisionEnum APPROVE = _$vendorBusinessReviewDecisionEnum_APPROVE;
  @BuiltValueEnumConst(wireName: r'RETURN_FOR_CORRECTION')
  static const VendorBusinessReviewDecisionEnum RETURN_FOR_CORRECTION = _$vendorBusinessReviewDecisionEnum_RETURN_FOR_CORRECTION;
  @BuiltValueEnumConst(wireName: r'REJECT')
  static const VendorBusinessReviewDecisionEnum REJECT = _$vendorBusinessReviewDecisionEnum_REJECT;

  static Serializer<VendorBusinessReviewDecisionEnum> get serializer => _$vendorBusinessReviewDecisionEnumSerializer;

  const VendorBusinessReviewDecisionEnum._(String name): super(name);

  static BuiltSet<VendorBusinessReviewDecisionEnum> get values => _$vendorBusinessReviewDecisionEnumValues;
  static VendorBusinessReviewDecisionEnum valueOf(String name) => _$vendorBusinessReviewDecisionEnumValueOf(name);
}

