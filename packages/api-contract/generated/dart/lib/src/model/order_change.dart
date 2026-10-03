//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_change.g.dart';

/// OrderChange
///
/// Properties:
/// * [type]
/// * [orderLineId]
/// * [label]
/// * [from]
/// * [to]
@BuiltValue()
abstract class OrderChange implements Built<OrderChange, OrderChangeBuilder> {
  @BuiltValueField(wireName: r'type')
  OrderChangeTypeEnum get type;
  // enum typeEnum {  QUANTITY_REDUCED,  LINE_REMOVED,  VENDOR_DISCOUNT,  };

  @BuiltValueField(wireName: r'order_line_id')
  String? get orderLineId;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'from')
  String get from;

  @BuiltValueField(wireName: r'to')
  String get to;

  OrderChange._();

  factory OrderChange([void updates(OrderChangeBuilder b)]) = _$OrderChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderChange> get serializer => _$OrderChangeSerializer();
}

class _$OrderChangeSerializer implements PrimitiveSerializer<OrderChange> {
  @override
  final Iterable<Type> types = const [OrderChange, _$OrderChange];

  @override
  final String wireName = r'OrderChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(OrderChangeTypeEnum),
    );
    yield r'order_line_id';
    yield object.orderLineId == null ? null : serializers.serialize(
      object.orderLineId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(String),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderChangeTypeEnum),
          ) as OrderChangeTypeEnum;
          result.type = valueDes;
          break;
        case r'order_line_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderLineId = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.to = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderChangeBuilder();
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


class OrderChangeTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'QUANTITY_REDUCED')
  static const OrderChangeTypeEnum QUANTITY_REDUCED = _$orderChangeTypeEnum_QUANTITY_REDUCED;
  @BuiltValueEnumConst(wireName: r'LINE_REMOVED')
  static const OrderChangeTypeEnum LINE_REMOVED = _$orderChangeTypeEnum_LINE_REMOVED;
  @BuiltValueEnumConst(wireName: r'VENDOR_DISCOUNT')
  static const OrderChangeTypeEnum VENDOR_DISCOUNT = _$orderChangeTypeEnum_VENDOR_DISCOUNT;

  static Serializer<OrderChangeTypeEnum> get serializer => _$orderChangeTypeEnumSerializer;

  const OrderChangeTypeEnum._(String name): super(name);

  static BuiltSet<OrderChangeTypeEnum> get values => _$orderChangeTypeEnumValues;
  static OrderChangeTypeEnum valueOf(String name) => _$orderChangeTypeEnumValueOf(name);
}

