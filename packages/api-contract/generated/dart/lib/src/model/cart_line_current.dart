//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cart_line_current.g.dart';

/// CartLineCurrent
///
/// Properties:
/// * [priceVersionId]
/// * [unitPriceCentavos]
/// * [taxCategory]
/// * [appliedUnitPriceCentavos] - CAT-PRICE-01 highest reached volume tier
/// * [appliedPriceVersionId]
/// * [volumeTierApplied]
/// * [stockLabel]
/// * [vacationMode]
@BuiltValue()
abstract class CartLineCurrent implements Built<CartLineCurrent, CartLineCurrentBuilder> {
  @BuiltValueField(wireName: r'price_version_id')
  String get priceVersionId;

  @BuiltValueField(wireName: r'unit_price_centavos')
  int get unitPriceCentavos;

  @BuiltValueField(wireName: r'tax_category')
  CartLineCurrentTaxCategoryEnum get taxCategory;
  // enum taxCategoryEnum {  VAT_12,  VAT_ZERO,  VAT_EXEMPT,  NON_VAT,  };

  /// CAT-PRICE-01 highest reached volume tier
  @BuiltValueField(wireName: r'applied_unit_price_centavos')
  int get appliedUnitPriceCentavos;

  @BuiltValueField(wireName: r'applied_price_version_id')
  String get appliedPriceVersionId;

  @BuiltValueField(wireName: r'volume_tier_applied')
  bool get volumeTierApplied;

  @BuiltValueField(wireName: r'stock_label')
  CartLineCurrentStockLabelEnum get stockLabel;
  // enum stockLabelEnum {  IN_STOCK,  LIMITED_STOCK,  OUT_OF_STOCK,  };

  @BuiltValueField(wireName: r'vacation_mode')
  bool get vacationMode;

  CartLineCurrent._();

  factory CartLineCurrent([void updates(CartLineCurrentBuilder b)]) = _$CartLineCurrent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CartLineCurrentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CartLineCurrent> get serializer => _$CartLineCurrentSerializer();
}

class _$CartLineCurrentSerializer implements PrimitiveSerializer<CartLineCurrent> {
  @override
  final Iterable<Type> types = const [CartLineCurrent, _$CartLineCurrent];

  @override
  final String wireName = r'CartLineCurrent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CartLineCurrent object, {
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
    yield r'tax_category';
    yield serializers.serialize(
      object.taxCategory,
      specifiedType: const FullType(CartLineCurrentTaxCategoryEnum),
    );
    yield r'applied_unit_price_centavos';
    yield serializers.serialize(
      object.appliedUnitPriceCentavos,
      specifiedType: const FullType(int),
    );
    yield r'applied_price_version_id';
    yield serializers.serialize(
      object.appliedPriceVersionId,
      specifiedType: const FullType(String),
    );
    yield r'volume_tier_applied';
    yield serializers.serialize(
      object.volumeTierApplied,
      specifiedType: const FullType(bool),
    );
    yield r'stock_label';
    yield serializers.serialize(
      object.stockLabel,
      specifiedType: const FullType(CartLineCurrentStockLabelEnum),
    );
    yield r'vacation_mode';
    yield serializers.serialize(
      object.vacationMode,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CartLineCurrent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CartLineCurrentBuilder result,
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
        case r'tax_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CartLineCurrentTaxCategoryEnum),
          ) as CartLineCurrentTaxCategoryEnum;
          result.taxCategory = valueDes;
          break;
        case r'applied_unit_price_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.appliedUnitPriceCentavos = valueDes;
          break;
        case r'applied_price_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.appliedPriceVersionId = valueDes;
          break;
        case r'volume_tier_applied':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.volumeTierApplied = valueDes;
          break;
        case r'stock_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CartLineCurrentStockLabelEnum),
          ) as CartLineCurrentStockLabelEnum;
          result.stockLabel = valueDes;
          break;
        case r'vacation_mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.vacationMode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CartLineCurrent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CartLineCurrentBuilder();
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


class CartLineCurrentTaxCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VAT_12')
  static const CartLineCurrentTaxCategoryEnum VAT_12 = _$cartLineCurrentTaxCategoryEnum_VAT_12;
  @BuiltValueEnumConst(wireName: r'VAT_ZERO')
  static const CartLineCurrentTaxCategoryEnum VAT_ZERO = _$cartLineCurrentTaxCategoryEnum_VAT_ZERO;
  @BuiltValueEnumConst(wireName: r'VAT_EXEMPT')
  static const CartLineCurrentTaxCategoryEnum VAT_EXEMPT = _$cartLineCurrentTaxCategoryEnum_VAT_EXEMPT;
  @BuiltValueEnumConst(wireName: r'NON_VAT')
  static const CartLineCurrentTaxCategoryEnum NON_VAT = _$cartLineCurrentTaxCategoryEnum_NON_VAT;

  static Serializer<CartLineCurrentTaxCategoryEnum> get serializer => _$cartLineCurrentTaxCategoryEnumSerializer;

  const CartLineCurrentTaxCategoryEnum._(String name): super(name);

  static BuiltSet<CartLineCurrentTaxCategoryEnum> get values => _$cartLineCurrentTaxCategoryEnumValues;
  static CartLineCurrentTaxCategoryEnum valueOf(String name) => _$cartLineCurrentTaxCategoryEnumValueOf(name);
}

class CartLineCurrentStockLabelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'IN_STOCK')
  static const CartLineCurrentStockLabelEnum IN_STOCK = _$cartLineCurrentStockLabelEnum_IN_STOCK;
  @BuiltValueEnumConst(wireName: r'LIMITED_STOCK')
  static const CartLineCurrentStockLabelEnum LIMITED_STOCK = _$cartLineCurrentStockLabelEnum_LIMITED_STOCK;
  @BuiltValueEnumConst(wireName: r'OUT_OF_STOCK')
  static const CartLineCurrentStockLabelEnum OUT_OF_STOCK = _$cartLineCurrentStockLabelEnum_OUT_OF_STOCK;

  static Serializer<CartLineCurrentStockLabelEnum> get serializer => _$cartLineCurrentStockLabelEnumSerializer;

  const CartLineCurrentStockLabelEnum._(String name): super(name);

  static BuiltSet<CartLineCurrentStockLabelEnum> get values => _$cartLineCurrentStockLabelEnumValues;
  static CartLineCurrentStockLabelEnum valueOf(String name) => _$cartLineCurrentStockLabelEnumValueOf(name);
}

