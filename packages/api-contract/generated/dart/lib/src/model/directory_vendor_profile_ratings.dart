//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/directory_vendor_profile_ratings_product.dart';
import 'package:materyalph_api_client/src/model/directory_vendor_profile_ratings_store.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_vendor_profile_ratings.g.dart';

/// DirectoryVendorProfileRatings
///
/// Properties:
/// * [store]
/// * [product]
@BuiltValue()
abstract class DirectoryVendorProfileRatings implements Built<DirectoryVendorProfileRatings, DirectoryVendorProfileRatingsBuilder> {
  @BuiltValueField(wireName: r'store')
  DirectoryVendorProfileRatingsStore get store;

  @BuiltValueField(wireName: r'product')
  DirectoryVendorProfileRatingsProduct get product;

  DirectoryVendorProfileRatings._();

  factory DirectoryVendorProfileRatings([void updates(DirectoryVendorProfileRatingsBuilder b)]) = _$DirectoryVendorProfileRatings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryVendorProfileRatingsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryVendorProfileRatings> get serializer => _$DirectoryVendorProfileRatingsSerializer();
}

class _$DirectoryVendorProfileRatingsSerializer implements PrimitiveSerializer<DirectoryVendorProfileRatings> {
  @override
  final Iterable<Type> types = const [DirectoryVendorProfileRatings, _$DirectoryVendorProfileRatings];

  @override
  final String wireName = r'DirectoryVendorProfileRatings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryVendorProfileRatings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'store';
    yield serializers.serialize(
      object.store,
      specifiedType: const FullType(DirectoryVendorProfileRatingsStore),
    );
    yield r'product';
    yield serializers.serialize(
      object.product,
      specifiedType: const FullType(DirectoryVendorProfileRatingsProduct),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryVendorProfileRatings object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryVendorProfileRatingsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'store':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryVendorProfileRatingsStore),
          ) as DirectoryVendorProfileRatingsStore;
          result.store.replace(valueDes);
          break;
        case r'product':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryVendorProfileRatingsProduct),
          ) as DirectoryVendorProfileRatingsProduct;
          result.product.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectoryVendorProfileRatings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryVendorProfileRatingsBuilder();
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


