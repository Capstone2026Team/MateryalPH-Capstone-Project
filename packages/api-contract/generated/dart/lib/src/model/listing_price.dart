//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_price.g.dart';

/// The ordinary public price per sale unit, a VAT-inclusive payable amount in centavos.
///
/// Properties:
/// * [unitPriceCentavos]
/// * [currency]
/// * [unitCode]
/// * [unitName]
/// * [packQuantity]
/// * [taxCategory]
/// * [vatLabel]
/// * [priceVersionId]
/// * [effectiveAt]
@BuiltValue()
abstract class ListingPrice implements Built<ListingPrice, ListingPriceBuilder> {
  @BuiltValueField(wireName: r'unit_price_centavos')
  int get unitPriceCentavos;

  @BuiltValueField(wireName: r'currency')
  ListingPriceCurrencyEnum get currency;
  // enum currencyEnum {  PHP,  };

  @BuiltValueField(wireName: r'unit_code')
  String get unitCode;

  @BuiltValueField(wireName: r'unit_name')
  String get unitName;

  @BuiltValueField(wireName: r'pack_quantity')
  String get packQuantity;

  @BuiltValueField(wireName: r'tax_category')
  ListingPriceTaxCategoryEnum get taxCategory;
  // enum taxCategoryEnum {  VAT_12,  VAT_ZERO,  VAT_EXEMPT,  NON_VAT,  };

  @BuiltValueField(wireName: r'vat_label')
  String get vatLabel;

  @BuiltValueField(wireName: r'price_version_id')
  String get priceVersionId;

  @BuiltValueField(wireName: r'effective_at')
  DateTime get effectiveAt;

  ListingPrice._();

  factory ListingPrice([void updates(ListingPriceBuilder b)]) = _$ListingPrice;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingPriceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingPrice> get serializer => _$ListingPriceSerializer();
}

class _$ListingPriceSerializer implements PrimitiveSerializer<ListingPrice> {
  @override
  final Iterable<Type> types = const [ListingPrice, _$ListingPrice];

  @override
  final String wireName = r'ListingPrice';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingPrice object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'unit_price_centavos';
    yield serializers.serialize(
      object.unitPriceCentavos,
      specifiedType: const FullType(int),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(ListingPriceCurrencyEnum),
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
    yield r'tax_category';
    yield serializers.serialize(
      object.taxCategory,
      specifiedType: const FullType(ListingPriceTaxCategoryEnum),
    );
    yield r'vat_label';
    yield serializers.serialize(
      object.vatLabel,
      specifiedType: const FullType(String),
    );
    yield r'price_version_id';
    yield serializers.serialize(
      object.priceVersionId,
      specifiedType: const FullType(String),
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
    ListingPrice object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingPriceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(ListingPriceCurrencyEnum),
          ) as ListingPriceCurrencyEnum;
          result.currency = valueDes;
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
        case r'tax_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingPriceTaxCategoryEnum),
          ) as ListingPriceTaxCategoryEnum;
          result.taxCategory = valueDes;
          break;
        case r'vat_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vatLabel = valueDes;
          break;
        case r'price_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.priceVersionId = valueDes;
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
  ListingPrice deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingPriceBuilder();
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


class ListingPriceCurrencyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PHP')
  static const ListingPriceCurrencyEnum PHP = _$listingPriceCurrencyEnum_PHP;

  static Serializer<ListingPriceCurrencyEnum> get serializer => _$listingPriceCurrencyEnumSerializer;

  const ListingPriceCurrencyEnum._(String name): super(name);

  static BuiltSet<ListingPriceCurrencyEnum> get values => _$listingPriceCurrencyEnumValues;
  static ListingPriceCurrencyEnum valueOf(String name) => _$listingPriceCurrencyEnumValueOf(name);
}

class ListingPriceTaxCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VAT_12')
  static const ListingPriceTaxCategoryEnum VAT_12 = _$listingPriceTaxCategoryEnum_VAT_12;
  @BuiltValueEnumConst(wireName: r'VAT_ZERO')
  static const ListingPriceTaxCategoryEnum VAT_ZERO = _$listingPriceTaxCategoryEnum_VAT_ZERO;
  @BuiltValueEnumConst(wireName: r'VAT_EXEMPT')
  static const ListingPriceTaxCategoryEnum VAT_EXEMPT = _$listingPriceTaxCategoryEnum_VAT_EXEMPT;
  @BuiltValueEnumConst(wireName: r'NON_VAT')
  static const ListingPriceTaxCategoryEnum NON_VAT = _$listingPriceTaxCategoryEnum_NON_VAT;

  static Serializer<ListingPriceTaxCategoryEnum> get serializer => _$listingPriceTaxCategoryEnumSerializer;

  const ListingPriceTaxCategoryEnum._(String name): super(name);

  static BuiltSet<ListingPriceTaxCategoryEnum> get values => _$listingPriceTaxCategoryEnumValues;
  static ListingPriceTaxCategoryEnum valueOf(String name) => _$listingPriceTaxCategoryEnumValueOf(name);
}

