//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_document_review.g.dart';

/// VendorDocumentReview
///
/// Properties:
/// * [lockVersion]
/// * [decision]
/// * [reason]
/// * [verifiedReference]
/// * [verifiedIssuedOn]
/// * [verifiedExpiresOn]
/// * [verifiedExpiryNotApplicable]
/// * [sourceReference]
/// * [remarks]
/// * [immediateRestriction]
@BuiltValue()
abstract class VendorDocumentReview implements Built<VendorDocumentReview, VendorDocumentReviewBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'decision')
  VendorDocumentReviewDecisionEnum get decision;
  // enum decisionEnum {  APPROVE,  RETURN_FOR_CORRECTION,  REJECT,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'verified_reference')
  String? get verifiedReference;

  @BuiltValueField(wireName: r'verified_issued_on')
  String? get verifiedIssuedOn;

  @BuiltValueField(wireName: r'verified_expires_on')
  String? get verifiedExpiresOn;

  @BuiltValueField(wireName: r'verified_expiry_not_applicable')
  bool get verifiedExpiryNotApplicable;

  @BuiltValueField(wireName: r'source_reference')
  String get sourceReference;

  @BuiltValueField(wireName: r'remarks')
  String? get remarks;

  @BuiltValueField(wireName: r'immediate_restriction')
  bool get immediateRestriction;

  VendorDocumentReview._();

  factory VendorDocumentReview([void updates(VendorDocumentReviewBuilder b)]) = _$VendorDocumentReview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDocumentReviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDocumentReview> get serializer => _$VendorDocumentReviewSerializer();
}

class _$VendorDocumentReviewSerializer implements PrimitiveSerializer<VendorDocumentReview> {
  @override
  final Iterable<Type> types = const [VendorDocumentReview, _$VendorDocumentReview];

  @override
  final String wireName = r'VendorDocumentReview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDocumentReview object, {
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
      specifiedType: const FullType(VendorDocumentReviewDecisionEnum),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.verifiedReference != null) {
      yield r'verified_reference';
      yield serializers.serialize(
        object.verifiedReference,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.verifiedIssuedOn != null) {
      yield r'verified_issued_on';
      yield serializers.serialize(
        object.verifiedIssuedOn,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.verifiedExpiresOn != null) {
      yield r'verified_expires_on';
      yield serializers.serialize(
        object.verifiedExpiresOn,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'verified_expiry_not_applicable';
    yield serializers.serialize(
      object.verifiedExpiryNotApplicable,
      specifiedType: const FullType(bool),
    );
    yield r'source_reference';
    yield serializers.serialize(
      object.sourceReference,
      specifiedType: const FullType(String),
    );
    if (object.remarks != null) {
      yield r'remarks';
      yield serializers.serialize(
        object.remarks,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'immediate_restriction';
    yield serializers.serialize(
      object.immediateRestriction,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDocumentReview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDocumentReviewBuilder result,
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
            specifiedType: const FullType(VendorDocumentReviewDecisionEnum),
          ) as VendorDocumentReviewDecisionEnum;
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
        case r'verified_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.verifiedReference = valueDes;
          break;
        case r'verified_issued_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.verifiedIssuedOn = valueDes;
          break;
        case r'verified_expires_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.verifiedExpiresOn = valueDes;
          break;
        case r'verified_expiry_not_applicable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.verifiedExpiryNotApplicable = valueDes;
          break;
        case r'source_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sourceReference = valueDes;
          break;
        case r'remarks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.remarks = valueDes;
          break;
        case r'immediate_restriction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.immediateRestriction = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDocumentReview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDocumentReviewBuilder();
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


class VendorDocumentReviewDecisionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'APPROVE')
  static const VendorDocumentReviewDecisionEnum APPROVE = _$vendorDocumentReviewDecisionEnum_APPROVE;
  @BuiltValueEnumConst(wireName: r'RETURN_FOR_CORRECTION')
  static const VendorDocumentReviewDecisionEnum RETURN_FOR_CORRECTION = _$vendorDocumentReviewDecisionEnum_RETURN_FOR_CORRECTION;
  @BuiltValueEnumConst(wireName: r'REJECT')
  static const VendorDocumentReviewDecisionEnum REJECT = _$vendorDocumentReviewDecisionEnum_REJECT;

  static Serializer<VendorDocumentReviewDecisionEnum> get serializer => _$vendorDocumentReviewDecisionEnumSerializer;

  const VendorDocumentReviewDecisionEnum._(String name): super(name);

  static BuiltSet<VendorDocumentReviewDecisionEnum> get values => _$vendorDocumentReviewDecisionEnumValues;
  static VendorDocumentReviewDecisionEnum valueOf(String name) => _$vendorDocumentReviewDecisionEnumValueOf(name);
}

