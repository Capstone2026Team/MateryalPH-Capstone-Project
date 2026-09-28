//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_movement.g.dart';

/// InventoryMovement
///
/// Properties:
/// * [id]
/// * [movementType]
/// * [quantityDelta]
/// * [quantityOnHandBefore]
/// * [quantityOnHandAfter]
/// * [hardReservedAfter]
/// * [reasonCode]
/// * [note]
/// * [sourceType]
/// * [actor] - Public display name of the Vendor user, System or Auto-accept policy.
/// * [recordedAt]
@BuiltValue()
abstract class InventoryMovement implements Built<InventoryMovement, InventoryMovementBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'movement_type')
  InventoryMovementMovementTypeEnum get movementType;
  // enum movementTypeEnum {  INITIAL_COUNT,  COUNT_ADJUSTMENT,  RECEIVED,  DAMAGED,  LOST,  RETURNED,  CORRECTION,  HARD_RESERVE,  HARD_RELEASE,  SOFT_HOLD,  SOFT_RELEASE,  FULFILLED,  };

  @BuiltValueField(wireName: r'quantity_delta')
  String get quantityDelta;

  @BuiltValueField(wireName: r'quantity_on_hand_before')
  String? get quantityOnHandBefore;

  @BuiltValueField(wireName: r'quantity_on_hand_after')
  String get quantityOnHandAfter;

  @BuiltValueField(wireName: r'hard_reserved_after')
  String? get hardReservedAfter;

  @BuiltValueField(wireName: r'reason_code')
  String? get reasonCode;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'source_type')
  String get sourceType;

  /// Public display name of the Vendor user, System or Auto-accept policy.
  @BuiltValueField(wireName: r'actor')
  String get actor;

  @BuiltValueField(wireName: r'recorded_at')
  String get recordedAt;

  InventoryMovement._();

  factory InventoryMovement([void updates(InventoryMovementBuilder b)]) = _$InventoryMovement;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryMovementBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryMovement> get serializer => _$InventoryMovementSerializer();
}

class _$InventoryMovementSerializer implements PrimitiveSerializer<InventoryMovement> {
  @override
  final Iterable<Type> types = const [InventoryMovement, _$InventoryMovement];

  @override
  final String wireName = r'InventoryMovement';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryMovement object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'movement_type';
    yield serializers.serialize(
      object.movementType,
      specifiedType: const FullType(InventoryMovementMovementTypeEnum),
    );
    yield r'quantity_delta';
    yield serializers.serialize(
      object.quantityDelta,
      specifiedType: const FullType(String),
    );
    yield r'quantity_on_hand_before';
    yield object.quantityOnHandBefore == null ? null : serializers.serialize(
      object.quantityOnHandBefore,
      specifiedType: const FullType.nullable(String),
    );
    yield r'quantity_on_hand_after';
    yield serializers.serialize(
      object.quantityOnHandAfter,
      specifiedType: const FullType(String),
    );
    yield r'hard_reserved_after';
    yield object.hardReservedAfter == null ? null : serializers.serialize(
      object.hardReservedAfter,
      specifiedType: const FullType.nullable(String),
    );
    yield r'reason_code';
    yield object.reasonCode == null ? null : serializers.serialize(
      object.reasonCode,
      specifiedType: const FullType.nullable(String),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
    yield r'source_type';
    yield serializers.serialize(
      object.sourceType,
      specifiedType: const FullType(String),
    );
    yield r'actor';
    yield serializers.serialize(
      object.actor,
      specifiedType: const FullType(String),
    );
    yield r'recorded_at';
    yield serializers.serialize(
      object.recordedAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InventoryMovement object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventoryMovementBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'movement_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InventoryMovementMovementTypeEnum),
          ) as InventoryMovementMovementTypeEnum;
          result.movementType = valueDes;
          break;
        case r'quantity_delta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantityDelta = valueDes;
          break;
        case r'quantity_on_hand_before':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.quantityOnHandBefore = valueDes;
          break;
        case r'quantity_on_hand_after':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantityOnHandAfter = valueDes;
          break;
        case r'hard_reserved_after':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.hardReservedAfter = valueDes;
          break;
        case r'reason_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reasonCode = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'source_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sourceType = valueDes;
          break;
        case r'actor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actor = valueDes;
          break;
        case r'recorded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.recordedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InventoryMovement deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryMovementBuilder();
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


class InventoryMovementMovementTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INITIAL_COUNT')
  static const InventoryMovementMovementTypeEnum INITIAL_COUNT = _$inventoryMovementMovementTypeEnum_INITIAL_COUNT;
  @BuiltValueEnumConst(wireName: r'COUNT_ADJUSTMENT')
  static const InventoryMovementMovementTypeEnum COUNT_ADJUSTMENT = _$inventoryMovementMovementTypeEnum_COUNT_ADJUSTMENT;
  @BuiltValueEnumConst(wireName: r'RECEIVED')
  static const InventoryMovementMovementTypeEnum RECEIVED = _$inventoryMovementMovementTypeEnum_RECEIVED;
  @BuiltValueEnumConst(wireName: r'DAMAGED')
  static const InventoryMovementMovementTypeEnum DAMAGED = _$inventoryMovementMovementTypeEnum_DAMAGED;
  @BuiltValueEnumConst(wireName: r'LOST')
  static const InventoryMovementMovementTypeEnum LOST = _$inventoryMovementMovementTypeEnum_LOST;
  @BuiltValueEnumConst(wireName: r'RETURNED')
  static const InventoryMovementMovementTypeEnum RETURNED = _$inventoryMovementMovementTypeEnum_RETURNED;
  @BuiltValueEnumConst(wireName: r'CORRECTION')
  static const InventoryMovementMovementTypeEnum CORRECTION = _$inventoryMovementMovementTypeEnum_CORRECTION;
  @BuiltValueEnumConst(wireName: r'HARD_RESERVE')
  static const InventoryMovementMovementTypeEnum HARD_RESERVE = _$inventoryMovementMovementTypeEnum_HARD_RESERVE;
  @BuiltValueEnumConst(wireName: r'HARD_RELEASE')
  static const InventoryMovementMovementTypeEnum HARD_RELEASE = _$inventoryMovementMovementTypeEnum_HARD_RELEASE;
  @BuiltValueEnumConst(wireName: r'SOFT_HOLD')
  static const InventoryMovementMovementTypeEnum SOFT_HOLD = _$inventoryMovementMovementTypeEnum_SOFT_HOLD;
  @BuiltValueEnumConst(wireName: r'SOFT_RELEASE')
  static const InventoryMovementMovementTypeEnum SOFT_RELEASE = _$inventoryMovementMovementTypeEnum_SOFT_RELEASE;
  @BuiltValueEnumConst(wireName: r'FULFILLED')
  static const InventoryMovementMovementTypeEnum FULFILLED = _$inventoryMovementMovementTypeEnum_FULFILLED;

  static Serializer<InventoryMovementMovementTypeEnum> get serializer => _$inventoryMovementMovementTypeEnumSerializer;

  const InventoryMovementMovementTypeEnum._(String name): super(name);

  static BuiltSet<InventoryMovementMovementTypeEnum> get values => _$inventoryMovementMovementTypeEnumValues;
  static InventoryMovementMovementTypeEnum valueOf(String name) => _$inventoryMovementMovementTypeEnumValueOf(name);
}

