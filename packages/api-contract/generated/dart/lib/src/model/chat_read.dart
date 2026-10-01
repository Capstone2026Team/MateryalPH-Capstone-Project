//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_read.g.dart';

/// ChatRead
///
/// Properties:
/// * [throughMessageId]
@BuiltValue()
abstract class ChatRead implements Built<ChatRead, ChatReadBuilder> {
  @BuiltValueField(wireName: r'through_message_id')
  String get throughMessageId;

  ChatRead._();

  factory ChatRead([void updates(ChatReadBuilder b)]) = _$ChatRead;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatReadBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatRead> get serializer => _$ChatReadSerializer();
}

class _$ChatReadSerializer implements PrimitiveSerializer<ChatRead> {
  @override
  final Iterable<Type> types = const [ChatRead, _$ChatRead];

  @override
  final String wireName = r'ChatRead';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatRead object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'through_message_id';
    yield serializers.serialize(
      object.throughMessageId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatRead object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatReadBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'through_message_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.throughMessageId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatRead deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatReadBuilder();
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


