//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_realtime.g.dart';

/// DisputeRealtime
///
/// Properties:
/// * [channel]
/// * [enabled]
/// * [key]
/// * [host]
/// * [port]
/// * [scheme]
@BuiltValue()
abstract class DisputeRealtime implements Built<DisputeRealtime, DisputeRealtimeBuilder> {
  @BuiltValueField(wireName: r'channel')
  String? get channel;

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'key')
  String? get key;

  @BuiltValueField(wireName: r'host')
  String? get host;

  @BuiltValueField(wireName: r'port')
  int? get port;

  @BuiltValueField(wireName: r'scheme')
  String? get scheme;

  DisputeRealtime._();

  factory DisputeRealtime([void updates(DisputeRealtimeBuilder b)]) = _$DisputeRealtime;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeRealtimeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeRealtime> get serializer => _$DisputeRealtimeSerializer();
}

class _$DisputeRealtimeSerializer implements PrimitiveSerializer<DisputeRealtime> {
  @override
  final Iterable<Type> types = const [DisputeRealtime, _$DisputeRealtime];

  @override
  final String wireName = r'DisputeRealtime';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeRealtime object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.channel != null) {
      yield r'channel';
      yield serializers.serialize(
        object.channel,
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
    if (object.port != null) {
      yield r'port';
      yield serializers.serialize(
        object.port,
        specifiedType: const FullType(int),
      );
    }
    if (object.scheme != null) {
      yield r'scheme';
      yield serializers.serialize(
        object.scheme,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeRealtime object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeRealtimeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.channel = valueDes;
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
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.port = valueDes;
          break;
        case r'scheme':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  DisputeRealtime deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeRealtimeBuilder();
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


