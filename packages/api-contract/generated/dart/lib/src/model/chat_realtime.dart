//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_realtime.g.dart';

/// ChatRealtime
///
/// Properties:
/// * [inboxChannel] - Viewer-bound Buyer or Vendor inbox invalidation channel. Re-fetch configuration on reconnect. No message content is broadcast.
/// * [enabled]
/// * [key]
/// * [host]
/// * [port]
/// * [scheme]
@BuiltValue()
abstract class ChatRealtime implements Built<ChatRealtime, ChatRealtimeBuilder> {
  /// Viewer-bound Buyer or Vendor inbox invalidation channel. Re-fetch configuration on reconnect. No message content is broadcast.
  @BuiltValueField(wireName: r'inbox_channel')
  String? get inboxChannel;

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'key')
  String? get key;

  @BuiltValueField(wireName: r'host')
  String? get host;

  @BuiltValueField(wireName: r'port')
  int get port;

  @BuiltValueField(wireName: r'scheme')
  String get scheme;

  ChatRealtime._();

  factory ChatRealtime([void updates(ChatRealtimeBuilder b)]) = _$ChatRealtime;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatRealtimeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatRealtime> get serializer => _$ChatRealtimeSerializer();
}

class _$ChatRealtimeSerializer implements PrimitiveSerializer<ChatRealtime> {
  @override
  final Iterable<Type> types = const [ChatRealtime, _$ChatRealtime];

  @override
  final String wireName = r'ChatRealtime';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatRealtime object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.inboxChannel != null) {
      yield r'inbox_channel';
      yield serializers.serialize(
        object.inboxChannel,
        specifiedType: const FullType(String),
      );
    }
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    if (object.key != null) {
      yield r'key';
      yield serializers.serialize(
        object.key,
        specifiedType: const FullType(String),
      );
    }
    if (object.host != null) {
      yield r'host';
      yield serializers.serialize(
        object.host,
        specifiedType: const FullType(String),
      );
    }
    yield r'port';
    yield serializers.serialize(
      object.port,
      specifiedType: const FullType(int),
    );
    yield r'scheme';
    yield serializers.serialize(
      object.scheme,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatRealtime object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatRealtimeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'inbox_channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.inboxChannel = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.key = valueDes;
          break;
        case r'host':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.host = valueDes;
          break;
        case r'port':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.port = valueDes;
          break;
        case r'scheme':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.scheme = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatRealtime deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatRealtimeBuilder();
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


