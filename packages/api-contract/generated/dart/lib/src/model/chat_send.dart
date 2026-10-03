//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_send.g.dart';

/// Requires nonblank body or product_id (listing variant UUID), or both. The product must be an eligible product of this conversation store. Retries with the same client_message_id and content return the same message; changed content conflicts.
///
/// Properties:
/// * [clientMessageId]
/// * [body]
/// * [productId]
@BuiltValue()
abstract class ChatSend implements Built<ChatSend, ChatSendBuilder> {
  @BuiltValueField(wireName: r'client_message_id')
  String get clientMessageId;

  @BuiltValueField(wireName: r'body')
  String? get body;

  @BuiltValueField(wireName: r'product_id')
  String? get productId;

  ChatSend._();

  factory ChatSend([void updates(ChatSendBuilder b)]) = _$ChatSend;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatSendBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatSend> get serializer => _$ChatSendSerializer();
}

class _$ChatSendSerializer implements PrimitiveSerializer<ChatSend> {
  @override
  final Iterable<Type> types = const [ChatSend, _$ChatSend];

  @override
  final String wireName = r'ChatSend';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatSend object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'client_message_id';
    yield serializers.serialize(
      object.clientMessageId,
      specifiedType: const FullType(String),
    );
    if (object.body != null) {
      yield r'body';
      yield serializers.serialize(
        object.body,
        specifiedType: const FullType(String),
      );
    }
    if (object.productId != null) {
      yield r'product_id';
      yield serializers.serialize(
        object.productId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatSend object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatSendBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'client_message_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientMessageId = valueDes;
          break;
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.body = valueDes;
          break;
        case r'product_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.productId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatSend deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatSendBuilder();
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


