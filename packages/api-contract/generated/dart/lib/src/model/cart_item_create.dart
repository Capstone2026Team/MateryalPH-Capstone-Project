//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cart_item_create.g.dart';

/// CartItemCreate
///
/// Properties:
/// * [listingVariantId]
/// * [expectedPriceVersionId] - The price version shown to the Buyer; a newer one returns 409 PRICE_CHANGED.
/// * [quantity]
/// * [fulfillmentMethod]
/// * [locationId]
/// * [latitude]
/// * [longitude]
/// * [originSource]
/// * [radiusKm]
@BuiltValue()
abstract class CartItemCreate implements Built<CartItemCreate, CartItemCreateBuilder> {
  @BuiltValueField(wireName: r'listing_variant_id')
  String get listingVariantId;

  /// The price version shown to the Buyer; a newer one returns 409 PRICE_CHANGED.
  @BuiltValueField(wireName: r'expected_price_version_id')
  String get expectedPriceVersionId;

  @BuiltValueField(wireName: r'quantity')
  String get quantity;

  @BuiltValueField(wireName: r'fulfillment_method')
  CartItemCreateFulfillmentMethodEnum? get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  DELIVERY,  PICKUP,  ,  };

  @BuiltValueField(wireName: r'location_id')
  String? get locationId;

  @BuiltValueField(wireName: r'latitude')
  double? get latitude;

  @BuiltValueField(wireName: r'longitude')
  double? get longitude;

  @BuiltValueField(wireName: r'origin_source')
  CartItemCreateOriginSourceEnum? get originSource;
  // enum originSourceEnum {  DEVICE,  MAP_PIN,  SEARCH,  };

  @BuiltValueField(wireName: r'radius_km')
  int? get radiusKm;

  CartItemCreate._();

  factory CartItemCreate([void updates(CartItemCreateBuilder b)]) = _$CartItemCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CartItemCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CartItemCreate> get serializer => _$CartItemCreateSerializer();
}

class _$CartItemCreateSerializer implements PrimitiveSerializer<CartItemCreate> {
  @override
  final Iterable<Type> types = const [CartItemCreate, _$CartItemCreate];

  @override
  final String wireName = r'CartItemCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CartItemCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'listing_variant_id';
    yield serializers.serialize(
      object.listingVariantId,
      specifiedType: const FullType(String),
    );
    yield r'expected_price_version_id';
    yield serializers.serialize(
      object.expectedPriceVersionId,
      specifiedType: const FullType(String),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(String),
    );
    if (object.fulfillmentMethod != null) {
      yield r'fulfillment_method';
      yield serializers.serialize(
        object.fulfillmentMethod,
        specifiedType: const FullType.nullable(CartItemCreateFulfillmentMethodEnum),
      );
    }
    if (object.locationId != null) {
      yield r'location_id';
      yield serializers.serialize(
        object.locationId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.latitude != null) {
      yield r'latitude';
      yield serializers.serialize(
        object.latitude,
        specifiedType: const FullType(double),
      );
    }
    if (object.longitude != null) {
      yield r'longitude';
      yield serializers.serialize(
        object.longitude,
        specifiedType: const FullType(double),
      );
    }
    if (object.originSource != null) {
      yield r'origin_source';
      yield serializers.serialize(
        object.originSource,
        specifiedType: const FullType(CartItemCreateOriginSourceEnum),
      );
    }
    if (object.radiusKm != null) {
      yield r'radius_km';
      yield serializers.serialize(
        object.radiusKm,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CartItemCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CartItemCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'listing_variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingVariantId = valueDes;
          break;
        case r'expected_price_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.expectedPriceVersionId = valueDes;
          break;
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantity = valueDes;
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CartItemCreateFulfillmentMethodEnum),
          ) as CartItemCreateFulfillmentMethodEnum?;
          if (valueDes == null) continue;
          result.fulfillmentMethod = valueDes;
          break;
        case r'location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.locationId = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.longitude = valueDes;
          break;
        case r'origin_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CartItemCreateOriginSourceEnum),
          ) as CartItemCreateOriginSourceEnum?;
          if (valueDes == null) continue;
          result.originSource = valueDes;
          break;
        case r'radius_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.radiusKm = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CartItemCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CartItemCreateBuilder();
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


class CartItemCreateFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const CartItemCreateFulfillmentMethodEnum DELIVERY = _$cartItemCreateFulfillmentMethodEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const CartItemCreateFulfillmentMethodEnum PICKUP = _$cartItemCreateFulfillmentMethodEnum_PICKUP;

  static Serializer<CartItemCreateFulfillmentMethodEnum> get serializer => _$cartItemCreateFulfillmentMethodEnumSerializer;

  const CartItemCreateFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<CartItemCreateFulfillmentMethodEnum> get values => _$cartItemCreateFulfillmentMethodEnumValues;
  static CartItemCreateFulfillmentMethodEnum valueOf(String name) => _$cartItemCreateFulfillmentMethodEnumValueOf(name);
}

class CartItemCreateOriginSourceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DEVICE')
  static const CartItemCreateOriginSourceEnum DEVICE = _$cartItemCreateOriginSourceEnum_DEVICE;
  @BuiltValueEnumConst(wireName: r'MAP_PIN')
  static const CartItemCreateOriginSourceEnum MAP_PIN = _$cartItemCreateOriginSourceEnum_MAP_PIN;
  @BuiltValueEnumConst(wireName: r'SEARCH')
  static const CartItemCreateOriginSourceEnum SEARCH = _$cartItemCreateOriginSourceEnum_SEARCH;

  static Serializer<CartItemCreateOriginSourceEnum> get serializer => _$cartItemCreateOriginSourceEnumSerializer;

  const CartItemCreateOriginSourceEnum._(String name): super(name);

  static BuiltSet<CartItemCreateOriginSourceEnum> get values => _$cartItemCreateOriginSourceEnumValues;
  static CartItemCreateOriginSourceEnum valueOf(String name) => _$cartItemCreateOriginSourceEnumValueOf(name);
}

