//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/comparable_status.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/listing_variant_price.dart';
import 'package:materyalph_api_client/src/model/volume_tier.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_variant_offer.g.dart';

/// ListingVariantOffer
///
/// Properties:
/// * [variantId]
/// * [sku]
/// * [label]
/// * [attributes]
/// * [unitCode]
/// * [unitName]
/// * [packQuantity]
/// * [quantityStep] - Smallest quantity increment for this sale unit.
/// * [available]
/// * [availabilityNote]
/// * [stockLabel]
/// * [stockConfirmedAt]
/// * [price]
/// * [volumeTiers]
/// * [bestPrice]
/// * [comparable]
@BuiltValue()
abstract class ListingVariantOffer implements Built<ListingVariantOffer, ListingVariantOfferBuilder> {
  @BuiltValueField(wireName: r'variant_id')
  String get variantId;

  @BuiltValueField(wireName: r'sku')
  String get sku;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'attributes')
  BuiltMap<String, JsonObject?> get attributes;

  @BuiltValueField(wireName: r'unit_code')
  String get unitCode;

  @BuiltValueField(wireName: r'unit_name')
  String get unitName;

  @BuiltValueField(wireName: r'pack_quantity')
  String get packQuantity;

  /// Smallest quantity increment for this sale unit.
  @BuiltValueField(wireName: r'quantity_step')
  String get quantityStep;

  @BuiltValueField(wireName: r'available')
  bool get available;

  @BuiltValueField(wireName: r'availability_note')
  String? get availabilityNote;

  @BuiltValueField(wireName: r'stock_label')
  ListingVariantOfferStockLabelEnum? get stockLabel;
  // enum stockLabelEnum {  IN_STOCK,  LIMITED_STOCK,  ,  };

  @BuiltValueField(wireName: r'stock_confirmed_at')
  DateTime? get stockConfirmedAt;

  @BuiltValueField(wireName: r'price')
  ListingVariantPrice? get price;

  @BuiltValueField(wireName: r'volume_tiers')
  BuiltList<VolumeTier> get volumeTiers;

  @BuiltValueField(wireName: r'best_price')
  bool get bestPrice;

  @BuiltValueField(wireName: r'comparable')
  ComparableStatus? get comparable;

  ListingVariantOffer._();

  factory ListingVariantOffer([void updates(ListingVariantOfferBuilder b)]) = _$ListingVariantOffer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingVariantOfferBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingVariantOffer> get serializer => _$ListingVariantOfferSerializer();
}

class _$ListingVariantOfferSerializer implements PrimitiveSerializer<ListingVariantOffer> {
  @override
  final Iterable<Type> types = const [ListingVariantOffer, _$ListingVariantOffer];

  @override
  final String wireName = r'ListingVariantOffer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingVariantOffer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'variant_id';
    yield serializers.serialize(
      object.variantId,
      specifiedType: const FullType(String),
    );
    yield r'sku';
    yield serializers.serialize(
      object.sku,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield object.label == null ? null : serializers.serialize(
      object.label,
      specifiedType: const FullType.nullable(String),
    );
    yield r'attributes';
    yield serializers.serialize(
      object.attributes,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
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
    yield r'pack_quantity';
    yield serializers.serialize(
      object.packQuantity,
      specifiedType: const FullType(String),
    );
    yield r'quantity_step';
    yield serializers.serialize(
      object.quantityStep,
      specifiedType: const FullType(String),
    );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    yield r'availability_note';
    yield object.availabilityNote == null ? null : serializers.serialize(
      object.availabilityNote,
      specifiedType: const FullType.nullable(String),
    );
    yield r'stock_label';
    yield object.stockLabel == null ? null : serializers.serialize(
      object.stockLabel,
      specifiedType: const FullType.nullable(ListingVariantOfferStockLabelEnum),
    );
    yield r'stock_confirmed_at';
    yield object.stockConfirmedAt == null ? null : serializers.serialize(
      object.stockConfirmedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'price';
    yield object.price == null ? null : serializers.serialize(
      object.price,
      specifiedType: const FullType.nullable(ListingVariantPrice),
    );
    yield r'volume_tiers';
    yield serializers.serialize(
      object.volumeTiers,
      specifiedType: const FullType(BuiltList, [FullType(VolumeTier)]),
    );
    yield r'best_price';
    yield serializers.serialize(
      object.bestPrice,
      specifiedType: const FullType(bool),
    );
    yield r'comparable';
    yield object.comparable == null ? null : serializers.serialize(
      object.comparable,
      specifiedType: const FullType.nullable(ComparableStatus),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingVariantOffer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingVariantOfferBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.variantId = valueDes;
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
        case r'attributes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.attributes.replace(valueDes);
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
        case r'pack_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.packQuantity = valueDes;
          break;
        case r'quantity_step':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantityStep = valueDes;
          break;
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        case r'availability_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.availabilityNote = valueDes;
          break;
        case r'stock_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingVariantOfferStockLabelEnum),
          ) as ListingVariantOfferStockLabelEnum?;
          if (valueDes == null) continue;
          result.stockLabel = valueDes;
          break;
        case r'stock_confirmed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.stockConfirmedAt = valueDes;
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingVariantPrice),
          ) as ListingVariantPrice?;
          if (valueDes == null) continue;
          result.price.replace(valueDes);
          break;
        case r'volume_tiers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VolumeTier)]),
          ) as BuiltList<VolumeTier>;
          result.volumeTiers.replace(valueDes);
          break;
        case r'best_price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.bestPrice = valueDes;
          break;
        case r'comparable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ComparableStatus),
          ) as ComparableStatus?;
          if (valueDes == null) continue;
          result.comparable.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingVariantOffer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingVariantOfferBuilder();
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


class ListingVariantOfferStockLabelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'IN_STOCK')
  static const ListingVariantOfferStockLabelEnum IN_STOCK = _$listingVariantOfferStockLabelEnum_IN_STOCK;
  @BuiltValueEnumConst(wireName: r'LIMITED_STOCK')
  static const ListingVariantOfferStockLabelEnum LIMITED_STOCK = _$listingVariantOfferStockLabelEnum_LIMITED_STOCK;

  static Serializer<ListingVariantOfferStockLabelEnum> get serializer => _$listingVariantOfferStockLabelEnumSerializer;

  const ListingVariantOfferStockLabelEnum._(String name): super(name);

  static BuiltSet<ListingVariantOfferStockLabelEnum> get values => _$listingVariantOfferStockLabelEnumValues;
  static ListingVariantOfferStockLabelEnum valueOf(String name) => _$listingVariantOfferStockLabelEnumValueOf(name);
}

