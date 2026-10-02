//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_webhook_payload.g.dart';

/// PaymentWebhookPayload
///
/// Properties:
/// * [event]
/// * [businessId]
/// * [created]
/// * [data]
@BuiltValue()
abstract class PaymentWebhookPayload implements Built<PaymentWebhookPayload, PaymentWebhookPayloadBuilder> {
  @BuiltValueField(wireName: r'event')
  String get event;

  @BuiltValueField(wireName: r'business_id')
  String? get businessId;

  @BuiltValueField(wireName: r'created')
  String? get created;

  @BuiltValueField(wireName: r'data')
  BuiltMap<String, JsonObject?> get data;

  PaymentWebhookPayload._();

  factory PaymentWebhookPayload([void updates(PaymentWebhookPayloadBuilder b)]) = _$PaymentWebhookPayload;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentWebhookPayloadBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentWebhookPayload> get serializer => _$PaymentWebhookPayloadSerializer();
}

class _$PaymentWebhookPayloadSerializer implements PrimitiveSerializer<PaymentWebhookPayload> {
  @override
  final Iterable<Type> types = const [PaymentWebhookPayload, _$PaymentWebhookPayload];

  @override
  final String wireName = r'PaymentWebhookPayload';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentWebhookPayload object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'event';
    yield serializers.serialize(
      object.event,
      specifiedType: const FullType(String),
    );
    if (object.businessId != null) {
      yield r'business_id';
      yield serializers.serialize(
        object.businessId,
        specifiedType: const FullType(String),
      );
    }
    if (object.created != null) {
      yield r'created';
      yield serializers.serialize(
        object.created,
        specifiedType: const FullType(String),
      );
    }
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentWebhookPayload object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentWebhookPayloadBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'event':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.event = valueDes;
          break;
        case r'business_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.businessId = valueDes;
          break;
        case r'created':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.created = valueDes;
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.data.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentWebhookPayload deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentWebhookPayloadBuilder();
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


