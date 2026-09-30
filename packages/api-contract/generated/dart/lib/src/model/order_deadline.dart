//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_deadline.g.dart';

/// OrderDeadline
///
/// Properties:
/// * [kind]
/// * [at]
@BuiltValue()
abstract class OrderDeadline implements Built<OrderDeadline, OrderDeadlineBuilder> {
  @BuiltValueField(wireName: r'kind')
  OrderDeadlineKindEnum get kind;
  // enum kindEnum {  VENDOR_RESPONSE,  BUYER_RESPONSE,  PAYMENT,  };

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  OrderDeadline._();

  factory OrderDeadline([void updates(OrderDeadlineBuilder b)]) = _$OrderDeadline;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderDeadlineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderDeadline> get serializer => _$OrderDeadlineSerializer();
}

class _$OrderDeadlineSerializer implements PrimitiveSerializer<OrderDeadline> {
  @override
  final Iterable<Type> types = const [OrderDeadline, _$OrderDeadline];

  @override
  final String wireName = r'OrderDeadline';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderDeadline object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(OrderDeadlineKindEnum),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderDeadline object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderDeadlineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderDeadlineKindEnum),
          ) as OrderDeadlineKindEnum;
          result.kind = valueDes;
          break;
        case r'at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.at = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderDeadline deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderDeadlineBuilder();
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


class OrderDeadlineKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR_RESPONSE')
  static const OrderDeadlineKindEnum VENDOR_RESPONSE = _$orderDeadlineKindEnum_VENDOR_RESPONSE;
  @BuiltValueEnumConst(wireName: r'BUYER_RESPONSE')
  static const OrderDeadlineKindEnum BUYER_RESPONSE = _$orderDeadlineKindEnum_BUYER_RESPONSE;
  @BuiltValueEnumConst(wireName: r'PAYMENT')
  static const OrderDeadlineKindEnum PAYMENT = _$orderDeadlineKindEnum_PAYMENT;

  static Serializer<OrderDeadlineKindEnum> get serializer => _$orderDeadlineKindEnumSerializer;

  const OrderDeadlineKindEnum._(String name): super(name);

  static BuiltSet<OrderDeadlineKindEnum> get values => _$orderDeadlineKindEnumValues;
  static OrderDeadlineKindEnum valueOf(String name) => _$orderDeadlineKindEnumValueOf(name);
}

