//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/google_place_photo.dart';
import 'package:materyalph_api_client/src/model/google_content_author.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_supplier_photo.g.dart';

/// DirectorySupplierPhoto
///
/// Properties:
/// * [photos]
/// * [providerAttributions]
@BuiltValue()
abstract class DirectorySupplierPhoto implements Built<DirectorySupplierPhoto, DirectorySupplierPhotoBuilder> {
  @BuiltValueField(wireName: r'photos')
  BuiltList<GooglePlacePhoto> get photos;

  @BuiltValueField(wireName: r'provider_attributions')
  BuiltList<GoogleContentAuthor> get providerAttributions;

  DirectorySupplierPhoto._();

  factory DirectorySupplierPhoto([void updates(DirectorySupplierPhotoBuilder b)]) = _$DirectorySupplierPhoto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectorySupplierPhotoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectorySupplierPhoto> get serializer => _$DirectorySupplierPhotoSerializer();
}

class _$DirectorySupplierPhotoSerializer implements PrimitiveSerializer<DirectorySupplierPhoto> {
  @override
  final Iterable<Type> types = const [DirectorySupplierPhoto, _$DirectorySupplierPhoto];

  @override
  final String wireName = r'DirectorySupplierPhoto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectorySupplierPhoto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'photos';
    yield serializers.serialize(
      object.photos,
      specifiedType: const FullType(BuiltList, [FullType(GooglePlacePhoto)]),
    );
    yield r'provider_attributions';
    yield serializers.serialize(
      object.providerAttributions,
      specifiedType: const FullType(BuiltList, [FullType(GoogleContentAuthor)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectorySupplierPhoto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectorySupplierPhotoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'photos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GooglePlacePhoto)]),
          ) as BuiltList<GooglePlacePhoto>;
          result.photos.replace(valueDes);
          break;
        case r'provider_attributions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GoogleContentAuthor)]),
          ) as BuiltList<GoogleContentAuthor>;
          result.providerAttributions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectorySupplierPhoto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectorySupplierPhotoBuilder();
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


