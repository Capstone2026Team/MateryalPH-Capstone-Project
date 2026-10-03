//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_line_inventory.g.dart';

/// Authorized Vendor roles only; never sent to Buyers.
///
/// Properties:
/// * [quantityOnHand]
/// * [hardReservedQuantity]
/// * [availableToSell]
@BuiltValue()
abstract class OrderLineInventory implements Built<OrderLineInventory, OrderLineInventoryBuilder> {
  @BuiltValueField(wireName: r'quantity_on_hand')
  String get quantityOnHand;

  @BuiltValueField(wireName: r'hard_reserved_quantity')
  String get hardReservedQuantity;

  @BuiltValueField(wireName: r'available_to_sell')
  String get availableToSell;

  OrderLineInventory._();

  factory OrderLineInventory([void updates(OrderLineInventoryBuilder b)]) = _$OrderLineInventory;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderLineInventoryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderLineInventory> get serializer => _$OrderLineInventorySerializer();
}

class _$OrderLineInventorySerializer implements PrimitiveSerializer<OrderLineInventory> {
  @override
  final Iterable<Type> types = const [OrderLineInventory, _$OrderLineInventory];

  @override
  final String wireName = r'OrderLineInventory';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderLineInventory object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'quantity_on_hand';
    yield serializers.serialize(
      object.quantityOnHand,
      specifiedType: const FullType(String),
    );
    yield r'hard_reserved_quantity';
    yield serializers.serialize(
      object.hardReservedQuantity,
      specifiedType: const FullType(String),
    );
    yield r'available_to_sell';
    yield serializers.serialize(
      object.availableToSell,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderLineInventory object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderLineInventoryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'quantity_on_hand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantityOnHand = valueDes;
          break;
        case r'hard_reserved_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.hardReservedQuantity = valueDes;
          break;
        case r'available_to_sell':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.availableToSell = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderLineInventory deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderLineInventoryBuilder();
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


