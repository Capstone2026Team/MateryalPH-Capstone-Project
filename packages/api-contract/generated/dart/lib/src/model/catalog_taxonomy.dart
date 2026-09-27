//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/catalog_reference.dart';
import 'package:materyalph_api_client/src/model/tax_category.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/catalog_limits.dart';
import 'package:materyalph_api_client/src/model/catalog_unit.dart';
import 'package:materyalph_api_client/src/model/catalog_attribute_definition.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_taxonomy.g.dart';

/// CatalogTaxonomy
///
/// Properties:
/// * [categories]
/// * [units]
/// * [tags]
/// * [attributeDefinitions]
/// * [taxCategories]
/// * [allowedTaxCategories] - Empty when the reviewed VAT classification is unknown.
/// * [limits]
@BuiltValue()
abstract class CatalogTaxonomy implements Built<CatalogTaxonomy, CatalogTaxonomyBuilder> {
  @BuiltValueField(wireName: r'categories')
  BuiltList<CatalogReference> get categories;

  @BuiltValueField(wireName: r'units')
  BuiltList<CatalogUnit> get units;

  @BuiltValueField(wireName: r'tags')
  BuiltList<CatalogReference> get tags;

  @BuiltValueField(wireName: r'attribute_definitions')
  BuiltList<CatalogAttributeDefinition> get attributeDefinitions;

  @BuiltValueField(wireName: r'tax_categories')
  BuiltList<TaxCategory> get taxCategories;

  /// Empty when the reviewed VAT classification is unknown.
  @BuiltValueField(wireName: r'allowed_tax_categories')
  BuiltList<TaxCategory> get allowedTaxCategories;

  @BuiltValueField(wireName: r'limits')
  CatalogLimits get limits;

  CatalogTaxonomy._();

  factory CatalogTaxonomy([void updates(CatalogTaxonomyBuilder b)]) = _$CatalogTaxonomy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogTaxonomyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogTaxonomy> get serializer => _$CatalogTaxonomySerializer();
}

class _$CatalogTaxonomySerializer implements PrimitiveSerializer<CatalogTaxonomy> {
  @override
  final Iterable<Type> types = const [CatalogTaxonomy, _$CatalogTaxonomy];

  @override
  final String wireName = r'CatalogTaxonomy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogTaxonomy object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [FullType(CatalogReference)]),
    );
    yield r'units';
    yield serializers.serialize(
      object.units,
      specifiedType: const FullType(BuiltList, [FullType(CatalogUnit)]),
    );
    yield r'tags';
    yield serializers.serialize(
      object.tags,
      specifiedType: const FullType(BuiltList, [FullType(CatalogReference)]),
    );
    yield r'attribute_definitions';
    yield serializers.serialize(
      object.attributeDefinitions,
      specifiedType: const FullType(BuiltList, [FullType(CatalogAttributeDefinition)]),
    );
    yield r'tax_categories';
    yield serializers.serialize(
      object.taxCategories,
      specifiedType: const FullType(BuiltList, [FullType(TaxCategory)]),
    );
    yield r'allowed_tax_categories';
    yield serializers.serialize(
      object.allowedTaxCategories,
      specifiedType: const FullType(BuiltList, [FullType(TaxCategory)]),
    );
    yield r'limits';
    yield serializers.serialize(
      object.limits,
      specifiedType: const FullType(CatalogLimits),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogTaxonomy object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogTaxonomyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CatalogReference)]),
          ) as BuiltList<CatalogReference>;
          result.categories.replace(valueDes);
          break;
        case r'units':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CatalogUnit)]),
          ) as BuiltList<CatalogUnit>;
          result.units.replace(valueDes);
          break;
        case r'tags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CatalogReference)]),
          ) as BuiltList<CatalogReference>;
          result.tags.replace(valueDes);
          break;
        case r'attribute_definitions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CatalogAttributeDefinition)]),
          ) as BuiltList<CatalogAttributeDefinition>;
          result.attributeDefinitions.replace(valueDes);
          break;
        case r'tax_categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TaxCategory)]),
          ) as BuiltList<TaxCategory>;
          result.taxCategories.replace(valueDes);
          break;
        case r'allowed_tax_categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TaxCategory)]),
          ) as BuiltList<TaxCategory>;
          result.allowedTaxCategories.replace(valueDes);
          break;
        case r'limits':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CatalogLimits),
          ) as CatalogLimits;
          result.limits.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogTaxonomy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogTaxonomyBuilder();
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


