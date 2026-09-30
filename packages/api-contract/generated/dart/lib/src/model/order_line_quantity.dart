//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_line_quantity.g.dart';

/// OrderLineQuantity
///
/// Properties:
/// * [orderLineId]
/// * [confirmedQuantity] - Between 0 and the requested quantity.
@BuiltValue()
abstract class OrderLineQuantity implements Built<OrderLineQuantity, OrderLineQuantityBuilder> {
  @BuiltValueField(wireName: r'order_line_id')
  String get orderLineId;

  /// Between 0 and the requested quantity.
  @BuiltValueField(wireName: r'confirmed_quantity')
  String get confirmedQuantity;

  OrderLineQuantity._();

  factory OrderLineQuantity([void updates(OrderLineQuantityBuilder b)]) = _$OrderLineQuantity;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderLineQuantityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderLineQuantity> get serializer => _$OrderLineQuantitySerializer();
}

class _$OrderLineQuantitySerializer implements PrimitiveSerializer<OrderLineQuantity> {
  @override
  final Iterable<Type> types = const [OrderLineQuantity, _$OrderLineQuantity];

  @override
  final String wireName = r'OrderLineQuantity';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderLineQuantity object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order_line_id';
    yield serializers.serialize(
      object.orderLineId,
      specifiedType: const FullType(String),
    );
    yield r'confirmed_quantity';
    yield serializers.serialize(
      object.confirmedQuantity,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderLineQuantity object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderLineQuantityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'order_line_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderLineId = valueDes;
          break;
        case r'confirmed_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.confirmedQuantity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderLineQuantity deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderLineQuantityBuilder();
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


