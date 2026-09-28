//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_inventory.g.dart';

/// Vendor-only exact stock. Never returned to Buyers.
///
/// Properties:
/// * [quantityOnHand]
/// * [hardReservedQuantity]
/// * [availableToSell]
/// * [softHeldQuantity]
/// * [reorderLevel]
/// * [confirmedAt]
@BuiltValue()
abstract class CatalogInventory implements Built<CatalogInventory, CatalogInventoryBuilder> {
  @BuiltValueField(wireName: r'quantity_on_hand')
  String get quantityOnHand;

  @BuiltValueField(wireName: r'hard_reserved_quantity')
  String get hardReservedQuantity;

  @BuiltValueField(wireName: r'available_to_sell')
  String get availableToSell;

  @BuiltValueField(wireName: r'soft_held_quantity')
  String? get softHeldQuantity;

  @BuiltValueField(wireName: r'reorder_level')
  String? get reorderLevel;

  @BuiltValueField(wireName: r'confirmed_at')
  String? get confirmedAt;

  CatalogInventory._();

  factory CatalogInventory([void updates(CatalogInventoryBuilder b)]) = _$CatalogInventory;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogInventoryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogInventory> get serializer => _$CatalogInventorySerializer();
}

class _$CatalogInventorySerializer implements PrimitiveSerializer<CatalogInventory> {
  @override
  final Iterable<Type> types = const [CatalogInventory, _$CatalogInventory];

  @override
  final String wireName = r'CatalogInventory';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogInventory object, {
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
    if (object.softHeldQuantity != null) {
      yield r'soft_held_quantity';
      yield serializers.serialize(
        object.softHeldQuantity,
        specifiedType: const FullType(String),
      );
    }
    if (object.reorderLevel != null) {
      yield r'reorder_level';
      yield serializers.serialize(
        object.reorderLevel,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.confirmedAt != null) {
      yield r'confirmed_at';
      yield serializers.serialize(
        object.confirmedAt,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogInventory object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogInventoryBuilder result,
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
        case r'soft_held_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.softHeldQuantity = valueDes;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.confirmedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogInventory deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogInventoryBuilder();
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


