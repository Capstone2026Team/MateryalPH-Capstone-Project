//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'review_rating_bucket.g.dart';

/// ReviewRatingBucket
///
/// Properties:
/// * [stars]
/// * [count]
@BuiltValue()
abstract class ReviewRatingBucket implements Built<ReviewRatingBucket, ReviewRatingBucketBuilder> {
  @BuiltValueField(wireName: r'stars')
  int get stars;

  @BuiltValueField(wireName: r'count')
  int get count;

  ReviewRatingBucket._();

  factory ReviewRatingBucket([void updates(ReviewRatingBucketBuilder b)]) = _$ReviewRatingBucket;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReviewRatingBucketBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReviewRatingBucket> get serializer => _$ReviewRatingBucketSerializer();
}

class _$ReviewRatingBucketSerializer implements PrimitiveSerializer<ReviewRatingBucket> {
  @override
  final Iterable<Type> types = const [ReviewRatingBucket, _$ReviewRatingBucket];

  @override
  final String wireName = r'ReviewRatingBucket';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReviewRatingBucket object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'stars';
    yield serializers.serialize(
      object.stars,
      specifiedType: const FullType(int),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReviewRatingBucket object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReviewRatingBucketBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'stars':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.stars = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReviewRatingBucket deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReviewRatingBucketBuilder();
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


