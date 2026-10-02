//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/channel_fee_version.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'channel_fee_version_list_envelope.g.dart';

/// ChannelFeeVersionListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class ChannelFeeVersionListEnvelope implements Built<ChannelFeeVersionListEnvelope, ChannelFeeVersionListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<ChannelFeeVersion> get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  ChannelFeeVersionListEnvelope._();

  factory ChannelFeeVersionListEnvelope([void updates(ChannelFeeVersionListEnvelopeBuilder b)]) = _$ChannelFeeVersionListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChannelFeeVersionListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChannelFeeVersionListEnvelope> get serializer => _$ChannelFeeVersionListEnvelopeSerializer();
}

class _$ChannelFeeVersionListEnvelopeSerializer implements PrimitiveSerializer<ChannelFeeVersionListEnvelope> {
  @override
  final Iterable<Type> types = const [ChannelFeeVersionListEnvelope, _$ChannelFeeVersionListEnvelope];

  @override
  final String wireName = r'ChannelFeeVersionListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChannelFeeVersionListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(ChannelFeeVersion)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'errors';
    yield serializers.serialize(
      object.errors,
      specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChannelFeeVersionListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChannelFeeVersionListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChannelFeeVersion)]),
          ) as BuiltList<ChannelFeeVersion>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.meta.replace(valueDes);
          break;
        case r'errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
          ) as BuiltList<ApiError>;
          result.errors.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChannelFeeVersionListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChannelFeeVersionListEnvelopeBuilder();
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


