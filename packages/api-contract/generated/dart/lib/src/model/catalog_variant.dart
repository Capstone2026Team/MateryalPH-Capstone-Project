//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/catalog_volume_tier.dart';
import 'package:materyalph_api_client/src/model/catalog_inventory.dart';
import 'package:materyalph_api_client/src/model/catalog_price.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_variant.g.dart';

/// CatalogVariant
///
/// Properties:
/// * [id]
/// * [sku]
/// * [label]
/// * [unitId]
/// * [unitCode]
/// * [packQuantity]
/// * [attributes]
/// * [active]
/// * [weightKg]
/// * [lengthCm]
/// * [widthCm]
/// * [heightCm]
/// * [lockVersion]
/// * [price]
/// * [volumeTiers]
/// * [inventory]
/// * [publicAvailability]
/// * [comparability]
@BuiltValue()
abstract class CatalogVariant implements Built<CatalogVariant, CatalogVariantBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'sku')
  String get sku;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'unit_id')
  String get unitId;

  @BuiltValueField(wireName: r'unit_code')
  String get unitCode;

  @BuiltValueField(wireName: r'pack_quantity')
  String get packQuantity;

  @BuiltValueField(wireName: r'attributes')
  BuiltMap<String, String> get attributes;

  @BuiltValueField(wireName: r'active')
  bool get active;

  @BuiltValueField(wireName: r'weight_kg')
  String? get weightKg;

  @BuiltValueField(wireName: r'length_cm')
  String? get lengthCm;

  @BuiltValueField(wireName: r'width_cm')
  String? get widthCm;

  @BuiltValueField(wireName: r'height_cm')
  String? get heightCm;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'price')
  CatalogPrice? get price;

  @BuiltValueField(wireName: r'volume_tiers')
  BuiltList<CatalogVolumeTier> get volumeTiers;

  @BuiltValueField(wireName: r'inventory')
  CatalogInventory? get inventory;

  @BuiltValueField(wireName: r'public_availability')
  CatalogVariantPublicAvailabilityEnum get publicAvailability;
  // enum publicAvailabilityEnum {  IN_STOCK,  LIMITED_STOCK,  OUT_OF_STOCK,  };

  @BuiltValueField(wireName: r'comparability')
  CatalogVariantComparabilityEnum get comparability;
  // enum comparabilityEnum {  COMPARABLE,  NOT_YET_COMPARABLE,  };

  CatalogVariant._();

  factory CatalogVariant([void updates(CatalogVariantBuilder b)]) = _$CatalogVariant;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogVariantBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogVariant> get serializer => _$CatalogVariantSerializer();
}

class _$CatalogVariantSerializer implements PrimitiveSerializer<CatalogVariant> {
  @override
  final Iterable<Type> types = const [CatalogVariant, _$CatalogVariant];

