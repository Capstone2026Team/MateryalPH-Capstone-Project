//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_limits.g.dart';

/// CatalogLimits
///
/// Properties:
/// * [maxVariants]
/// * [maxMedia]
/// * [maxListingImageKb]
/// * [imageTypes]
@BuiltValue()
abstract class CatalogLimits implements Built<CatalogLimits, CatalogLimitsBuilder> {
  @BuiltValueField(wireName: r'max_variants')
  int get maxVariants;

  @BuiltValueField(wireName: r'max_media')
  int get maxMedia;

  @BuiltValueField(wireName: r'max_listing_image_kb')
  int get maxListingImageKb;

  @BuiltValueField(wireName: r'image_types')
  BuiltList<String> get imageTypes;

  CatalogLimits._();

  factory CatalogLimits([void updates(CatalogLimitsBuilder b)]) = _$CatalogLimits;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogLimitsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogLimits> get serializer => _$CatalogLimitsSerializer();
}

class _$CatalogLimitsSerializer implements PrimitiveSerializer<CatalogLimits> {
  @override
  final Iterable<Type> types = const [CatalogLimits, _$CatalogLimits];

  @override
  final String wireName = r'CatalogLimits';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogLimits object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'max_variants';
    yield serializers.serialize(
      object.maxVariants,
      specifiedType: const FullType(int),
    );
    yield r'max_media';
    yield serializers.serialize(
      object.maxMedia,
      specifiedType: const FullType(int),
    );
    yield r'max_listing_image_kb';
    yield serializers.serialize(
      object.maxListingImageKb,
      specifiedType: const FullType(int),
    );
    yield r'image_types';
    yield serializers.serialize(
      object.imageTypes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogLimits object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogLimitsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'max_variants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maxVariants = valueDes;
          break;
        case r'max_media':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maxMedia = valueDes;
          break;
        case r'max_listing_image_kb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maxListingImageKb = valueDes;
          break;
        case r'image_types':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.imageTypes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogLimits deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogLimitsBuilder();
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


