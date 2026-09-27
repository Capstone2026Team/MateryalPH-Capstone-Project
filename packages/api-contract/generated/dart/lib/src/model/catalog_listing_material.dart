//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_listing_material.g.dart';

/// CatalogListingMaterial
///
/// Properties:
/// * [id]
/// * [code]
/// * [name]
/// * [regulated]
@BuiltValue()
abstract class CatalogListingMaterial implements Built<CatalogListingMaterial, CatalogListingMaterialBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'regulated')
  bool get regulated;

  CatalogListingMaterial._();

  factory CatalogListingMaterial([void updates(CatalogListingMaterialBuilder b)]) = _$CatalogListingMaterial;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogListingMaterialBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogListingMaterial> get serializer => _$CatalogListingMaterialSerializer();
}

class _$CatalogListingMaterialSerializer implements PrimitiveSerializer<CatalogListingMaterial> {
  @override
  final Iterable<Type> types = const [CatalogListingMaterial, _$CatalogListingMaterial];

  @override
  final String wireName = r'CatalogListingMaterial';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogListingMaterial object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'regulated';
    yield serializers.serialize(
      object.regulated,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogListingMaterial object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogListingMaterialBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'regulated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.regulated = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogListingMaterial deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogListingMaterialBuilder();
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


