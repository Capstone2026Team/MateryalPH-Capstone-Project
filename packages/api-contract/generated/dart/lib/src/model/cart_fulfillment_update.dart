//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cart_fulfillment_update.g.dart';

/// CartFulfillmentUpdate
///
/// Properties:
/// * [lockVersion]
/// * [fulfillmentMethod]
@BuiltValue()
abstract class CartFulfillmentUpdate implements Built<CartFulfillmentUpdate, CartFulfillmentUpdateBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'fulfillment_method')
  CartFulfillmentUpdateFulfillmentMethodEnum get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  DELIVERY,  PICKUP,  };

  CartFulfillmentUpdate._();

  factory CartFulfillmentUpdate([void updates(CartFulfillmentUpdateBuilder b)]) = _$CartFulfillmentUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CartFulfillmentUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CartFulfillmentUpdate> get serializer => _$CartFulfillmentUpdateSerializer();
}

class _$CartFulfillmentUpdateSerializer implements PrimitiveSerializer<CartFulfillmentUpdate> {
  @override
  final Iterable<Type> types = const [CartFulfillmentUpdate, _$CartFulfillmentUpdate];

  @override
  final String wireName = r'CartFulfillmentUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CartFulfillmentUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'fulfillment_method';
    yield serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType(CartFulfillmentUpdateFulfillmentMethodEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CartFulfillmentUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CartFulfillmentUpdateBuilder result,
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
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CartFulfillmentUpdateFulfillmentMethodEnum),
          ) as CartFulfillmentUpdateFulfillmentMethodEnum;
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
  CartFulfillmentUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CartFulfillmentUpdateBuilder();
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


class CartFulfillmentUpdateFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const CartFulfillmentUpdateFulfillmentMethodEnum DELIVERY = _$cartFulfillmentUpdateFulfillmentMethodEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const CartFulfillmentUpdateFulfillmentMethodEnum PICKUP = _$cartFulfillmentUpdateFulfillmentMethodEnum_PICKUP;

  static Serializer<CartFulfillmentUpdateFulfillmentMethodEnum> get serializer => _$cartFulfillmentUpdateFulfillmentMethodEnumSerializer;

  const CartFulfillmentUpdateFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<CartFulfillmentUpdateFulfillmentMethodEnum> get values => _$cartFulfillmentUpdateFulfillmentMethodEnumValues;
  static CartFulfillmentUpdateFulfillmentMethodEnum valueOf(String name) => _$cartFulfillmentUpdateFulfillmentMethodEnumValueOf(name);
}

