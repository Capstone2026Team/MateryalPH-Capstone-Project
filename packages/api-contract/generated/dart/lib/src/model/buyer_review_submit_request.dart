//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/buyer_review_submit_request_product_reviews_inner.dart';
import 'package:materyalph_api_client/src/model/buyer_review_submit_request_vendor_rating.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_review_submit_request.g.dart';

/// Any not-yet-submitted subset; each rating once per order or purchased line. Requires a COMPLETED order inside its 14-day window.
///
/// Properties:
/// * [displayNameChoice]
/// * [vendorRating]
/// * [productReviews]
@BuiltValue()
abstract class BuyerReviewSubmitRequest implements Built<BuyerReviewSubmitRequest, BuyerReviewSubmitRequestBuilder> {
  @BuiltValueField(wireName: r'display_name_choice')
  BuyerReviewSubmitRequestDisplayNameChoiceEnum get displayNameChoice;
  // enum displayNameChoiceEnum {  FIRST_NAME_LAST_INITIAL,  VERIFIED_BUYER,  };

  @BuiltValueField(wireName: r'vendor_rating')
  BuyerReviewSubmitRequestVendorRating? get vendorRating;

  @BuiltValueField(wireName: r'product_reviews')
  BuiltList<BuyerReviewSubmitRequestProductReviewsInner>? get productReviews;

  BuyerReviewSubmitRequest._();

  factory BuyerReviewSubmitRequest([void updates(BuyerReviewSubmitRequestBuilder b)]) = _$BuyerReviewSubmitRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerReviewSubmitRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerReviewSubmitRequest> get serializer => _$BuyerReviewSubmitRequestSerializer();
}

class _$BuyerReviewSubmitRequestSerializer implements PrimitiveSerializer<BuyerReviewSubmitRequest> {
  @override
  final Iterable<Type> types = const [BuyerReviewSubmitRequest, _$BuyerReviewSubmitRequest];

  @override
  final String wireName = r'BuyerReviewSubmitRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerReviewSubmitRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'display_name_choice';
    yield serializers.serialize(
      object.displayNameChoice,
      specifiedType: const FullType(BuyerReviewSubmitRequestDisplayNameChoiceEnum),
    );
    if (object.vendorRating != null) {
      yield r'vendor_rating';
      yield serializers.serialize(
        object.vendorRating,
        specifiedType: const FullType(BuyerReviewSubmitRequestVendorRating),
      );
    }
    if (object.productReviews != null) {
      yield r'product_reviews';
      yield serializers.serialize(
        object.productReviews,
        specifiedType: const FullType(BuiltList, [FullType(BuyerReviewSubmitRequestProductReviewsInner)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerReviewSubmitRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerReviewSubmitRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'display_name_choice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerReviewSubmitRequestDisplayNameChoiceEnum),
          ) as BuyerReviewSubmitRequestDisplayNameChoiceEnum;
          result.displayNameChoice = valueDes;
          break;
        case r'vendor_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuyerReviewSubmitRequestVendorRating),
          ) as BuyerReviewSubmitRequestVendorRating?;
          if (valueDes == null) continue;
          result.vendorRating.replace(valueDes);
          break;
        case r'product_reviews':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(BuyerReviewSubmitRequestProductReviewsInner)]),
          ) as BuiltList<BuyerReviewSubmitRequestProductReviewsInner>?;
          if (valueDes == null) continue;
          result.productReviews.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerReviewSubmitRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerReviewSubmitRequestBuilder();
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


class BuyerReviewSubmitRequestDisplayNameChoiceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FIRST_NAME_LAST_INITIAL')
  static const BuyerReviewSubmitRequestDisplayNameChoiceEnum FIRST_NAME_LAST_INITIAL = _$buyerReviewSubmitRequestDisplayNameChoiceEnum_FIRST_NAME_LAST_INITIAL;
  @BuiltValueEnumConst(wireName: r'VERIFIED_BUYER')
  static const BuyerReviewSubmitRequestDisplayNameChoiceEnum VERIFIED_BUYER = _$buyerReviewSubmitRequestDisplayNameChoiceEnum_VERIFIED_BUYER;

  static Serializer<BuyerReviewSubmitRequestDisplayNameChoiceEnum> get serializer => _$buyerReviewSubmitRequestDisplayNameChoiceEnumSerializer;

  const BuyerReviewSubmitRequestDisplayNameChoiceEnum._(String name): super(name);

  static BuiltSet<BuyerReviewSubmitRequestDisplayNameChoiceEnum> get values => _$buyerReviewSubmitRequestDisplayNameChoiceEnumValues;
  static BuyerReviewSubmitRequestDisplayNameChoiceEnum valueOf(String name) => _$buyerReviewSubmitRequestDisplayNameChoiceEnumValueOf(name);
}

