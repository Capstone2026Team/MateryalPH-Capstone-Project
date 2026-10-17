//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_conversation_ref.g.dart';

/// OrderConversationRef
///
/// Properties:
/// * [id]
/// * [readOnly] - True once the order is completed
/// * [unreadCount]
@BuiltValue()
abstract class OrderConversationRef implements Built<OrderConversationRef, OrderConversationRefBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// True once the order is completed
  @BuiltValueField(wireName: r'read_only')
  bool get readOnly;

  @BuiltValueField(wireName: r'unread_count')
  int get unreadCount;

  OrderConversationRef._();

  factory OrderConversationRef([void updates(OrderConversationRefBuilder b)]) = _$OrderConversationRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderConversationRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderConversationRef> get serializer => _$OrderConversationRefSerializer();
}

class _$OrderConversationRefSerializer implements PrimitiveSerializer<OrderConversationRef> {
  @override
  final Iterable<Type> types = const [OrderConversationRef, _$OrderConversationRef];

  @override
  final String wireName = r'OrderConversationRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderConversationRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'read_only';
    yield serializers.serialize(
      object.readOnly,
      specifiedType: const FullType(bool),
    );
    yield r'unread_count';
    yield serializers.serialize(
      object.unreadCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderConversationRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderConversationRefBuilder result,
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
        case r'read_only':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.readOnly = valueDes;
          break;
        case r'unread_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unreadCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderConversationRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderConversationRefBuilder();
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


