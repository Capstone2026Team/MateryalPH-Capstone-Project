//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_fulfillment_conversation.g.dart';

/// OrderFulfillmentConversation
///
/// Properties:
/// * [conversationId]
/// * [readOnly]
@BuiltValue()
abstract class OrderFulfillmentConversation implements Built<OrderFulfillmentConversation, OrderFulfillmentConversationBuilder> {
  @BuiltValueField(wireName: r'conversation_id')
  String get conversationId;

  @BuiltValueField(wireName: r'read_only')
  bool get readOnly;

  OrderFulfillmentConversation._();

  factory OrderFulfillmentConversation([void updates(OrderFulfillmentConversationBuilder b)]) = _$OrderFulfillmentConversation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderFulfillmentConversationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderFulfillmentConversation> get serializer => _$OrderFulfillmentConversationSerializer();
}

class _$OrderFulfillmentConversationSerializer implements PrimitiveSerializer<OrderFulfillmentConversation> {
  @override
  final Iterable<Type> types = const [OrderFulfillmentConversation, _$OrderFulfillmentConversation];

  @override
  final String wireName = r'OrderFulfillmentConversation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderFulfillmentConversation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'conversation_id';
    yield serializers.serialize(
      object.conversationId,
      specifiedType: const FullType(String),
    );
    yield r'read_only';
    yield serializers.serialize(
      object.readOnly,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderFulfillmentConversation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderFulfillmentConversationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'conversation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.conversationId = valueDes;
          break;
        case r'read_only':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.readOnly = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderFulfillmentConversation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderFulfillmentConversationBuilder();
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


