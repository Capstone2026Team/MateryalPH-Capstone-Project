//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/inventory_price_change.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_row_update.g.dart';

/// InventoryRowUpdate
///
/// Properties:
/// * [lockVersion]
/// * [quantityOnHand]
/// * [reorderLevel] - Null clears the reorder level.
/// * [reasonCode]
/// * [note]
/// * [price]
@BuiltValue()
abstract class InventoryRowUpdate implements Built<InventoryRowUpdate, InventoryRowUpdateBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'quantity_on_hand')
  String? get quantityOnHand;

  /// Null clears the reorder level.
  @BuiltValueField(wireName: r'reorder_level')
  String? get reorderLevel;

  @BuiltValueField(wireName: r'reason_code')
  InventoryRowUpdateReasonCodeEnum? get reasonCode;
  // enum reasonCodeEnum {  COUNT,  RECEIVED,  RETURNED,  DAMAGED,  LOST,  CORRECTION,  };

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'price')
  InventoryPriceChange? get price;

  InventoryRowUpdate._();

  factory InventoryRowUpdate([void updates(InventoryRowUpdateBuilder b)]) = _$InventoryRowUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryRowUpdateBuilder b) => b
      ..reasonCode = InventoryRowUpdateReasonCodeEnum.valueOf('COUNT');

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryRowUpdate> get serializer => _$InventoryRowUpdateSerializer();
}

class _$InventoryRowUpdateSerializer implements PrimitiveSerializer<InventoryRowUpdate> {
  @override
  final Iterable<Type> types = const [InventoryRowUpdate, _$InventoryRowUpdate];

  @override
  final String wireName = r'InventoryRowUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryRowUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.quantityOnHand != null) {
      yield r'quantity_on_hand';
      yield serializers.serialize(
        object.quantityOnHand,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.reorderLevel != null) {
      yield r'reorder_level';
      yield serializers.serialize(
        object.reorderLevel,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.reasonCode != null) {
      yield r'reason_code';
      yield serializers.serialize(
        object.reasonCode,
        specifiedType: const FullType(InventoryRowUpdateReasonCodeEnum),
      );
    }
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.price != null) {
      yield r'price';
      yield serializers.serialize(
        object.price,
        specifiedType: const FullType(InventoryPriceChange),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InventoryRowUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventoryRowUpdateBuilder result,
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
        case r'quantity_on_hand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.quantityOnHand = valueDes;
          break;
        case r'reorder_level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reorderLevel = valueDes;
          break;
        case r'reason_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(InventoryRowUpdateReasonCodeEnum),
          ) as InventoryRowUpdateReasonCodeEnum?;
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
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(InventoryPriceChange),
          ) as InventoryPriceChange?;
          if (valueDes == null) continue;
          result.price.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InventoryRowUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryRowUpdateBuilder();
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


class InventoryRowUpdateReasonCodeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COUNT')
  static const InventoryRowUpdateReasonCodeEnum COUNT = _$inventoryRowUpdateReasonCodeEnum_COUNT;
  @BuiltValueEnumConst(wireName: r'RECEIVED')
  static const InventoryRowUpdateReasonCodeEnum RECEIVED = _$inventoryRowUpdateReasonCodeEnum_RECEIVED;
  @BuiltValueEnumConst(wireName: r'RETURNED')
  static const InventoryRowUpdateReasonCodeEnum RETURNED = _$inventoryRowUpdateReasonCodeEnum_RETURNED;
  @BuiltValueEnumConst(wireName: r'DAMAGED')
  static const InventoryRowUpdateReasonCodeEnum DAMAGED = _$inventoryRowUpdateReasonCodeEnum_DAMAGED;
  @BuiltValueEnumConst(wireName: r'LOST')
  static const InventoryRowUpdateReasonCodeEnum LOST = _$inventoryRowUpdateReasonCodeEnum_LOST;
  @BuiltValueEnumConst(wireName: r'CORRECTION')
  static const InventoryRowUpdateReasonCodeEnum CORRECTION = _$inventoryRowUpdateReasonCodeEnum_CORRECTION;

  static Serializer<InventoryRowUpdateReasonCodeEnum> get serializer => _$inventoryRowUpdateReasonCodeEnumSerializer;

  const InventoryRowUpdateReasonCodeEnum._(String name): super(name);

  static BuiltSet<InventoryRowUpdateReasonCodeEnum> get values => _$inventoryRowUpdateReasonCodeEnumValues;
  static InventoryRowUpdateReasonCodeEnum valueOf(String name) => _$inventoryRowUpdateReasonCodeEnumValueOf(name);
}

