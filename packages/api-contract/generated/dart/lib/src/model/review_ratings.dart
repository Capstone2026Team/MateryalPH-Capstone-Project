//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'review_ratings.g.dart';

/// ReviewRatings
///
/// Properties:
/// * [serviceQuality]
/// * [speedRating]
/// * [speedKind]
/// * [productQuality]
/// * [inquirySeriousness]
/// * [communicationQuality]
/// * [paymentReliability]
@BuiltValue()
abstract class ReviewRatings implements Built<ReviewRatings, ReviewRatingsBuilder> {
  @BuiltValueField(wireName: r'service_quality')
  int? get serviceQuality;

  @BuiltValueField(wireName: r'speed_rating')
  int? get speedRating;

  @BuiltValueField(wireName: r'speed_kind')
  ReviewRatingsSpeedKindEnum? get speedKind;
  // enum speedKindEnum {  DELIVERY_SPEED,  PROCESSING_SPEED,  };

  @BuiltValueField(wireName: r'product_quality')
  int? get productQuality;

  @BuiltValueField(wireName: r'inquiry_seriousness')
  int? get inquirySeriousness;

  @BuiltValueField(wireName: r'communication_quality')
  int? get communicationQuality;

  @BuiltValueField(wireName: r'payment_reliability')
  int? get paymentReliability;

  ReviewRatings._();

  factory ReviewRatings([void updates(ReviewRatingsBuilder b)]) = _$ReviewRatings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReviewRatingsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReviewRatings> get serializer => _$ReviewRatingsSerializer();
}

class _$ReviewRatingsSerializer implements PrimitiveSerializer<ReviewRatings> {
  @override
  final Iterable<Type> types = const [ReviewRatings, _$ReviewRatings];

  @override
  final String wireName = r'ReviewRatings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReviewRatings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.serviceQuality != null) {
      yield r'service_quality';
      yield serializers.serialize(
        object.serviceQuality,
        specifiedType: const FullType(int),
      );
    }
    if (object.speedRating != null) {
      yield r'speed_rating';
      yield serializers.serialize(
        object.speedRating,
        specifiedType: const FullType(int),
      );
    }
    if (object.speedKind != null) {
      yield r'speed_kind';
      yield serializers.serialize(
        object.speedKind,
        specifiedType: const FullType(ReviewRatingsSpeedKindEnum),
      );
    }
    if (object.productQuality != null) {
      yield r'product_quality';
      yield serializers.serialize(
        object.productQuality,
        specifiedType: const FullType(int),
      );
    }
    if (object.inquirySeriousness != null) {
      yield r'inquiry_seriousness';
      yield serializers.serialize(
        object.inquirySeriousness,
        specifiedType: const FullType(int),
      );
    }
    if (object.communicationQuality != null) {
      yield r'communication_quality';
      yield serializers.serialize(
        object.communicationQuality,
        specifiedType: const FullType(int),
      );
    }
    if (object.paymentReliability != null) {
      yield r'payment_reliability';
      yield serializers.serialize(
        object.paymentReliability,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ReviewRatings object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReviewRatingsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'service_quality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.serviceQuality = valueDes;
          break;
        case r'speed_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.speedRating = valueDes;
          break;
        case r'speed_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ReviewRatingsSpeedKindEnum),
          ) as ReviewRatingsSpeedKindEnum?;
          if (valueDes == null) continue;
          result.speedKind = valueDes;
          break;
        case r'product_quality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.productQuality = valueDes;
          break;
        case r'inquiry_seriousness':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.inquirySeriousness = valueDes;
          break;
        case r'communication_quality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.communicationQuality = valueDes;
          break;
        case r'payment_reliability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.paymentReliability = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReviewRatings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReviewRatingsBuilder();
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


class ReviewRatingsSpeedKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY_SPEED')
  static const ReviewRatingsSpeedKindEnum DELIVERY_SPEED = _$reviewRatingsSpeedKindEnum_DELIVERY_SPEED;
  @BuiltValueEnumConst(wireName: r'PROCESSING_SPEED')
  static const ReviewRatingsSpeedKindEnum PROCESSING_SPEED = _$reviewRatingsSpeedKindEnum_PROCESSING_SPEED;

  static Serializer<ReviewRatingsSpeedKindEnum> get serializer => _$reviewRatingsSpeedKindEnumSerializer;

  const ReviewRatingsSpeedKindEnum._(String name): super(name);

  static BuiltSet<ReviewRatingsSpeedKindEnum> get values => _$reviewRatingsSpeedKindEnumValues;
  static ReviewRatingsSpeedKindEnum valueOf(String name) => _$reviewRatingsSpeedKindEnumValueOf(name);
}

