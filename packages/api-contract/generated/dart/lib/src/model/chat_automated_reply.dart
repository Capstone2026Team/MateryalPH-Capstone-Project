//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/chat_automated_option.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_automated_reply.g.dart';

/// ChatAutomatedReply
///
/// Properties:
/// * [options]
@BuiltValue()
abstract class ChatAutomatedReply implements Built<ChatAutomatedReply, ChatAutomatedReplyBuilder> {
  @BuiltValueField(wireName: r'options')
  BuiltList<ChatAutomatedOption> get options;

  ChatAutomatedReply._();

  factory ChatAutomatedReply([void updates(ChatAutomatedReplyBuilder b)]) = _$ChatAutomatedReply;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatAutomatedReplyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatAutomatedReply> get serializer => _$ChatAutomatedReplySerializer();
}

class _$ChatAutomatedReplySerializer implements PrimitiveSerializer<ChatAutomatedReply> {
  @override
  final Iterable<Type> types = const [ChatAutomatedReply, _$ChatAutomatedReply];

  @override
  final String wireName = r'ChatAutomatedReply';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatAutomatedReply object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'options';
    yield serializers.serialize(
      object.options,
      specifiedType: const FullType(BuiltList, [FullType(ChatAutomatedOption)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatAutomatedReply object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatAutomatedReplyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChatAutomatedOption)]),
          ) as BuiltList<ChatAutomatedOption>;
          result.options.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatAutomatedReply deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatAutomatedReplyBuilder();
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


