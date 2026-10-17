//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/order_fulfillment_conversation.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_fulfillment_conversation_envelope.g.dart';

/// OrderFulfillmentConversationEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class OrderFulfillmentConversationEnvelope implements Built<OrderFulfillmentConversationEnvelope, OrderFulfillmentConversationEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  OrderFulfillmentConversation get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  OrderFulfillmentConversationEnvelope._();

  factory OrderFulfillmentConversationEnvelope([void updates(OrderFulfillmentConversationEnvelopeBuilder b)]) = _$OrderFulfillmentConversationEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderFulfillmentConversationEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderFulfillmentConversationEnvelope> get serializer => _$OrderFulfillmentConversationEnvelopeSerializer();
}

class _$OrderFulfillmentConversationEnvelopeSerializer implements PrimitiveSerializer<OrderFulfillmentConversationEnvelope> {
  @override
  final Iterable<Type> types = const [OrderFulfillmentConversationEnvelope, _$OrderFulfillmentConversationEnvelope];

  @override
  final String wireName = r'OrderFulfillmentConversationEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderFulfillmentConversationEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(OrderFulfillmentConversation),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'errors';
    yield serializers.serialize(
      object.errors,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderFulfillmentConversationEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderFulfillmentConversationEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderFulfillmentConversation),
          ) as OrderFulfillmentConversation;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.meta.replace(valueDes);
          break;
        case r'errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.errors.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderFulfillmentConversationEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderFulfillmentConversationEnvelopeBuilder();
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


