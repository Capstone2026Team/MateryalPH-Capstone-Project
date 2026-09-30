//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_payment_availability.g.dart';

/// OrderPaymentAvailability
///
/// Properties:
/// * [available]
/// * [reason]
/// * [notice]
@BuiltValue()
abstract class OrderPaymentAvailability implements Built<OrderPaymentAvailability, OrderPaymentAvailabilityBuilder> {
  @BuiltValueField(wireName: r'available')
  bool get available;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'notice')
  String? get notice;

  OrderPaymentAvailability._();

  factory OrderPaymentAvailability([void updates(OrderPaymentAvailabilityBuilder b)]) = _$OrderPaymentAvailability;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderPaymentAvailabilityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderPaymentAvailability> get serializer => _$OrderPaymentAvailabilitySerializer();
}

class _$OrderPaymentAvailabilitySerializer implements PrimitiveSerializer<OrderPaymentAvailability> {
  @override
  final Iterable<Type> types = const [OrderPaymentAvailability, _$OrderPaymentAvailability];

  @override
  final String wireName = r'OrderPaymentAvailability';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderPaymentAvailability object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'notice';
    yield object.notice == null ? null : serializers.serialize(
      object.notice,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderPaymentAvailability object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderPaymentAvailabilityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderPaymentAvailability deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderPaymentAvailabilityBuilder();
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


