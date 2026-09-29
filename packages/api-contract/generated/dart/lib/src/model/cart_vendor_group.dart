//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/cart_line.dart';
import 'package:materyalph_api_client/src/model/cart_vendor_ref.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cart_vendor_group.g.dart';

/// CartVendorGroup
///
/// Properties:
/// * [vendor]
/// * [fulfillmentMethod]
/// * [fulfillmentOptions]
/// * [lines]
/// * [materialsSubtotalCentavos]
/// * [status]
@BuiltValue()
abstract class CartVendorGroup implements Built<CartVendorGroup, CartVendorGroupBuilder> {
  @BuiltValueField(wireName: r'vendor')
  CartVendorRef get vendor;

  @BuiltValueField(wireName: r'fulfillment_method')
  CartVendorGroupFulfillmentMethodEnum? get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  DELIVERY,  PICKUP,  ,  };

  @BuiltValueField(wireName: r'fulfillment_options')
  BuiltList<CartVendorGroupFulfillmentOptionsEnum> get fulfillmentOptions;
  // enum fulfillmentOptionsEnum {  DELIVERY,  PICKUP,  };

  @BuiltValueField(wireName: r'lines')
  BuiltList<CartLine> get lines;

  @BuiltValueField(wireName: r'materials_subtotal_centavos')
  int get materialsSubtotalCentavos;

  @BuiltValueField(wireName: r'status')
  CartVendorGroupStatusEnum get status;
  // enum statusEnum {  READY,  ACTION_REQUIRED,  BLOCKED,  };

  CartVendorGroup._();

  factory CartVendorGroup([void updates(CartVendorGroupBuilder b)]) = _$CartVendorGroup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CartVendorGroupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CartVendorGroup> get serializer => _$CartVendorGroupSerializer();
}

class _$CartVendorGroupSerializer implements PrimitiveSerializer<CartVendorGroup> {
  @override
  final Iterable<Type> types = const [CartVendorGroup, _$CartVendorGroup];

  @override
  final String wireName = r'CartVendorGroup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CartVendorGroup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor';
    yield serializers.serialize(
      object.vendor,
      specifiedType: const FullType(CartVendorRef),
    );
    yield r'fulfillment_method';
    yield object.fulfillmentMethod == null ? null : serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType.nullable(CartVendorGroupFulfillmentMethodEnum),
    );
    yield r'fulfillment_options';
    yield serializers.serialize(
      object.fulfillmentOptions,
      specifiedType: const FullType(BuiltList, [FullType(CartVendorGroupFulfillmentOptionsEnum)]),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(CartLine)]),
    );
    yield r'materials_subtotal_centavos';
    yield serializers.serialize(
      object.materialsSubtotalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CartVendorGroupStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CartVendorGroup object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CartVendorGroupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CartVendorRef),
          ) as CartVendorRef;
          result.vendor.replace(valueDes);
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CartVendorGroupFulfillmentMethodEnum),
          ) as CartVendorGroupFulfillmentMethodEnum?;
          if (valueDes == null) continue;
          result.fulfillmentMethod = valueDes;
          break;
        case r'fulfillment_options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CartVendorGroupFulfillmentOptionsEnum)]),
          ) as BuiltList<CartVendorGroupFulfillmentOptionsEnum>;
          result.fulfillmentOptions.replace(valueDes);
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CartLine)]),
          ) as BuiltList<CartLine>;
          result.lines.replace(valueDes);
          break;
        case r'materials_subtotal_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialsSubtotalCentavos = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CartVendorGroupStatusEnum),
          ) as CartVendorGroupStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CartVendorGroup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CartVendorGroupBuilder();
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


class CartVendorGroupFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const CartVendorGroupFulfillmentMethodEnum DELIVERY = _$cartVendorGroupFulfillmentMethodEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const CartVendorGroupFulfillmentMethodEnum PICKUP = _$cartVendorGroupFulfillmentMethodEnum_PICKUP;

  static Serializer<CartVendorGroupFulfillmentMethodEnum> get serializer => _$cartVendorGroupFulfillmentMethodEnumSerializer;

  const CartVendorGroupFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<CartVendorGroupFulfillmentMethodEnum> get values => _$cartVendorGroupFulfillmentMethodEnumValues;
  static CartVendorGroupFulfillmentMethodEnum valueOf(String name) => _$cartVendorGroupFulfillmentMethodEnumValueOf(name);
}

class CartVendorGroupFulfillmentOptionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const CartVendorGroupFulfillmentOptionsEnum DELIVERY = _$cartVendorGroupFulfillmentOptionsEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const CartVendorGroupFulfillmentOptionsEnum PICKUP = _$cartVendorGroupFulfillmentOptionsEnum_PICKUP;

  static Serializer<CartVendorGroupFulfillmentOptionsEnum> get serializer => _$cartVendorGroupFulfillmentOptionsEnumSerializer;

  const CartVendorGroupFulfillmentOptionsEnum._(String name): super(name);

  static BuiltSet<CartVendorGroupFulfillmentOptionsEnum> get values => _$cartVendorGroupFulfillmentOptionsEnumValues;
  static CartVendorGroupFulfillmentOptionsEnum valueOf(String name) => _$cartVendorGroupFulfillmentOptionsEnumValueOf(name);
}

class CartVendorGroupStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'READY')
  static const CartVendorGroupStatusEnum READY = _$cartVendorGroupStatusEnum_READY;
  @BuiltValueEnumConst(wireName: r'ACTION_REQUIRED')
  static const CartVendorGroupStatusEnum ACTION_REQUIRED = _$cartVendorGroupStatusEnum_ACTION_REQUIRED;
  @BuiltValueEnumConst(wireName: r'BLOCKED')
  static const CartVendorGroupStatusEnum BLOCKED = _$cartVendorGroupStatusEnum_BLOCKED;

  static Serializer<CartVendorGroupStatusEnum> get serializer => _$cartVendorGroupStatusEnumSerializer;

  const CartVendorGroupStatusEnum._(String name): super(name);

  static BuiltSet<CartVendorGroupStatusEnum> get values => _$cartVendorGroupStatusEnumValues;
  static CartVendorGroupStatusEnum valueOf(String name) => _$cartVendorGroupStatusEnumValueOf(name);
}

