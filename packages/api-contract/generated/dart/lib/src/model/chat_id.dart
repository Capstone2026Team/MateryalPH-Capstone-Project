//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_id.g.dart';

/// ChatId
///
/// Properties:
/// * [id]
@BuiltValue()
abstract class ChatId implements Built<ChatId, ChatIdBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  ChatId._();

  factory ChatId([void updates(ChatIdBuilder b)]) = _$ChatId;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatIdBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatId> get serializer => _$ChatIdSerializer();
}

class _$ChatIdSerializer implements PrimitiveSerializer<ChatId> {
  @override
  final Iterable<Type> types = const [ChatId, _$ChatId];

  @override
  final String wireName = r'ChatId';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatId object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatId object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatIdBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatId deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatIdBuilder();
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


