//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_typing.g.dart';

/// ChatTyping
///
/// Properties:
/// * [typing]
@BuiltValue()
abstract class ChatTyping implements Built<ChatTyping, ChatTypingBuilder> {
  @BuiltValueField(wireName: r'typing')
  bool get typing;

  ChatTyping._();

  factory ChatTyping([void updates(ChatTypingBuilder b)]) = _$ChatTyping;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatTypingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatTyping> get serializer => _$ChatTypingSerializer();
}

class _$ChatTypingSerializer implements PrimitiveSerializer<ChatTyping> {
  @override
  final Iterable<Type> types = const [ChatTyping, _$ChatTyping];

  @override
  final String wireName = r'ChatTyping';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatTyping object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'typing';
    yield serializers.serialize(
      object.typing,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatTyping object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatTypingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'typing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.typing = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatTyping deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatTypingBuilder();
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


