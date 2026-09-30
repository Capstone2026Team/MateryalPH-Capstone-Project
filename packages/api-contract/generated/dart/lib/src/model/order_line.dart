//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/tax_category.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/listing_image.dart';
import 'package:materyalph_api_client/src/model/order_volume_tier.dart';
import 'package:materyalph_api_client/src/model/order_line_inventory.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_line.g.dart';

/// OrderLine
///
/// Properties:
/// * [id]
/// * [lineNumber]
/// * [listingId]
/// * [listingVariantId]
/// * [displayName]
/// * [variantLabel]
/// * [brand]
/// * [category]
/// * [image]
/// * [unitCode]
/// * [unitName]
/// * [unitPrecision]
/// * [quantityStep]
/// * [requestedQuantity]
/// * [confirmedQuantity] - Null until a Vendor version exists.
/// * [unitPriceCentavos] - Frozen submission price with the frozen volume tier re-applied to the confirmed quantity.
/// * [ordinaryUnitPriceCentavos]
/// * [volumeTierApplied]
/// * [volumeTiers]
/// * [grossCentavos]
/// * [discountCentavos]
/// * [lineTotalCentavos]
/// * [includedVatCentavos]
/// * [taxCategory]
/// * [vatLabel]
/// * [change]
/// * [priceVersionId]
/// * [inventory]
@BuiltValue()
abstract class OrderLine implements Built<OrderLine, OrderLineBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'line_number')
  int get lineNumber;

  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  @BuiltValueField(wireName: r'listing_variant_id')
  String get listingVariantId;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'variant_label')
  String? get variantLabel;

  @BuiltValueField(wireName: r'brand')
  String? get brand;

  @BuiltValueField(wireName: r'category')
  String? get category;

  @BuiltValueField(wireName: r'image')
  ListingImage? get image;

  @BuiltValueField(wireName: r'unit_code')
  String get unitCode;

  @BuiltValueField(wireName: r'unit_name')
  String get unitName;

  @BuiltValueField(wireName: r'unit_precision')
  int get unitPrecision;

  @BuiltValueField(wireName: r'quantity_step')
  String get quantityStep;

  @BuiltValueField(wireName: r'requested_quantity')
  String get requestedQuantity;

  /// Null until a Vendor version exists.
  @BuiltValueField(wireName: r'confirmed_quantity')
  String? get confirmedQuantity;

  /// Frozen submission price with the frozen volume tier re-applied to the confirmed quantity.
  @BuiltValueField(wireName: r'unit_price_centavos')
  int get unitPriceCentavos;

  @BuiltValueField(wireName: r'ordinary_unit_price_centavos')
  int? get ordinaryUnitPriceCentavos;

  @BuiltValueField(wireName: r'volume_tier_applied')
  bool get volumeTierApplied;

  @BuiltValueField(wireName: r'volume_tiers')
  BuiltList<OrderVolumeTier> get volumeTiers;

  @BuiltValueField(wireName: r'gross_centavos')
  int get grossCentavos;

  @BuiltValueField(wireName: r'discount_centavos')
  int get discountCentavos;

  @BuiltValueField(wireName: r'line_total_centavos')
  int get lineTotalCentavos;

  @BuiltValueField(wireName: r'included_vat_centavos')
  int get includedVatCentavos;

  @BuiltValueField(wireName: r'tax_category')
  TaxCategory get taxCategory;
  // enum taxCategoryEnum {  VAT_12,  VAT_ZERO,  VAT_EXEMPT,  NON_VAT,  };

  @BuiltValueField(wireName: r'vat_label')
  String get vatLabel;

  @BuiltValueField(wireName: r'change')
  OrderLineChangeEnum? get change;
  // enum changeEnum {  QUANTITY_REDUCED,  LINE_REMOVED,  ,  };

  @BuiltValueField(wireName: r'price_version_id')
  String? get priceVersionId;

  @BuiltValueField(wireName: r'inventory')
  OrderLineInventory? get inventory;

  OrderLine._();

  factory OrderLine([void updates(OrderLineBuilder b)]) = _$OrderLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderLine> get serializer => _$OrderLineSerializer();
}

class _$OrderLineSerializer implements PrimitiveSerializer<OrderLine> {
  @override
  final Iterable<Type> types = const [OrderLine, _$OrderLine];

