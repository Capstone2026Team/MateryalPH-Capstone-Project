//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_automated_choice.g.dart';

/// ChatAutomatedChoice
///
/// Properties:
/// * [welcomeMessageId]
/// * [optionIndex]
/// * [clientMessageId]
@BuiltValue()
abstract class ChatAutomatedChoice implements Built<ChatAutomatedChoice, ChatAutomatedChoiceBuilder> {
  @BuiltValueField(wireName: r'welcome_message_id')
  String get welcomeMessageId;

  @BuiltValueField(wireName: r'option_index')
  int get optionIndex;

  @BuiltValueField(wireName: r'client_message_id')
  String get clientMessageId;

  ChatAutomatedChoice._();

  factory ChatAutomatedChoice([void updates(ChatAutomatedChoiceBuilder b)]) = _$ChatAutomatedChoice;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatAutomatedChoiceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatAutomatedChoice> get serializer => _$ChatAutomatedChoiceSerializer();
}

class _$ChatAutomatedChoiceSerializer implements PrimitiveSerializer<ChatAutomatedChoice> {
  @override
  final Iterable<Type> types = const [ChatAutomatedChoice, _$ChatAutomatedChoice];

  @override
  final String wireName = r'ChatAutomatedChoice';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatAutomatedChoice object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'welcome_message_id';
    yield serializers.serialize(
      object.welcomeMessageId,
      specifiedType: const FullType(String),
    );
    yield r'option_index';
    yield serializers.serialize(
      object.optionIndex,
      specifiedType: const FullType(int),
    );
    yield r'client_message_id';
    yield serializers.serialize(
      object.clientMessageId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatAutomatedChoice object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatAutomatedChoiceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'welcome_message_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.welcomeMessageId = valueDes;
          break;
        case r'option_index':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.optionIndex = valueDes;
          break;
        case r'client_message_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientMessageId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatAutomatedChoice deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatAutomatedChoiceBuilder();
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


