//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'nrpc_flag_request.g.dart';

/// NrpcFlagRequest
///
/// Properties:
/// * [nrpcId]
/// * [reason]
@BuiltValue()
abstract class NrpcFlagRequest implements Built<NrpcFlagRequest, NrpcFlagRequestBuilder> {
  @BuiltValueField(wireName: r'nrpc_id')
  String get nrpcId;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  NrpcFlagRequest._();

  factory NrpcFlagRequest([void updates(NrpcFlagRequestBuilder b)]) = _$NrpcFlagRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NrpcFlagRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NrpcFlagRequest> get serializer => _$NrpcFlagRequestSerializer();
}

class _$NrpcFlagRequestSerializer implements PrimitiveSerializer<NrpcFlagRequest> {
  @override
  final Iterable<Type> types = const [NrpcFlagRequest, _$NrpcFlagRequest];

  @override
  final String wireName = r'NrpcFlagRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NrpcFlagRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'nrpc_id';
    yield serializers.serialize(
      object.nrpcId,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NrpcFlagRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NrpcFlagRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'nrpc_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nrpcId = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NrpcFlagRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NrpcFlagRequestBuilder();
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