  @override
  final String wireName = r'OrderLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'line_number';
    yield serializers.serialize(
      object.lineNumber,
      specifiedType: const FullType(int),
    );
    yield r'listing_id';
    yield serializers.serialize(
      object.listingId,
      specifiedType: const FullType(String),
    );
    yield r'listing_variant_id';
    yield serializers.serialize(
      object.listingVariantId,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'variant_label';
    yield object.variantLabel == null ? null : serializers.serialize(
      object.variantLabel,
      specifiedType: const FullType.nullable(String),
    );
    yield r'brand';
    yield object.brand == null ? null : serializers.serialize(
      object.brand,
      specifiedType: const FullType.nullable(String),
    );
    yield r'category';
    yield object.category == null ? null : serializers.serialize(
      object.category,
      specifiedType: const FullType.nullable(String),
    );
    yield r'image';
    yield object.image == null ? null : serializers.serialize(
      object.image,
      specifiedType: const FullType.nullable(ListingImage),
    );
    yield r'unit_code';
    yield serializers.serialize(
      object.unitCode,
      specifiedType: const FullType(String),
    );
    yield r'unit_name';
    yield serializers.serialize(
      object.unitName,
      specifiedType: const FullType(String),
    );
    yield r'unit_precision';
    yield serializers.serialize(
      object.unitPrecision,
      specifiedType: const FullType(int),
    );
    yield r'quantity_step';
    yield serializers.serialize(
      object.quantityStep,
      specifiedType: const FullType(String),
    );
    yield r'requested_quantity';
    yield serializers.serialize(
      object.requestedQuantity,
      specifiedType: const FullType(String),
    );
    yield r'confirmed_quantity';
    yield object.confirmedQuantity == null ? null : serializers.serialize(
      object.confirmedQuantity,
      specifiedType: const FullType.nullable(String),
    );
    yield r'unit_price_centavos';
    yield serializers.serialize(
      object.unitPriceCentavos,
      specifiedType: const FullType(int),
    );
    yield r'ordinary_unit_price_centavos';
    yield object.ordinaryUnitPriceCentavos == null ? null : serializers.serialize(
      object.ordinaryUnitPriceCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'volume_tier_applied';
    yield serializers.serialize(
      object.volumeTierApplied,
      specifiedType: const FullType(bool),
    );
    yield r'volume_tiers';
    yield serializers.serialize(
      object.volumeTiers,
      specifiedType: const FullType(BuiltList, [FullType(OrderVolumeTier)]),
    );
    yield r'gross_centavos';
    yield serializers.serialize(
      object.grossCentavos,
      specifiedType: const FullType(int),
    );
    yield r'discount_centavos';
    yield serializers.serialize(
      object.discountCentavos,
      specifiedType: const FullType(int),
    );
    yield r'line_total_centavos';
    yield serializers.serialize(
      object.lineTotalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'included_vat_centavos';
    yield serializers.serialize(
      object.includedVatCentavos,
      specifiedType: const FullType(int),
    );
    yield r'tax_category';
    yield serializers.serialize(
      object.taxCategory,
      specifiedType: const FullType(TaxCategory),
    );
    yield r'vat_label';
    yield serializers.serialize(
      object.vatLabel,
      specifiedType: const FullType(String),
    );
    yield r'change';
    yield object.change == null ? null : serializers.serialize(
      object.change,
      specifiedType: const FullType.nullable(OrderLineChangeEnum),
    );
    yield r'price_version_id';
    yield object.priceVersionId == null ? null : serializers.serialize(
      object.priceVersionId,
      specifiedType: const FullType.nullable(String),
    );
    if (object.inventory != null) {
      yield r'inventory';
      yield serializers.serialize(
        object.inventory,
        specifiedType: const FullType.nullable(OrderLineInventory),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderLineBuilder result,
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
        case r'line_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lineNumber = valueDes;
          break;
        case r'listing_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingId = valueDes;
          break;
        case r'listing_variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingVariantId = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'variant_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.variantLabel = valueDes;
          break;
        case r'brand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.brand = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.category = valueDes;
          break;
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingImage),
          ) as ListingImage?;
          if (valueDes == null) continue;
          result.image.replace(valueDes);
          break;
        case r'unit_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitCode = valueDes;
          break;
        case r'unit_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitName = valueDes;
          break;
        case r'unit_precision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unitPrecision = valueDes;
          break;
        case r'quantity_step':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantityStep = valueDes;
          break;
        case r'requested_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.requestedQuantity = valueDes;
          break;
        case r'confirmed_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.confirmedQuantity = valueDes;
          break;
        case r'unit_price_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unitPriceCentavos = valueDes;
          break;
        case r'ordinary_unit_price_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.ordinaryUnitPriceCentavos = valueDes;
          break;
        case r'volume_tier_applied':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.volumeTierApplied = valueDes;
          break;
        case r'volume_tiers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OrderVolumeTier)]),
          ) as BuiltList<OrderVolumeTier>;
          result.volumeTiers.replace(valueDes);
          break;
        case r'gross_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.grossCentavos = valueDes;
          break;
        case r'discount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.discountCentavos = valueDes;
          break;
        case r'line_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lineTotalCentavos = valueDes;
          break;
        case r'included_vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.includedVatCentavos = valueDes;
          break;
        case r'tax_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TaxCategory),
          ) as TaxCategory;
          result.taxCategory = valueDes;
          break;
        case r'vat_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vatLabel = valueDes;
          break;
        case r'change':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderLineChangeEnum),
          ) as OrderLineChangeEnum?;
          if (valueDes == null) continue;
          result.change = valueDes;
          break;
        case r'price_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.priceVersionId = valueDes;
          break;
        case r'inventory':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderLineInventory),
          ) as OrderLineInventory?;
          if (valueDes == null) continue;
          result.inventory.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderLineBuilder();
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


class OrderLineChangeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'QUANTITY_REDUCED')
  static const OrderLineChangeEnum QUANTITY_REDUCED = _$orderLineChangeEnum_QUANTITY_REDUCED;
  @BuiltValueEnumConst(wireName: r'LINE_REMOVED')
  static const OrderLineChangeEnum LINE_REMOVED = _$orderLineChangeEnum_LINE_REMOVED;

  static Serializer<OrderLineChangeEnum> get serializer => _$orderLineChangeEnumSerializer;

  const OrderLineChangeEnum._(String name): super(name);

  static BuiltSet<OrderLineChangeEnum> get values => _$orderLineChangeEnumValues;
  static OrderLineChangeEnum valueOf(String name) => _$orderLineChangeEnumValueOf(name);
}

