//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/tax_category.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/catalog_volume_tier_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_variant_input.g.dart';

/// CatalogVariantInput
///
/// Properties:
/// * [id]
/// * [sku]
/// * [label]
/// * [unitId]
/// * [packQuantity]
/// * [priceCentavos] - Ordinary single-sale VAT-inclusive payable price in centavos.
/// * [taxCategory]
/// * [taxBasis]
/// * [weightKg]
/// * [lengthCm]
/// * [widthCm]
/// * [heightCm]
/// * [quantityOnHand] - Counted physical stock; recording it confirms stock now.
/// * [active]
/// * [attributes]
/// * [volumeTiers] - Replaces the variant volume tiers when present (an empty list removes them); omitted keeps the current tiers.
@BuiltValue()
abstract class CatalogVariantInput implements Built<CatalogVariantInput, CatalogVariantInputBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'sku')
  String get sku;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'unit_id')
  String get unitId;

  @BuiltValueField(wireName: r'pack_quantity')
  String get packQuantity;

  /// Ordinary single-sale VAT-inclusive payable price in centavos.
  @BuiltValueField(wireName: r'price_centavos')
  int get priceCentavos;

  @BuiltValueField(wireName: r'tax_category')
  TaxCategory get taxCategory;
  // enum taxCategoryEnum {  VAT_12,  VAT_ZERO,  VAT_EXEMPT,  NON_VAT,  };

  @BuiltValueField(wireName: r'tax_basis')
  String? get taxBasis;

  @BuiltValueField(wireName: r'weight_kg')
  String? get weightKg;

  @BuiltValueField(wireName: r'length_cm')
  String? get lengthCm;

  @BuiltValueField(wireName: r'width_cm')
  String? get widthCm;

  @BuiltValueField(wireName: r'height_cm')
  String? get heightCm;

  /// Counted physical stock; recording it confirms stock now.
  @BuiltValueField(wireName: r'quantity_on_hand')
  String? get quantityOnHand;

  @BuiltValueField(wireName: r'active')
  bool? get active;

  @BuiltValueField(wireName: r'attributes')
  BuiltMap<String, String>? get attributes;

  /// Replaces the variant volume tiers when present (an empty list removes them); omitted keeps the current tiers.
  @BuiltValueField(wireName: r'volume_tiers')
  BuiltList<CatalogVolumeTierInput>? get volumeTiers;

  CatalogVariantInput._();

  factory CatalogVariantInput([void updates(CatalogVariantInputBuilder b)]) = _$CatalogVariantInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogVariantInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogVariantInput> get serializer => _$CatalogVariantInputSerializer();
}

class _$CatalogVariantInputSerializer implements PrimitiveSerializer<CatalogVariantInput> {
  @override
  final Iterable<Type> types = const [CatalogVariantInput, _$CatalogVariantInput];

  @override
  final String wireName = r'CatalogVariantInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogVariantInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    yield r'pack_quantity';
    yield serializers.serialize(
      object.packQuantity,
      specifiedType: const FullType(String),
    );
    yield r'price_centavos';
    yield serializers.serialize(
      object.priceCentavos,
      specifiedType: const FullType(int),
    );
    yield r'tax_category';
    yield serializers.serialize(
      object.taxCategory,
      specifiedType: const FullType(TaxCategory),
    );
    if (object.taxBasis != null) {
      yield r'tax_basis';
      yield serializers.serialize(
        object.taxBasis,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    if (object.quantityOnHand != null) {
      yield r'quantity_on_hand';
      yield serializers.serialize(
        object.quantityOnHand,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.active != null) {
      yield r'active';
      yield serializers.serialize(
        object.active,
        specifiedType: const FullType(bool),
      );
    }
    if (object.attributes != null) {
      yield r'attributes';
      yield serializers.serialize(
        object.attributes,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
      );
    }
    if (object.volumeTiers != null) {
      yield r'volume_tiers';
      yield serializers.serialize(
        object.volumeTiers,
        specifiedType: const FullType(BuiltList, [FullType(CatalogVolumeTierInput)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogVariantInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogVariantInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
        case r'pack_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.packQuantity = valueDes;
          break;
        case r'price_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.priceCentavos = valueDes;
          break;
        case r'tax_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TaxCategory),
          ) as TaxCategory;
          result.taxCategory = valueDes;
          break;
        case r'tax_basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.taxBasis = valueDes;
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
        case r'quantity_on_hand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.quantityOnHand = valueDes;
          break;
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.active = valueDes;
          break;
        case r'attributes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>?;
          if (valueDes == null) continue;
          result.attributes.replace(valueDes);
          break;
        case r'volume_tiers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(CatalogVolumeTierInput)]),
          ) as BuiltList<CatalogVolumeTierInput>?;
          if (valueDes == null) continue;
          result.volumeTiers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogVariantInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogVariantInputBuilder();
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


