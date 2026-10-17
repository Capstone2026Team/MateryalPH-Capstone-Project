//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_review_edit_request.g.dart';

/// BuyerReviewEditRequest
///
/// Properties:
/// * [lockVersion]
/// * [serviceQuality]
/// * [speedRating]
/// * [rating]
/// * [comment]
@BuiltValue()
abstract class BuyerReviewEditRequest implements Built<BuyerReviewEditRequest, BuyerReviewEditRequestBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'service_quality')
  int? get serviceQuality;

  @BuiltValueField(wireName: r'speed_rating')
  int? get speedRating;

  @BuiltValueField(wireName: r'rating')
  int? get rating;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  BuyerReviewEditRequest._();

  factory BuyerReviewEditRequest([void updates(BuyerReviewEditRequestBuilder b)]) = _$BuyerReviewEditRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerReviewEditRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerReviewEditRequest> get serializer => _$BuyerReviewEditRequestSerializer();
}

class _$BuyerReviewEditRequestSerializer implements PrimitiveSerializer<BuyerReviewEditRequest> {
  @override
  final Iterable<Type> types = const [BuyerReviewEditRequest, _$BuyerReviewEditRequest];

  @override
  final String wireName = r'BuyerReviewEditRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerReviewEditRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
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
    if (object.rating != null) {
      yield r'rating';
      yield serializers.serialize(
        object.rating,
        specifiedType: const FullType(int),
      );
    }
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
    BuyerReviewEditRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerReviewEditRequestBuilder result,
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
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.rating = valueDes;
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
  BuyerReviewEditRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerReviewEditRequestBuilder();
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


