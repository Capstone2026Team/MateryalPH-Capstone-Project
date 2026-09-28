//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auto_accept_policy_detail_stock.g.dart';

/// AutoAcceptPolicyDetailStock
///
/// Properties:
/// * [quantityOnHand]
/// * [hardReservedQuantity]
/// * [softHeldQuantity]
/// * [availableToSell]
@BuiltValue()
abstract class AutoAcceptPolicyDetailStock implements Built<AutoAcceptPolicyDetailStock, AutoAcceptPolicyDetailStockBuilder> {
  @BuiltValueField(wireName: r'quantity_on_hand')
  String get quantityOnHand;

  @BuiltValueField(wireName: r'hard_reserved_quantity')
  String get hardReservedQuantity;

  @BuiltValueField(wireName: r'soft_held_quantity')
  String get softHeldQuantity;

  @BuiltValueField(wireName: r'available_to_sell')
  String get availableToSell;

  AutoAcceptPolicyDetailStock._();

  factory AutoAcceptPolicyDetailStock([void updates(AutoAcceptPolicyDetailStockBuilder b)]) = _$AutoAcceptPolicyDetailStock;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutoAcceptPolicyDetailStockBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutoAcceptPolicyDetailStock> get serializer => _$AutoAcceptPolicyDetailStockSerializer();
}

class _$AutoAcceptPolicyDetailStockSerializer implements PrimitiveSerializer<AutoAcceptPolicyDetailStock> {
  @override
  final Iterable<Type> types = const [AutoAcceptPolicyDetailStock, _$AutoAcceptPolicyDetailStock];

  @override
  final String wireName = r'AutoAcceptPolicyDetailStock';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutoAcceptPolicyDetailStock object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AutoAcceptPolicyDetailStock object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutoAcceptPolicyDetailStockBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AutoAcceptPolicyDetailStock deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutoAcceptPolicyDetailStockBuilder();
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


