//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_automated_option.g.dart';

/// ChatAutomatedOption
///
/// Properties:
/// * [index]
/// * [label]
/// * [available]
@BuiltValue()
abstract class ChatAutomatedOption implements Built<ChatAutomatedOption, ChatAutomatedOptionBuilder> {
  @BuiltValueField(wireName: r'index')
  int get index;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'available')
  bool get available;

  ChatAutomatedOption._();

  factory ChatAutomatedOption([void updates(ChatAutomatedOptionBuilder b)]) = _$ChatAutomatedOption;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatAutomatedOptionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatAutomatedOption> get serializer => _$ChatAutomatedOptionSerializer();
}

class _$ChatAutomatedOptionSerializer implements PrimitiveSerializer<ChatAutomatedOption> {
  @override
  final Iterable<Type> types = const [ChatAutomatedOption, _$ChatAutomatedOption];

  @override
  final String wireName = r'ChatAutomatedOption';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatAutomatedOption object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'index';
    yield serializers.serialize(
      object.index,
      specifiedType: const FullType(int),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatAutomatedOption object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatAutomatedOptionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'index':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.index = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatAutomatedOption deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatAutomatedOptionBuilder();
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


