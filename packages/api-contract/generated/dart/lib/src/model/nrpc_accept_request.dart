//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'nrpc_accept_request.g.dart';

/// NrpcAcceptRequest
///
/// Properties:
/// * [budgetOverrideReason]
/// * [snapshotVersion]
/// * [nrpcId]
/// * [termsVersionId] - The NRPC Terms version displayed with the proposal.
/// * [acknowledged]
@BuiltValue()
abstract class NrpcAcceptRequest implements Built<NrpcAcceptRequest, NrpcAcceptRequestBuilder> {
  @BuiltValueField(wireName: r'budget_override_reason')
  String? get budgetOverrideReason;

  @BuiltValueField(wireName: r'snapshot_version')
  int get snapshotVersion;

  @BuiltValueField(wireName: r'nrpc_id')
  String get nrpcId;

  /// The NRPC Terms version displayed with the proposal.
  @BuiltValueField(wireName: r'terms_version_id')
  String get termsVersionId;

  @BuiltValueField(wireName: r'acknowledged')
  NrpcAcceptRequestAcknowledgedEnum get acknowledged;
  // enum acknowledgedEnum {  true,  };

  NrpcAcceptRequest._();

  factory NrpcAcceptRequest([void updates(NrpcAcceptRequestBuilder b)]) = _$NrpcAcceptRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NrpcAcceptRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NrpcAcceptRequest> get serializer => _$NrpcAcceptRequestSerializer();
}

class _$NrpcAcceptRequestSerializer implements PrimitiveSerializer<NrpcAcceptRequest> {
  @override
  final Iterable<Type> types = const [NrpcAcceptRequest, _$NrpcAcceptRequest];

  @override
  final String wireName = r'NrpcAcceptRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NrpcAcceptRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.budgetOverrideReason != null) {
      yield r'budget_override_reason';
      yield serializers.serialize(
        object.budgetOverrideReason,
        specifiedType: const FullType(String),
      );
    }
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
    yield r'terms_version_id';
    yield serializers.serialize(
      object.termsVersionId,
      specifiedType: const FullType(String),
    );
    yield r'acknowledged';
    yield serializers.serialize(
      object.acknowledged,
      specifiedType: const FullType(NrpcAcceptRequestAcknowledgedEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NrpcAcceptRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NrpcAcceptRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'budget_override_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.budgetOverrideReason = valueDes;
          break;
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
        case r'terms_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.termsVersionId = valueDes;
          break;
        case r'acknowledged':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(NrpcAcceptRequestAcknowledgedEnum),
          ) as NrpcAcceptRequestAcknowledgedEnum;
          result.acknowledged = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NrpcAcceptRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NrpcAcceptRequestBuilder();
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


class NrpcAcceptRequestAcknowledgedEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const NrpcAcceptRequestAcknowledgedEnum true_ = _$nrpcAcceptRequestAcknowledgedEnum_true_;

  static Serializer<NrpcAcceptRequestAcknowledgedEnum> get serializer => _$nrpcAcceptRequestAcknowledgedEnumSerializer;

  const NrpcAcceptRequestAcknowledgedEnum._(String name): super(name);

  static BuiltSet<NrpcAcceptRequestAcknowledgedEnum> get values => _$nrpcAcceptRequestAcknowledgedEnumValues;
  static NrpcAcceptRequestAcknowledgedEnum valueOf(String name) => _$nrpcAcceptRequestAcknowledgedEnumValueOf(name);
}

