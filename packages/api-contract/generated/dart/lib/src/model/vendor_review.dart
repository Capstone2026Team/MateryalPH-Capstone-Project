//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_review.g.dart';

/// VendorReview
///
/// Properties:
/// * [lockVersion]
/// * [decision]
/// * [reason]
@BuiltValue()
abstract class VendorReview implements Built<VendorReview, VendorReviewBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'decision')
  VendorReviewDecisionEnum get decision;
  // enum decisionEnum {  APPROVE,  RETURN_FOR_CORRECTION,  REJECT,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  VendorReview._();

  factory VendorReview([void updates(VendorReviewBuilder b)]) = _$VendorReview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorReviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorReview> get serializer => _$VendorReviewSerializer();
}

class _$VendorReviewSerializer implements PrimitiveSerializer<VendorReview> {
  @override
  final Iterable<Type> types = const [VendorReview, _$VendorReview];

  @override
  final String wireName = r'VendorReview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorReview object, {
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
      specifiedType: const FullType(VendorReviewDecisionEnum),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorReview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorReviewBuilder result,
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
            specifiedType: const FullType(VendorReviewDecisionEnum),
          ) as VendorReviewDecisionEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorReview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorReviewBuilder();
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


class VendorReviewDecisionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'APPROVE')
  static const VendorReviewDecisionEnum APPROVE = _$vendorReviewDecisionEnum_APPROVE;
  @BuiltValueEnumConst(wireName: r'RETURN_FOR_CORRECTION')
  static const VendorReviewDecisionEnum RETURN_FOR_CORRECTION = _$vendorReviewDecisionEnum_RETURN_FOR_CORRECTION;
  @BuiltValueEnumConst(wireName: r'REJECT')
  static const VendorReviewDecisionEnum REJECT = _$vendorReviewDecisionEnum_REJECT;

  static Serializer<VendorReviewDecisionEnum> get serializer => _$vendorReviewDecisionEnumSerializer;

  const VendorReviewDecisionEnum._(String name): super(name);

  static BuiltSet<VendorReviewDecisionEnum> get values => _$vendorReviewDecisionEnumValues;
  static VendorReviewDecisionEnum valueOf(String name) => _$vendorReviewDecisionEnumValueOf(name);
}

