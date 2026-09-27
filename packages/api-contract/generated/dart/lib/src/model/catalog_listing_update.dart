//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_listing_update.g.dart';

/// CatalogListingUpdate
///
/// Properties:
/// * [lockVersion]
/// * [displayName]
/// * [vendorSku]
/// * [description]
/// * [materialId]
/// * [materialMatch]
/// * [otherLabel]
/// * [materialCategoryId]
/// * [tagIds]
/// * [brand]
/// * [model]
/// * [manufacturer]
/// * [manufacturerAddress]
/// * [countryOfManufacture]
/// * [technicalAttributes]
@BuiltValue()
abstract class CatalogListingUpdate implements Built<CatalogListingUpdate, CatalogListingUpdateBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'display_name')
  String? get displayName;

  @BuiltValueField(wireName: r'vendor_sku')
  String? get vendorSku;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'material_id')
  String? get materialId;

  @BuiltValueField(wireName: r'material_match')
  CatalogListingUpdateMaterialMatchEnum? get materialMatch;
  // enum materialMatchEnum {  EXACT,  ALIAS,  FUZZY_CONFIRMED,  };

  @BuiltValueField(wireName: r'other_label')
  String? get otherLabel;

  @BuiltValueField(wireName: r'material_category_id')
  String? get materialCategoryId;

  @BuiltValueField(wireName: r'tag_ids')
  BuiltList<String>? get tagIds;

  @BuiltValueField(wireName: r'brand')
  String? get brand;

  @BuiltValueField(wireName: r'model')
  String? get model;

  @BuiltValueField(wireName: r'manufacturer')
  String? get manufacturer;

  @BuiltValueField(wireName: r'manufacturer_address')
  String? get manufacturerAddress;

  @BuiltValueField(wireName: r'country_of_manufacture')
  String? get countryOfManufacture;

  @BuiltValueField(wireName: r'technical_attributes')
  BuiltMap<String, String>? get technicalAttributes;

  CatalogListingUpdate._();

  factory CatalogListingUpdate([void updates(CatalogListingUpdateBuilder b)]) = _$CatalogListingUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogListingUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogListingUpdate> get serializer => _$CatalogListingUpdateSerializer();
}

class _$CatalogListingUpdateSerializer implements PrimitiveSerializer<CatalogListingUpdate> {
  @override
  final Iterable<Type> types = const [CatalogListingUpdate, _$CatalogListingUpdate];

  @override
  final String wireName = r'CatalogListingUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogListingUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.displayName != null) {
      yield r'display_name';
      yield serializers.serialize(
        object.displayName,
        specifiedType: const FullType(String),
      );
    }
    if (object.vendorSku != null) {
      yield r'vendor_sku';
      yield serializers.serialize(
        object.vendorSku,
        specifiedType: const FullType(String),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.materialId != null) {
      yield r'material_id';
      yield serializers.serialize(
        object.materialId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.materialMatch != null) {
      yield r'material_match';
      yield serializers.serialize(
        object.materialMatch,
        specifiedType: const FullType(CatalogListingUpdateMaterialMatchEnum),
      );
    }
    if (object.otherLabel != null) {
      yield r'other_label';
      yield serializers.serialize(
        object.otherLabel,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.materialCategoryId != null) {
      yield r'material_category_id';
      yield serializers.serialize(
        object.materialCategoryId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.tagIds != null) {
      yield r'tag_ids';
      yield serializers.serialize(
        object.tagIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.brand != null) {
      yield r'brand';
      yield serializers.serialize(
        object.brand,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.model != null) {
      yield r'model';
      yield serializers.serialize(
        object.model,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.manufacturer != null) {
      yield r'manufacturer';
      yield serializers.serialize(
        object.manufacturer,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.manufacturerAddress != null) {
      yield r'manufacturer_address';
      yield serializers.serialize(
        object.manufacturerAddress,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.countryOfManufacture != null) {
      yield r'country_of_manufacture';
      yield serializers.serialize(
        object.countryOfManufacture,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.technicalAttributes != null) {
      yield r'technical_attributes';
      yield serializers.serialize(
        object.technicalAttributes,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogListingUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogListingUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.displayName = valueDes;
          break;
        case r'vendor_sku':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vendorSku = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'material_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.materialId = valueDes;
          break;
        case r'material_match':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CatalogListingUpdateMaterialMatchEnum),
          ) as CatalogListingUpdateMaterialMatchEnum?;
          if (valueDes == null) continue;
          result.materialMatch = valueDes;
          break;
        case r'other_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.otherLabel = valueDes;
          break;
        case r'material_category_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.materialCategoryId = valueDes;
          break;
        case r'tag_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.tagIds.replace(valueDes);
          break;
        case r'brand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.brand = valueDes;
          break;
        case r'model':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.model = valueDes;
          break;
        case r'manufacturer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.manufacturer = valueDes;
          break;
        case r'manufacturer_address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.manufacturerAddress = valueDes;
          break;
        case r'country_of_manufacture':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.countryOfManufacture = valueDes;
          break;
        case r'technical_attributes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>?;
          if (valueDes == null) continue;
          result.technicalAttributes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogListingUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogListingUpdateBuilder();
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


class CatalogListingUpdateMaterialMatchEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'EXACT')
  static const CatalogListingUpdateMaterialMatchEnum EXACT = _$catalogListingUpdateMaterialMatchEnum_EXACT;
  @BuiltValueEnumConst(wireName: r'ALIAS')
  static const CatalogListingUpdateMaterialMatchEnum ALIAS = _$catalogListingUpdateMaterialMatchEnum_ALIAS;
  @BuiltValueEnumConst(wireName: r'FUZZY_CONFIRMED')
  static const CatalogListingUpdateMaterialMatchEnum FUZZY_CONFIRMED = _$catalogListingUpdateMaterialMatchEnum_FUZZY_CONFIRMED;

  static Serializer<CatalogListingUpdateMaterialMatchEnum> get serializer => _$catalogListingUpdateMaterialMatchEnumSerializer;

  const CatalogListingUpdateMaterialMatchEnum._(String name): super(name);

  static BuiltSet<CatalogListingUpdateMaterialMatchEnum> get values => _$catalogListingUpdateMaterialMatchEnumValues;
  static CatalogListingUpdateMaterialMatchEnum valueOf(String name) => _$catalogListingUpdateMaterialMatchEnumValueOf(name);
}

