//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cart_item_update.g.dart';

/// CartItemUpdate
///
/// Properties:
/// * [lockVersion]
/// * [quantity]
/// * [savedForLater]
/// * [acceptCurrentPrice]
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


