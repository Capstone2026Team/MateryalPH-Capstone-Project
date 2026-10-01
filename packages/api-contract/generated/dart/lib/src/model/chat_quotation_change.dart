//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_quotation_change.g.dart';

/// ChatQuotationChange
///
/// Properties:
/// * [path]
/// * [label]
/// * [before]
/// * [after]
@BuiltValue()
abstract class ChatQuotationChange implements Built<ChatQuotationChange, ChatQuotationChangeBuilder> {
  @BuiltValueField(wireName: r'path')
  String get path;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'before')
  JsonObject? get before;

  @BuiltValueField(wireName: r'after')
  JsonObject? get after;

  ChatQuotationChange._();

  factory ChatQuotationChange([void updates(ChatQuotationChangeBuilder b)]) = _$ChatQuotationChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatQuotationChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatQuotationChange> get serializer => _$ChatQuotationChangeSerializer();
}

class _$ChatQuotationChangeSerializer implements PrimitiveSerializer<ChatQuotationChange> {
  @override
  final Iterable<Type> types = const [ChatQuotationChange, _$ChatQuotationChange];

  @override
  final String wireName = r'ChatQuotationChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatQuotationChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'path';
    yield serializers.serialize(
      object.path,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'before';
    yield object.before == null ? null : serializers.serialize(
      object.before,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'after';
    yield object.after == null ? null : serializers.serialize(
      object.after,
      specifiedType: const FullType.nullable(JsonObject),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatQuotationChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatQuotationChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.path = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'before':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.before = valueDes;
          break;
        case r'after':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.after = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatQuotationChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatQuotationChangeBuilder();
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


