//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_webhook_ack.g.dart';

/// PaymentWebhookAck
///
/// Properties:
/// * [received]
/// * [duplicate]
@BuiltValue()
abstract class PaymentWebhookAck implements Built<PaymentWebhookAck, PaymentWebhookAckBuilder> {
  @BuiltValueField(wireName: r'received')
  bool get received;

  @BuiltValueField(wireName: r'duplicate')
  bool get duplicate;

  PaymentWebhookAck._();

  factory PaymentWebhookAck([void updates(PaymentWebhookAckBuilder b)]) = _$PaymentWebhookAck;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentWebhookAckBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentWebhookAck> get serializer => _$PaymentWebhookAckSerializer();
}

class _$PaymentWebhookAckSerializer implements PrimitiveSerializer<PaymentWebhookAck> {
  @override
  final Iterable<Type> types = const [PaymentWebhookAck, _$PaymentWebhookAck];

  @override
  final String wireName = r'PaymentWebhookAck';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentWebhookAck object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'received';
    yield serializers.serialize(
      object.received,
      specifiedType: const FullType(bool),
    );
    yield r'duplicate';
    yield serializers.serialize(
      object.duplicate,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentWebhookAck object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentWebhookAckBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'received':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.received = valueDes;
          break;
        case r'duplicate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.duplicate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentWebhookAck deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentWebhookAckBuilder();
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


