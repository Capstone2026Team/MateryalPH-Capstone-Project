//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/chat_draft_content.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_draft_save.g.dart';

/// ChatDraftSave
///
/// Properties:
/// * [lockVersion]
/// * [draft]
@BuiltValue()
abstract class ChatDraftSave implements Built<ChatDraftSave, ChatDraftSaveBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'draft')
  ChatDraftContent get draft;

  ChatDraftSave._();

  factory ChatDraftSave([void updates(ChatDraftSaveBuilder b)]) = _$ChatDraftSave;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatDraftSaveBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatDraftSave> get serializer => _$ChatDraftSaveSerializer();
}

class _$ChatDraftSaveSerializer implements PrimitiveSerializer<ChatDraftSave> {
  @override
  final Iterable<Type> types = const [ChatDraftSave, _$ChatDraftSave];

  @override
  final String wireName = r'ChatDraftSave';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatDraftSave object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'draft';
    yield serializers.serialize(
      object.draft,
      specifiedType: const FullType(ChatDraftContent),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatDraftSave object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatDraftSaveBuilder result,
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
        case r'draft':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatDraftContent),
          ) as ChatDraftContent;
          result.draft.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatDraftSave deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatDraftSaveBuilder();
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


