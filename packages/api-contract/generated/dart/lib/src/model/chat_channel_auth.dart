//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_channel_auth.g.dart';

/// ChatChannelAuth
///
/// Properties:
/// * [socketId]
/// * [channelName]
@BuiltValue()
abstract class ChatChannelAuth implements Built<ChatChannelAuth, ChatChannelAuthBuilder> {
  @BuiltValueField(wireName: r'socket_id')
  String get socketId;

  @BuiltValueField(wireName: r'channel_name')
  String get channelName;

  ChatChannelAuth._();

  factory ChatChannelAuth([void updates(ChatChannelAuthBuilder b)]) = _$ChatChannelAuth;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatChannelAuthBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatChannelAuth> get serializer => _$ChatChannelAuthSerializer();
}

class _$ChatChannelAuthSerializer implements PrimitiveSerializer<ChatChannelAuth> {
  @override
  final Iterable<Type> types = const [ChatChannelAuth, _$ChatChannelAuth];

  @override
  final String wireName = r'ChatChannelAuth';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatChannelAuth object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'socket_id';
    yield serializers.serialize(
      object.socketId,
      specifiedType: const FullType(String),
    );
    yield r'channel_name';
    yield serializers.serialize(
      object.channelName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatChannelAuth object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatChannelAuthBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'socket_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.socketId = valueDes;
          break;
        case r'channel_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.channelName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatChannelAuth deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatChannelAuthBuilder();
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