  @override
  final String wireName = r'CatalogVariant';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogVariant object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'sku';
    yield serializers.serialize(
      object.sku,
      specifiedType: const FullType(String),
    );
    if (object.label != null) {
      yield r'label';
      yield serializers.serialize(
        object.label,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'unit_id';
    yield serializers.serialize(
      object.unitId,
      specifiedType: const FullType(String),
    );
    yield r'unit_code';
    yield serializers.serialize(
      object.unitCode,
      specifiedType: const FullType(String),
    );
    yield r'pack_quantity';
    yield serializers.serialize(
      object.packQuantity,
      specifiedType: const FullType(String),
    );
    yield r'attributes';
    yield serializers.serialize(
      object.attributes,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(bool),
    );
    if (object.weightKg != null) {
      yield r'weight_kg';
      yield serializers.serialize(
        object.weightKg,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.lengthCm != null) {
      yield r'length_cm';
      yield serializers.serialize(
        object.lengthCm,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.widthCm != null) {
      yield r'width_cm';
      yield serializers.serialize(
        object.widthCm,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.heightCm != null) {
      yield r'height_cm';
      yield serializers.serialize(
        object.heightCm,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.price != null) {
      yield r'price';
      yield serializers.serialize(
        object.price,
        specifiedType: const FullType.nullable(CatalogPrice),
      );
    }
    yield r'volume_tiers';
    yield serializers.serialize(
      object.volumeTiers,
      specifiedType: const FullType(BuiltList, [FullType(CatalogVolumeTier)]),
    );
    if (object.inventory != null) {
      yield r'inventory';
      yield serializers.serialize(
        object.inventory,
        specifiedType: const FullType.nullable(CatalogInventory),
      );
    }
    yield r'public_availability';
    yield serializers.serialize(
      object.publicAvailability,
      specifiedType: const FullType(CatalogVariantPublicAvailabilityEnum),
    );
    yield r'comparability';
    yield serializers.serialize(
      object.comparability,
      specifiedType: const FullType(CatalogVariantComparabilityEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogVariant object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogVariantBuilder result,
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
        case r'sku':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sku = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'unit_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitId = valueDes;
          break;
        case r'unit_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitCode = valueDes;
          break;
        case r'pack_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.packQuantity = valueDes;
          break;
        case r'attributes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.attributes.replace(valueDes);
          break;
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.active = valueDes;
          break;
        case r'weight_kg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.weightKg = valueDes;
          break;
        case r'length_cm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lengthCm = valueDes;
          break;
        case r'width_cm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.widthCm = valueDes;
          break;
        case r'height_cm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.heightCm = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CatalogPrice),
          ) as CatalogPrice?;
          if (valueDes == null) continue;
          result.price.replace(valueDes);
          break;
        case r'volume_tiers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CatalogVolumeTier)]),
          ) as BuiltList<CatalogVolumeTier>;
          result.volumeTiers.replace(valueDes);
          break;
        case r'inventory':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CatalogInventory),
          ) as CatalogInventory?;
          if (valueDes == null) continue;
          result.inventory.replace(valueDes);
          break;
        case r'public_availability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CatalogVariantPublicAvailabilityEnum),
          ) as CatalogVariantPublicAvailabilityEnum;
          result.publicAvailability = valueDes;
          break;
        case r'comparability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CatalogVariantComparabilityEnum),
          ) as CatalogVariantComparabilityEnum;
          result.comparability = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogVariant deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogVariantBuilder();
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


class CatalogVariantPublicAvailabilityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'IN_STOCK')
  static const CatalogVariantPublicAvailabilityEnum IN_STOCK = _$catalogVariantPublicAvailabilityEnum_IN_STOCK;
  @BuiltValueEnumConst(wireName: r'LIMITED_STOCK')
  static const CatalogVariantPublicAvailabilityEnum LIMITED_STOCK = _$catalogVariantPublicAvailabilityEnum_LIMITED_STOCK;
  @BuiltValueEnumConst(wireName: r'OUT_OF_STOCK')
  static const CatalogVariantPublicAvailabilityEnum OUT_OF_STOCK = _$catalogVariantPublicAvailabilityEnum_OUT_OF_STOCK;

  static Serializer<CatalogVariantPublicAvailabilityEnum> get serializer => _$catalogVariantPublicAvailabilityEnumSerializer;

  const CatalogVariantPublicAvailabilityEnum._(String name): super(name);

  static BuiltSet<CatalogVariantPublicAvailabilityEnum> get values => _$catalogVariantPublicAvailabilityEnumValues;
  static CatalogVariantPublicAvailabilityEnum valueOf(String name) => _$catalogVariantPublicAvailabilityEnumValueOf(name);
}

class CatalogVariantComparabilityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COMPARABLE')
  static const CatalogVariantComparabilityEnum COMPARABLE = _$catalogVariantComparabilityEnum_COMPARABLE;
  @BuiltValueEnumConst(wireName: r'NOT_YET_COMPARABLE')
  static const CatalogVariantComparabilityEnum NOT_YET_COMPARABLE = _$catalogVariantComparabilityEnum_NOT_YET_COMPARABLE;

  static Serializer<CatalogVariantComparabilityEnum> get serializer => _$catalogVariantComparabilityEnumSerializer;

  const CatalogVariantComparabilityEnum._(String name): super(name);

  static BuiltSet<CatalogVariantComparabilityEnum> get values => _$catalogVariantComparabilityEnumValues;
  static CatalogVariantComparabilityEnum valueOf(String name) => _$catalogVariantComparabilityEnumValueOf(name);
}

