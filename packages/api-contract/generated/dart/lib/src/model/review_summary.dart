//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/review_rating_bucket.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'review_summary.g.dart';

/// Visible Product Reviews matching the requested product and submitted-date filters before pagination. Hidden, unrevealed, disputed, removed and excluded reviews never contribute.
///
/// Properties:
/// * [count]
/// * [average] - Arithmetic mean of visible product star ratings, rounded half-up to two decimals; null when count is zero.
/// * [distribution] - All five rating buckets ordered from five stars to one star, including zero counts.
@BuiltValue()
abstract class ReviewSummary implements Built<ReviewSummary, ReviewSummaryBuilder> {
  @BuiltValueField(wireName: r'count')
  int get count;

  /// Arithmetic mean of visible product star ratings, rounded half-up to two decimals; null when count is zero.
  @BuiltValueField(wireName: r'average')
  num? get average;

  /// All five rating buckets ordered from five stars to one star, including zero counts.
  @BuiltValueField(wireName: r'distribution')
  BuiltList<ReviewRatingBucket> get distribution;

  ReviewSummary._();

  factory ReviewSummary([void updates(ReviewSummaryBuilder b)]) = _$ReviewSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReviewSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReviewSummary> get serializer => _$ReviewSummarySerializer();
}

class _$ReviewSummarySerializer implements PrimitiveSerializer<ReviewSummary> {
  @override
  final Iterable<Type> types = const [ReviewSummary, _$ReviewSummary];

  @override
  final String wireName = r'ReviewSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReviewSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'average';
    yield object.average == null ? null : serializers.serialize(
      object.average,
      specifiedType: const FullType.nullable(num),
    );
    yield r'distribution';
    yield serializers.serialize(
      object.distribution,
      specifiedType: const FullType(BuiltList, [FullType(ReviewRatingBucket)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReviewSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReviewSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        case r'average':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.average = valueDes;
          break;
        case r'distribution':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ReviewRatingBucket)]),
          ) as BuiltList<ReviewRatingBucket>;
          result.distribution.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReviewSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReviewSummaryBuilder();
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


