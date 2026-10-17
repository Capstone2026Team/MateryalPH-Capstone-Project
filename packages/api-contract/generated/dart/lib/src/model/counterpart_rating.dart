//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/review_ratings.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counterpart_rating.g.dart';

/// CounterpartRating
///
/// Properties:
/// * [ratings]
/// * [comment]
/// * [displayName]
/// * [submittedAt]
@BuiltValue()
abstract class CounterpartRating implements Built<CounterpartRating, CounterpartRatingBuilder> {
  @BuiltValueField(wireName: r'ratings')
  ReviewRatings get ratings;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'submitted_at')
  DateTime? get submittedAt;

  CounterpartRating._();

  factory CounterpartRating([void updates(CounterpartRatingBuilder b)]) = _$CounterpartRating;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterpartRatingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterpartRating> get serializer => _$CounterpartRatingSerializer();
}

class _$CounterpartRatingSerializer implements PrimitiveSerializer<CounterpartRating> {
  @override
  final Iterable<Type> types = const [CounterpartRating, _$CounterpartRating];

  @override
  final String wireName = r'CounterpartRating';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterpartRating object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ratings';
    yield serializers.serialize(
      object.ratings,
      specifiedType: const FullType(ReviewRatings),
    );
    if (object.comment != null) {
      yield r'comment';
      yield serializers.serialize(
        object.comment,
        specifiedType: const FullType(String),
      );
    }
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    if (object.submittedAt != null) {
      yield r'submitted_at';
      yield serializers.serialize(
        object.submittedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterpartRating object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterpartRatingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ratings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReviewRatings),
          ) as ReviewRatings;
          result.ratings.replace(valueDes);
          break;
        case r'comment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.comment = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'submitted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.submittedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterpartRating deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterpartRatingBuilder();
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


