//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_channel_auth_request.g.dart';

/// DisputeChannelAuthRequest
///
/// Properties:
/// * [socketId]
/// * [channelName]
@BuiltValue()
abstract class DisputeChannelAuthRequest implements Built<DisputeChannelAuthRequest, DisputeChannelAuthRequestBuilder> {
  @BuiltValueField(wireName: r'socket_id')
  String get socketId;

  @BuiltValueField(wireName: r'channel_name')
  String get channelName;

  DisputeChannelAuthRequest._();

  factory DisputeChannelAuthRequest([void updates(DisputeChannelAuthRequestBuilder b)]) = _$DisputeChannelAuthRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeChannelAuthRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeChannelAuthRequest> get serializer => _$DisputeChannelAuthRequestSerializer();
}

class _$DisputeChannelAuthRequestSerializer implements PrimitiveSerializer<DisputeChannelAuthRequest> {
  @override
  final Iterable<Type> types = const [DisputeChannelAuthRequest, _$DisputeChannelAuthRequest];

  @override
  final String wireName = r'DisputeChannelAuthRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeChannelAuthRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'socket_id';
    yield serializers.serialize(
      object.socketId,
      specifiedType: const FullType(String),
    );
    yield r'channel_name';
    yield serializers.serialize(
      object.channelName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeChannelAuthRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeChannelAuthRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'socket_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.socketId = valueDes;
          break;
        case r'channel_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.channelName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeChannelAuthRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeChannelAuthRequestBuilder();
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


