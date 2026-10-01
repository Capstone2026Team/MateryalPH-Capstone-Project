//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_decision_result.g.dart';

/// ChatDecisionResult
///
/// Properties:
/// * [orderId]
@BuiltValue()
abstract class ChatDecisionResult implements Built<ChatDecisionResult, ChatDecisionResultBuilder> {
  @BuiltValueField(wireName: r'order_id')
  String? get orderId;

  ChatDecisionResult._();

  factory ChatDecisionResult([void updates(ChatDecisionResultBuilder b)]) = _$ChatDecisionResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatDecisionResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatDecisionResult> get serializer => _$ChatDecisionResultSerializer();
}

class _$ChatDecisionResultSerializer implements PrimitiveSerializer<ChatDecisionResult> {
  @override
  final Iterable<Type> types = const [ChatDecisionResult, _$ChatDecisionResult];

  @override
  final String wireName = r'ChatDecisionResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatDecisionResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.orderId != null) {
      yield r'order_id';
      yield serializers.serialize(
        object.orderId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatDecisionResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatDecisionResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatDecisionResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatDecisionResultBuilder();
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


