//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/google_content_author.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'google_place_review.g.dart';

/// GooglePlaceReview
///
/// Properties:
/// * [author]
/// * [rating]
/// * [text]
/// * [relativeTime]
/// * [googleMapsUri]
@BuiltValue()
abstract class GooglePlaceReview implements Built<GooglePlaceReview, GooglePlaceReviewBuilder> {
  @BuiltValueField(wireName: r'author')
  GoogleContentAuthor get author;

  @BuiltValueField(wireName: r'rating')
  double get rating;

  @BuiltValueField(wireName: r'text')
  String? get text;

  @BuiltValueField(wireName: r'relative_time')
  String? get relativeTime;

  @BuiltValueField(wireName: r'google_maps_uri')
  String? get googleMapsUri;

  GooglePlaceReview._();

  factory GooglePlaceReview([void updates(GooglePlaceReviewBuilder b)]) = _$GooglePlaceReview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GooglePlaceReviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GooglePlaceReview> get serializer => _$GooglePlaceReviewSerializer();
}

class _$GooglePlaceReviewSerializer implements PrimitiveSerializer<GooglePlaceReview> {
  @override
  final Iterable<Type> types = const [GooglePlaceReview, _$GooglePlaceReview];

  @override
  final String wireName = r'GooglePlaceReview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GooglePlaceReview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'author';
    yield serializers.serialize(
      object.author,
      specifiedType: const FullType(GoogleContentAuthor),
    );
    yield r'rating';
    yield serializers.serialize(
      object.rating,
      specifiedType: const FullType(double),
    );
    if (object.text != null) {
      yield r'text';
      yield serializers.serialize(
        object.text,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.relativeTime != null) {
      yield r'relative_time';
      yield serializers.serialize(
        object.relativeTime,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.googleMapsUri != null) {
      yield r'google_maps_uri';
      yield serializers.serialize(
        object.googleMapsUri,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GooglePlaceReview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GooglePlaceReviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'author':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GoogleContentAuthor),
          ) as GoogleContentAuthor;
          result.author.replace(valueDes);
          break;
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.rating = valueDes;
          break;
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.text = valueDes;
          break;
        case r'relative_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.relativeTime = valueDes;
          break;
        case r'google_maps_uri':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.googleMapsUri = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GooglePlaceReview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GooglePlaceReviewBuilder();
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


