//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/regulated_material_rule.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_material.g.dart';

/// CatalogMaterial
///
/// Properties:
/// * [id]
/// * [code]
/// * [name]
/// * [regulated]
/// * [categoryId]
/// * [categoryName]
/// * [canonicalUnitId]
/// * [compatibleUnitIds]
/// * [suggestedTagIds]
/// * [regulatedRule]
@BuiltValue()
abstract class CatalogMaterial implements Built<CatalogMaterial, CatalogMaterialBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'regulated')
  bool get regulated;

  @BuiltValueField(wireName: r'category_id')
  String get categoryId;

  @BuiltValueField(wireName: r'category_name')
  String get categoryName;

  @BuiltValueField(wireName: r'canonical_unit_id')
  String get canonicalUnitId;

  @BuiltValueField(wireName: r'compatible_unit_ids')
  BuiltList<String> get compatibleUnitIds;

  @BuiltValueField(wireName: r'suggested_tag_ids')
  BuiltList<String> get suggestedTagIds;

  @BuiltValueField(wireName: r'regulated_rule')
  RegulatedMaterialRule? get regulatedRule;

  CatalogMaterial._();

  factory CatalogMaterial([void updates(CatalogMaterialBuilder b)]) = _$CatalogMaterial;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogMaterialBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogMaterial> get serializer => _$CatalogMaterialSerializer();
}

class _$CatalogMaterialSerializer implements PrimitiveSerializer<CatalogMaterial> {
  @override
  final Iterable<Type> types = const [CatalogMaterial, _$CatalogMaterial];

  @override
  final String wireName = r'CatalogMaterial';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogMaterial object, {
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
    yield r'category_id';
    yield serializers.serialize(
      object.categoryId,
      specifiedType: const FullType(String),
    );
    yield r'category_name';
    yield serializers.serialize(
      object.categoryName,
      specifiedType: const FullType(String),
    );
    yield r'canonical_unit_id';
    yield serializers.serialize(
      object.canonicalUnitId,
      specifiedType: const FullType(String),
    );
    yield r'compatible_unit_ids';
    yield serializers.serialize(
      object.compatibleUnitIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'suggested_tag_ids';
    yield serializers.serialize(
      object.suggestedTagIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    if (object.regulatedRule != null) {
      yield r'regulated_rule';
      yield serializers.serialize(
        object.regulatedRule,
        specifiedType: const FullType.nullable(RegulatedMaterialRule),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogMaterial object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogMaterialBuilder result,
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
        case r'category_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoryId = valueDes;
          break;
        case r'category_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoryName = valueDes;
          break;
        case r'canonical_unit_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.canonicalUnitId = valueDes;
          break;
        case r'compatible_unit_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.compatibleUnitIds.replace(valueDes);
          break;
        case r'suggested_tag_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.suggestedTagIds.replace(valueDes);
          break;
        case r'regulated_rule':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RegulatedMaterialRule),
          ) as RegulatedMaterialRule?;
          if (valueDes == null) continue;
          result.regulatedRule.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogMaterial deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogMaterialBuilder();
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


