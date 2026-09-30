//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'nrpc_reject_request.g.dart';

/// NrpcRejectRequest
///
/// Properties:
/// * [snapshotVersion]
/// * [nrpcId]
/// * [reason]
@BuiltValue()
abstract class NrpcRejectRequest implements Built<NrpcRejectRequest, NrpcRejectRequestBuilder> {
  @BuiltValueField(wireName: r'snapshot_version')
  int get snapshotVersion;

  @BuiltValueField(wireName: r'nrpc_id')
  String get nrpcId;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  NrpcRejectRequest._();

  factory NrpcRejectRequest([void updates(NrpcRejectRequestBuilder b)]) = _$NrpcRejectRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NrpcRejectRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NrpcRejectRequest> get serializer => _$NrpcRejectRequestSerializer();
}

class _$NrpcRejectRequestSerializer implements PrimitiveSerializer<NrpcRejectRequest> {
  @override
  final Iterable<Type> types = const [NrpcRejectRequest, _$NrpcRejectRequest];

  @override
  final String wireName = r'NrpcRejectRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NrpcRejectRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'snapshot_version';
    yield serializers.serialize(
      object.snapshotVersion,
      specifiedType: const FullType(int),
    );
    yield r'nrpc_id';
    yield serializers.serialize(
      object.nrpcId,
      specifiedType: const FullType(String),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NrpcRejectRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NrpcRejectRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'snapshot_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.snapshotVersion = valueDes;
          break;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  NrpcRejectRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NrpcRejectRequestBuilder();
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


