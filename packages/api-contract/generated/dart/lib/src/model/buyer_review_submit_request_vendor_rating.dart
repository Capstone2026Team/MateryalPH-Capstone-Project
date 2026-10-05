//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_review_submit_request_vendor_rating.g.dart';

/// BuyerReviewSubmitRequestVendorRating
///
/// Properties:
/// * [serviceQuality]
/// * [speedRating]
/// * [comment]
@BuiltValue()
abstract class BuyerReviewSubmitRequestVendorRating implements Built<BuyerReviewSubmitRequestVendorRating, BuyerReviewSubmitRequestVendorRatingBuilder> {
  @BuiltValueField(wireName: r'service_quality')
  int get serviceQuality;

  @BuiltValueField(wireName: r'speed_rating')
  int get speedRating;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  BuyerReviewSubmitRequestVendorRating._();

  factory BuyerReviewSubmitRequestVendorRating([void updates(BuyerReviewSubmitRequestVendorRatingBuilder b)]) = _$BuyerReviewSubmitRequestVendorRating;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerReviewSubmitRequestVendorRatingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerReviewSubmitRequestVendorRating> get serializer => _$BuyerReviewSubmitRequestVendorRatingSerializer();
}

class _$BuyerReviewSubmitRequestVendorRatingSerializer implements PrimitiveSerializer<BuyerReviewSubmitRequestVendorRating> {
  @override
  final Iterable<Type> types = const [BuyerReviewSubmitRequestVendorRating, _$BuyerReviewSubmitRequestVendorRating];

  @override
  final String wireName = r'BuyerReviewSubmitRequestVendorRating';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerReviewSubmitRequestVendorRating object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'service_quality';
    yield serializers.serialize(
      object.serviceQuality,
      specifiedType: const FullType(int),
    );
    yield r'speed_rating';
    yield serializers.serialize(
      object.speedRating,
      specifiedType: const FullType(int),
    );
    if (object.comment != null) {
      yield r'comment';
      yield serializers.serialize(
        object.comment,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerReviewSubmitRequestVendorRating object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerReviewSubmitRequestVendorRatingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'service_quality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.serviceQuality = valueDes;
          break;
        case r'speed_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.speedRating = valueDes;
          break;
        case r'comment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.comment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerReviewSubmitRequestVendorRating deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerReviewSubmitRequestVendorRatingBuilder();
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


