//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cart_item_update.g.dart';

/// Atomically edits an owned cart line. A listing_variant_id requires expected_price_version_id and must belong to the same listing. A duplicate option returns CART_VARIANT_ALREADY_EXISTS (409). fulfillment_method changes the entire Vendor group and retains all delivery eligibility checks. No stock is reserved.
///
/// Properties:
/// * [lockVersion]
/// * [quantity]
/// * [savedForLater]
/// * [acceptCurrentPrice]
/// * [listingVariantId]
/// * [expectedPriceVersionId]
/// * [fulfillmentMethod]
@BuiltValue()
abstract class CartItemUpdate implements Built<CartItemUpdate, CartItemUpdateBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'quantity')
  String? get quantity;

  @BuiltValueField(wireName: r'saved_for_later')
  bool? get savedForLater;

  @BuiltValueField(wireName: r'accept_current_price')
  bool? get acceptCurrentPrice;

  @BuiltValueField(wireName: r'listing_variant_id')
  String? get listingVariantId;

  @BuiltValueField(wireName: r'expected_price_version_id')
  String? get expectedPriceVersionId;

  @BuiltValueField(wireName: r'fulfillment_method')
  CartItemUpdateFulfillmentMethodEnum? get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  DELIVERY,  PICKUP,  };

  CartItemUpdate._();

  factory CartItemUpdate([void updates(CartItemUpdateBuilder b)]) = _$CartItemUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CartItemUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CartItemUpdate> get serializer => _$CartItemUpdateSerializer();
}

class _$CartItemUpdateSerializer implements PrimitiveSerializer<CartItemUpdate> {
  @override
  final Iterable<Type> types = const [CartItemUpdate, _$CartItemUpdate];

  @override
  final String wireName = r'CartItemUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CartItemUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.quantity != null) {
      yield r'quantity';
      yield serializers.serialize(
        object.quantity,
        specifiedType: const FullType(String),
      );
    }
    if (object.savedForLater != null) {
      yield r'saved_for_later';
      yield serializers.serialize(
        object.savedForLater,
        specifiedType: const FullType(bool),
      );
    }
    if (object.acceptCurrentPrice != null) {
      yield r'accept_current_price';
      yield serializers.serialize(
        object.acceptCurrentPrice,
        specifiedType: const FullType(bool),
      );
    }
    if (object.listingVariantId != null) {
      yield r'listing_variant_id';
      yield serializers.serialize(
        object.listingVariantId,
        specifiedType: const FullType(String),
      );
    }
    if (object.expectedPriceVersionId != null) {
      yield r'expected_price_version_id';
      yield serializers.serialize(
        object.expectedPriceVersionId,
        specifiedType: const FullType(String),
      );
    }
    if (object.fulfillmentMethod != null) {
      yield r'fulfillment_method';
      yield serializers.serialize(
        object.fulfillmentMethod,
        specifiedType: const FullType(CartItemUpdateFulfillmentMethodEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CartItemUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CartItemUpdateBuilder result,
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
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.quantity = valueDes;
          break;
        case r'saved_for_later':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.savedForLater = valueDes;
          break;
        case r'accept_current_price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.acceptCurrentPrice = valueDes;
          break;
        case r'listing_variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.listingVariantId = valueDes;
          break;
        case r'expected_price_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.expectedPriceVersionId = valueDes;
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CartItemUpdateFulfillmentMethodEnum),
          ) as CartItemUpdateFulfillmentMethodEnum?;
          if (valueDes == null) continue;
          result.fulfillmentMethod = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CartItemUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CartItemUpdateBuilder();
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


class CartItemUpdateFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const CartItemUpdateFulfillmentMethodEnum DELIVERY = _$cartItemUpdateFulfillmentMethodEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const CartItemUpdateFulfillmentMethodEnum PICKUP = _$cartItemUpdateFulfillmentMethodEnum_PICKUP;

  static Serializer<CartItemUpdateFulfillmentMethodEnum> get serializer => _$cartItemUpdateFulfillmentMethodEnumSerializer;

  const CartItemUpdateFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<CartItemUpdateFulfillmentMethodEnum> get values => _$cartItemUpdateFulfillmentMethodEnumValues;
  static CartItemUpdateFulfillmentMethodEnum valueOf(String name) => _$cartItemUpdateFulfillmentMethodEnumValueOf(name);
}

