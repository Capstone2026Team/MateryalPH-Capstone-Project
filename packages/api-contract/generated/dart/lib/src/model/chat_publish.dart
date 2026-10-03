//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_publish.g.dart';

/// ChatPublish
///
/// Properties:
/// * [lockVersion]
@BuiltValue()
abstract class ChatPublish implements Built<ChatPublish, ChatPublishBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  ChatPublish._();

  factory ChatPublish([void updates(ChatPublishBuilder b)]) = _$ChatPublish;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatPublishBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatPublish> get serializer => _$ChatPublishSerializer();
}

class _$ChatPublishSerializer implements PrimitiveSerializer<ChatPublish> {
  @override
  final Iterable<Type> types = const [ChatPublish, _$ChatPublish];

  @override
  final String wireName = r'ChatPublish';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatPublish object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatPublish object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatPublishBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatPublish deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatPublishBuilder();
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


