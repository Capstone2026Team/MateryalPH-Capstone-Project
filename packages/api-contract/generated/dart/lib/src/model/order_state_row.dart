//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_state_row.g.dart';

/// One of five independent state families; no family implies another.
///
/// Properties:
/// * [family]
/// * [state]
@BuiltValue()
abstract class OrderStateRow implements Built<OrderStateRow, OrderStateRowBuilder> {
  @BuiltValueField(wireName: r'family')
  OrderStateRowFamilyEnum get family;
  // enum familyEnum {  ORDER,  PAYMENT,  FULFILLMENT,  REFUND,  DISPUTE,  };

  @BuiltValueField(wireName: r'state')
  String get state;

  OrderStateRow._();

  factory OrderStateRow([void updates(OrderStateRowBuilder b)]) = _$OrderStateRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderStateRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderStateRow> get serializer => _$OrderStateRowSerializer();
}

class _$OrderStateRowSerializer implements PrimitiveSerializer<OrderStateRow> {
  @override
  final Iterable<Type> types = const [OrderStateRow, _$OrderStateRow];

  @override
  final String wireName = r'OrderStateRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderStateRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'family';
    yield serializers.serialize(
      object.family,
      specifiedType: const FullType(OrderStateRowFamilyEnum),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderStateRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderStateRowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'family':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderStateRowFamilyEnum),
          ) as OrderStateRowFamilyEnum;
          result.family = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.state = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderStateRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderStateRowBuilder();
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


class OrderStateRowFamilyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ORDER')
  static const OrderStateRowFamilyEnum ORDER = _$orderStateRowFamilyEnum_ORDER;
  @BuiltValueEnumConst(wireName: r'PAYMENT')
  static const OrderStateRowFamilyEnum PAYMENT = _$orderStateRowFamilyEnum_PAYMENT;
  @BuiltValueEnumConst(wireName: r'FULFILLMENT')
  static const OrderStateRowFamilyEnum FULFILLMENT = _$orderStateRowFamilyEnum_FULFILLMENT;
  @BuiltValueEnumConst(wireName: r'REFUND')
  static const OrderStateRowFamilyEnum REFUND = _$orderStateRowFamilyEnum_REFUND;
  @BuiltValueEnumConst(wireName: r'DISPUTE')
  static const OrderStateRowFamilyEnum DISPUTE = _$orderStateRowFamilyEnum_DISPUTE;

  static Serializer<OrderStateRowFamilyEnum> get serializer => _$orderStateRowFamilyEnumSerializer;

  const OrderStateRowFamilyEnum._(String name): super(name);

  static BuiltSet<OrderStateRowFamilyEnum> get values => _$orderStateRowFamilyEnumValues;
  static OrderStateRowFamilyEnum valueOf(String name) => _$orderStateRowFamilyEnumValueOf(name);
}

