//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_transfer.g.dart';

/// ChatTransfer
///
/// Properties:
/// * [handlerUserId]
/// * [lockVersion]
/// * [reason]
@BuiltValue()
abstract class ChatTransfer implements Built<ChatTransfer, ChatTransferBuilder> {
  @BuiltValueField(wireName: r'handler_user_id')
  int get handlerUserId;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  ChatTransfer._();

  factory ChatTransfer([void updates(ChatTransferBuilder b)]) = _$ChatTransfer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatTransferBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatTransfer> get serializer => _$ChatTransferSerializer();
}

class _$ChatTransferSerializer implements PrimitiveSerializer<ChatTransfer> {
  @override
  final Iterable<Type> types = const [ChatTransfer, _$ChatTransfer];

  @override
  final String wireName = r'ChatTransfer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatTransfer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'handler_user_id';
    yield serializers.serialize(
      object.handlerUserId,
      specifiedType: const FullType(int),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatTransfer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatTransferBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'handler_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.handlerUserId = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatTransfer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatTransferBuilder();
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


