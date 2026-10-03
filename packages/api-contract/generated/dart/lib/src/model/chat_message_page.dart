//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/chat_message.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_message_page.g.dart';

/// ChatMessagePage
///
/// Properties:
/// * [items]
/// * [hasMore]
/// * [nextBefore]
@BuiltValue()
abstract class ChatMessagePage implements Built<ChatMessagePage, ChatMessagePageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<ChatMessage> get items;

  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  @BuiltValueField(wireName: r'next_before')
  String? get nextBefore;

  ChatMessagePage._();

  factory ChatMessagePage([void updates(ChatMessagePageBuilder b)]) = _$ChatMessagePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatMessagePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatMessagePage> get serializer => _$ChatMessagePageSerializer();
}

class _$ChatMessagePageSerializer implements PrimitiveSerializer<ChatMessagePage> {
  @override
  final Iterable<Type> types = const [ChatMessagePage, _$ChatMessagePage];

  @override
  final String wireName = r'ChatMessagePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatMessagePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ChatMessage)]),
    );
    yield r'has_more';
    yield serializers.serialize(
      object.hasMore,
      specifiedType: const FullType(bool),
    );
    if (object.nextBefore != null) {
      yield r'next_before';
      yield serializers.serialize(
        object.nextBefore,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatMessagePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatMessagePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChatMessage)]),
          ) as BuiltList<ChatMessage>;
          result.items.replace(valueDes);
          break;
        case r'has_more':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasMore = valueDes;
          break;
        case r'next_before':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextBefore = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatMessagePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatMessagePageBuilder();
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


