//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/google_content_author.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'google_place_photo.g.dart';

/// GooglePlacePhoto
///
/// Properties:
/// * [uri] - Ephemeral Google media URL. Never persist or cache.
/// * [authors]
/// * [googleMapsUri]
@BuiltValue()
abstract class GooglePlacePhoto implements Built<GooglePlacePhoto, GooglePlacePhotoBuilder> {
  /// Ephemeral Google media URL. Never persist or cache.
  @BuiltValueField(wireName: r'uri')
  String get uri;

  @BuiltValueField(wireName: r'authors')
  BuiltList<GoogleContentAuthor> get authors;

  @BuiltValueField(wireName: r'google_maps_uri')
  String? get googleMapsUri;

  GooglePlacePhoto._();

  factory GooglePlacePhoto([void updates(GooglePlacePhotoBuilder b)]) = _$GooglePlacePhoto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GooglePlacePhotoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GooglePlacePhoto> get serializer => _$GooglePlacePhotoSerializer();
}

class _$GooglePlacePhotoSerializer implements PrimitiveSerializer<GooglePlacePhoto> {
  @override
  final Iterable<Type> types = const [GooglePlacePhoto, _$GooglePlacePhoto];

  @override
  final String wireName = r'GooglePlacePhoto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GooglePlacePhoto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'uri';
    yield serializers.serialize(
      object.uri,
      specifiedType: const FullType(String),
    );
    yield r'authors';
    yield serializers.serialize(
      object.authors,
      specifiedType: const FullType(BuiltList, [FullType(GoogleContentAuthor)]),
    );
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
    GooglePlacePhoto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GooglePlacePhotoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'uri':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uri = valueDes;
          break;
        case r'authors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GoogleContentAuthor)]),
          ) as BuiltList<GoogleContentAuthor>;
          result.authors.replace(valueDes);
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
  GooglePlacePhoto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GooglePlacePhotoBuilder();
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


