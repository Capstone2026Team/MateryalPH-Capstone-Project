//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/chat_quotation_page.dart';
import 'package:materyalph_api_client/src/model/conversation_view.dart';
import 'package:materyalph_api_client/src/model/chat_message_page.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'conversation_detail.g.dart';

/// ConversationDetail
///
/// Properties:
/// * [conversation]
/// * [messages]
/// * [quotations]
@BuiltValue()
abstract class ConversationDetail implements Built<ConversationDetail, ConversationDetailBuilder> {
  @BuiltValueField(wireName: r'conversation')
  ConversationView get conversation;

  @BuiltValueField(wireName: r'messages')
  ChatMessagePage get messages;

  @BuiltValueField(wireName: r'quotations')
  ChatQuotationPage get quotations;

  ConversationDetail._();

  factory ConversationDetail([void updates(ConversationDetailBuilder b)]) = _$ConversationDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConversationDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConversationDetail> get serializer => _$ConversationDetailSerializer();
}

class _$ConversationDetailSerializer implements PrimitiveSerializer<ConversationDetail> {
  @override
  final Iterable<Type> types = const [ConversationDetail, _$ConversationDetail];

  @override
  final String wireName = r'ConversationDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConversationDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'conversation';
    yield serializers.serialize(
      object.conversation,
      specifiedType: const FullType(ConversationView),
    );
    yield r'messages';
    yield serializers.serialize(
      object.messages,
      specifiedType: const FullType(ChatMessagePage),
    );
    yield r'quotations';
    yield serializers.serialize(
      object.quotations,
      specifiedType: const FullType(ChatQuotationPage),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ConversationDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ConversationDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'conversation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ConversationView),
          ) as ConversationView;
          result.conversation.replace(valueDes);
          break;
        case r'messages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatMessagePage),
          ) as ChatMessagePage;
          result.messages.replace(valueDes);
          break;
        case r'quotations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatQuotationPage),
          ) as ChatQuotationPage;
          result.quotations.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConversationDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConversationDetailBuilder();
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


