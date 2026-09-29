//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_image.g.dart';

/// ListingImage
///
/// Properties:
/// * [url] - Validated public media only.
/// * [altText]
@BuiltValue()
abstract class ListingImage implements Built<ListingImage, ListingImageBuilder> {
  /// Validated public media only.
  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'alt_text')
  String? get altText;

  ListingImage._();

  factory ListingImage([void updates(ListingImageBuilder b)]) = _$ListingImage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingImageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingImage> get serializer => _$ListingImageSerializer();
}

class _$ListingImageSerializer implements PrimitiveSerializer<ListingImage> {
  @override
  final Iterable<Type> types = const [ListingImage, _$ListingImage];

  @override
  final String wireName = r'ListingImage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingImage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'alt_text';
    yield object.altText == null ? null : serializers.serialize(
      object.altText,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingImage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingImageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'alt_text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.altText = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingImage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingImageBuilder();
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


