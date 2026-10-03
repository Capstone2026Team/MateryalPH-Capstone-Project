//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_variant_price.g.dart';

/// ListingVariantPrice
///
/// Properties:
/// * [priceVersionId]
/// * [unitPriceCentavos]
/// * [currency]
/// * [taxCategory]
/// * [vatLabel]
/// * [includedVatCentavos] - FIN-02 money(L × 12 / 112) for VAT_12; included
/// * [effectiveAt]
@BuiltValue()
abstract class ListingVariantPrice implements Built<ListingVariantPrice, ListingVariantPriceBuilder> {
  @BuiltValueField(wireName: r'price_version_id')
  String get priceVersionId;

  @BuiltValueField(wireName: r'unit_price_centavos')
  int get unitPriceCentavos;

  @BuiltValueField(wireName: r'currency')
  ListingVariantPriceCurrencyEnum get currency;
  // enum currencyEnum {  PHP,  };

  @BuiltValueField(wireName: r'tax_category')
  ListingVariantPriceTaxCategoryEnum get taxCategory;
  // enum taxCategoryEnum {  VAT_12,  VAT_ZERO,  VAT_EXEMPT,  NON_VAT,  };

  @BuiltValueField(wireName: r'vat_label')
  String get vatLabel;

  /// FIN-02 money(L × 12 / 112) for VAT_12; included
  @BuiltValueField(wireName: r'included_vat_centavos')
  int get includedVatCentavos;

  @BuiltValueField(wireName: r'effective_at')
  DateTime get effectiveAt;

  ListingVariantPrice._();

  factory ListingVariantPrice([void updates(ListingVariantPriceBuilder b)]) = _$ListingVariantPrice;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingVariantPriceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingVariantPrice> get serializer => _$ListingVariantPriceSerializer();
}

class _$ListingVariantPriceSerializer implements PrimitiveSerializer<ListingVariantPrice> {
  @override
  final Iterable<Type> types = const [ListingVariantPrice, _$ListingVariantPrice];

  @override
  final String wireName = r'ListingVariantPrice';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingVariantPrice object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'price_version_id';
    yield serializers.serialize(
      object.priceVersionId,
      specifiedType: const FullType(String),
    );
    yield r'unit_price_centavos';
    yield serializers.serialize(
      object.unitPriceCentavos,
      specifiedType: const FullType(int),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(ListingVariantPriceCurrencyEnum),
    );
    yield r'tax_category';
    yield serializers.serialize(
      object.taxCategory,
      specifiedType: const FullType(ListingVariantPriceTaxCategoryEnum),
    );
    yield r'vat_label';
    yield serializers.serialize(
      object.vatLabel,
      specifiedType: const FullType(String),
    );
    yield r'included_vat_centavos';
    yield serializers.serialize(
      object.includedVatCentavos,
      specifiedType: const FullType(int),
    );
    yield r'effective_at';
    yield serializers.serialize(
      object.effectiveAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingVariantPrice object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingVariantPriceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'price_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.priceVersionId = valueDes;
          break;
        case r'unit_price_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unitPriceCentavos = valueDes;
          break;
        case r'currency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingVariantPriceCurrencyEnum),
          ) as ListingVariantPriceCurrencyEnum;
          result.currency = valueDes;
          break;
        case r'tax_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingVariantPriceTaxCategoryEnum),
          ) as ListingVariantPriceTaxCategoryEnum;
          result.taxCategory = valueDes;
          break;
        case r'vat_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vatLabel = valueDes;
          break;
        case r'included_vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.includedVatCentavos = valueDes;
          break;
        case r'effective_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.effectiveAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingVariantPrice deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingVariantPriceBuilder();
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


class ListingVariantPriceCurrencyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PHP')
  static const ListingVariantPriceCurrencyEnum PHP = _$listingVariantPriceCurrencyEnum_PHP;

  static Serializer<ListingVariantPriceCurrencyEnum> get serializer => _$listingVariantPriceCurrencyEnumSerializer;

  const ListingVariantPriceCurrencyEnum._(String name): super(name);

  static BuiltSet<ListingVariantPriceCurrencyEnum> get values => _$listingVariantPriceCurrencyEnumValues;
  static ListingVariantPriceCurrencyEnum valueOf(String name) => _$listingVariantPriceCurrencyEnumValueOf(name);
}

class ListingVariantPriceTaxCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VAT_12')
  static const ListingVariantPriceTaxCategoryEnum VAT_12 = _$listingVariantPriceTaxCategoryEnum_VAT_12;
  @BuiltValueEnumConst(wireName: r'VAT_ZERO')
  static const ListingVariantPriceTaxCategoryEnum VAT_ZERO = _$listingVariantPriceTaxCategoryEnum_VAT_ZERO;
  @BuiltValueEnumConst(wireName: r'VAT_EXEMPT')
  static const ListingVariantPriceTaxCategoryEnum VAT_EXEMPT = _$listingVariantPriceTaxCategoryEnum_VAT_EXEMPT;
  @BuiltValueEnumConst(wireName: r'NON_VAT')
  static const ListingVariantPriceTaxCategoryEnum NON_VAT = _$listingVariantPriceTaxCategoryEnum_NON_VAT;

  static Serializer<ListingVariantPriceTaxCategoryEnum> get serializer => _$listingVariantPriceTaxCategoryEnumSerializer;

  const ListingVariantPriceTaxCategoryEnum._(String name): super(name);

  static BuiltSet<ListingVariantPriceTaxCategoryEnum> get values => _$listingVariantPriceTaxCategoryEnumValues;
  static ListingVariantPriceTaxCategoryEnum valueOf(String name) => _$listingVariantPriceTaxCategoryEnumValueOf(name);
}

