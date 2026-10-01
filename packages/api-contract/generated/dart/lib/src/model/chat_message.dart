//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/chat_attachment.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/chat_identity.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_message.g.dart';

/// ChatMessage
///
/// Properties:
/// * [id]
/// * [clientMessageId]
/// * [body]
/// * [kind]
/// * [sender]
/// * [sentAt]
/// * [mine]
/// * [attachments]
/// * [readByRecipient]
@BuiltValue()
abstract class ChatMessage implements Built<ChatMessage, ChatMessageBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'client_message_id')
  String get clientMessageId;

  @BuiltValueField(wireName: r'body')
  String get body;

  @BuiltValueField(wireName: r'kind')
  ChatMessageKindEnum get kind;
  // enum kindEnum {  TEXT,  SYSTEM,  ATTACHMENT,  };

  @BuiltValueField(wireName: r'sender')
  ChatIdentity get sender;

  @BuiltValueField(wireName: r'sent_at')
  String get sentAt;

  @BuiltValueField(wireName: r'mine')
  bool get mine;

  @BuiltValueField(wireName: r'attachments')
  BuiltList<ChatAttachment> get attachments;

  @BuiltValueField(wireName: r'read_by_recipient')
  bool get readByRecipient;

  ChatMessage._();

  factory ChatMessage([void updates(ChatMessageBuilder b)]) = _$ChatMessage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatMessageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatMessage> get serializer => _$ChatMessageSerializer();
}

class _$ChatMessageSerializer implements PrimitiveSerializer<ChatMessage> {
  @override
  final Iterable<Type> types = const [ChatMessage, _$ChatMessage];

  @override
  final String wireName = r'ChatMessage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatMessage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'client_message_id';
    yield serializers.serialize(
      object.clientMessageId,
      specifiedType: const FullType(String),
    );
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(ChatMessageKindEnum),
    );
    yield r'sender';
    yield serializers.serialize(
      object.sender,
      specifiedType: const FullType(ChatIdentity),
    );
    yield r'sent_at';
    yield serializers.serialize(
      object.sentAt,
      specifiedType: const FullType(String),
    );
    yield r'mine';
    yield serializers.serialize(
      object.mine,
      specifiedType: const FullType(bool),
    );
    yield r'attachments';
    yield serializers.serialize(
      object.attachments,
      specifiedType: const FullType(BuiltList, [FullType(ChatAttachment)]),
    );
    yield r'read_by_recipient';
    yield serializers.serialize(
      object.readByRecipient,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatMessage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatMessageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
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
            specifiedType: const FullType(String),
          ) as String;
          result.body = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatMessageKindEnum),
          ) as ChatMessageKindEnum;
          result.kind = valueDes;
          break;
        case r'sender':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatIdentity),
          ) as ChatIdentity;
          result.sender.replace(valueDes);
          break;
        case r'sent_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sentAt = valueDes;
          break;
        case r'mine':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.mine = valueDes;
          break;
        case r'attachments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChatAttachment)]),
          ) as BuiltList<ChatAttachment>;
          result.attachments.replace(valueDes);
          break;
        case r'read_by_recipient':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.readByRecipient = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatMessage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatMessageBuilder();
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


class ChatMessageKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEXT')
  static const ChatMessageKindEnum TEXT = _$chatMessageKindEnum_TEXT;
  @BuiltValueEnumConst(wireName: r'SYSTEM')
  static const ChatMessageKindEnum SYSTEM = _$chatMessageKindEnum_SYSTEM;
  @BuiltValueEnumConst(wireName: r'ATTACHMENT')
  static const ChatMessageKindEnum ATTACHMENT = _$chatMessageKindEnum_ATTACHMENT;

  static Serializer<ChatMessageKindEnum> get serializer => _$chatMessageKindEnumSerializer;

  const ChatMessageKindEnum._(String name): super(name);

  static BuiltSet<ChatMessageKindEnum> get values => _$chatMessageKindEnumValues;
  static ChatMessageKindEnum valueOf(String name) => _$chatMessageKindEnumValueOf(name);
}

