//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_balance.g.dart';

/// Vendor-only exact quantities. Never returned to Buyers or analytics.
///
/// Properties:
/// * [quantityOnHand] - Physical stock (four decimals). Reduced only by fulfillment or a recorded adjustment.
/// * [hardReservedQuantity]
/// * [softHeldQuantity] - Planning-only quotation holds; never reduce available_to_sell.
/// * [availableToSell] - quantity_on_hand minus hard_reserved_quantity.
/// * [reorderLevel]
/// * [confirmedAt]
/// * [updatedAt]
@BuiltValue()
abstract class InventoryBalance implements Built<InventoryBalance, InventoryBalanceBuilder> {
  /// Physical stock (four decimals). Reduced only by fulfillment or a recorded adjustment.
  @BuiltValueField(wireName: r'quantity_on_hand')
  String get quantityOnHand;

  @BuiltValueField(wireName: r'hard_reserved_quantity')
  String get hardReservedQuantity;

  /// Planning-only quotation holds; never reduce available_to_sell.
  @BuiltValueField(wireName: r'soft_held_quantity')
  String get softHeldQuantity;

  /// quantity_on_hand minus hard_reserved_quantity.
  @BuiltValueField(wireName: r'available_to_sell')
  String get availableToSell;

  @BuiltValueField(wireName: r'reorder_level')
  String? get reorderLevel;

  @BuiltValueField(wireName: r'confirmed_at')
  DateTime? get confirmedAt;

  @BuiltValueField(wireName: r'updated_at')
  String? get updatedAt;

  InventoryBalance._();

  factory InventoryBalance([void updates(InventoryBalanceBuilder b)]) = _$InventoryBalance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryBalanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryBalance> get serializer => _$InventoryBalanceSerializer();
}

class _$InventoryBalanceSerializer implements PrimitiveSerializer<InventoryBalance> {
  @override
  final Iterable<Type> types = const [InventoryBalance, _$InventoryBalance];

  @override
  final String wireName = r'InventoryBalance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryBalance object, {
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
    yield r'soft_held_quantity';
    yield serializers.serialize(
      object.softHeldQuantity,
      specifiedType: const FullType(String),
    );
    yield r'available_to_sell';
    yield serializers.serialize(
      object.availableToSell,
      specifiedType: const FullType(String),
    );
    yield r'reorder_level';
    yield object.reorderLevel == null ? null : serializers.serialize(
      object.reorderLevel,
      specifiedType: const FullType.nullable(String),
    );
    yield r'confirmed_at';
    yield object.confirmedAt == null ? null : serializers.serialize(
      object.confirmedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InventoryBalance object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventoryBalanceBuilder result,
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
        case r'soft_held_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.softHeldQuantity = valueDes;
          break;
        case r'available_to_sell':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.availableToSell = valueDes;
          break;
        case r'reorder_level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reorderLevel = valueDes;
          break;
        case r'confirmed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.confirmedAt = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InventoryBalance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryBalanceBuilder();
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


