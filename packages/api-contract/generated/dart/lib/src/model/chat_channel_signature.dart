//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_channel_signature.g.dart';

/// ChatChannelSignature
///
/// Properties:
/// * [auth]
@BuiltValue()
abstract class ChatChannelSignature implements Built<ChatChannelSignature, ChatChannelSignatureBuilder> {
  @BuiltValueField(wireName: r'auth')
  String get auth;

  ChatChannelSignature._();

  factory ChatChannelSignature([void updates(ChatChannelSignatureBuilder b)]) = _$ChatChannelSignature;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatChannelSignatureBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatChannelSignature> get serializer => _$ChatChannelSignatureSerializer();
}

class _$ChatChannelSignatureSerializer implements PrimitiveSerializer<ChatChannelSignature> {
  @override
  final Iterable<Type> types = const [ChatChannelSignature, _$ChatChannelSignature];

  @override
  final String wireName = r'ChatChannelSignature';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatChannelSignature object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'auth';
    yield serializers.serialize(
      object.auth,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatChannelSignature object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatChannelSignatureBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'auth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.auth = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatChannelSignature deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatChannelSignatureBuilder();
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


