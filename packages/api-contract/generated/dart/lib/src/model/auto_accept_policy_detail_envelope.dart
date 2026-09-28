//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/auto_accept_policy_detail.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auto_accept_policy_detail_envelope.g.dart';

/// AutoAcceptPolicyDetailEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class AutoAcceptPolicyDetailEnvelope implements Built<AutoAcceptPolicyDetailEnvelope, AutoAcceptPolicyDetailEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  AutoAcceptPolicyDetail get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  AutoAcceptPolicyDetailEnvelope._();

  factory AutoAcceptPolicyDetailEnvelope([void updates(AutoAcceptPolicyDetailEnvelopeBuilder b)]) = _$AutoAcceptPolicyDetailEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutoAcceptPolicyDetailEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutoAcceptPolicyDetailEnvelope> get serializer => _$AutoAcceptPolicyDetailEnvelopeSerializer();
}

class _$AutoAcceptPolicyDetailEnvelopeSerializer implements PrimitiveSerializer<AutoAcceptPolicyDetailEnvelope> {
  @override
  final Iterable<Type> types = const [AutoAcceptPolicyDetailEnvelope, _$AutoAcceptPolicyDetailEnvelope];

  @override
  final String wireName = r'AutoAcceptPolicyDetailEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutoAcceptPolicyDetailEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(AutoAcceptPolicyDetail),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'errors';
    yield serializers.serialize(
      object.errors,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AutoAcceptPolicyDetailEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutoAcceptPolicyDetailEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AutoAcceptPolicyDetail),
          ) as AutoAcceptPolicyDetail;
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
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
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
  AutoAcceptPolicyDetailEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutoAcceptPolicyDetailEnvelopeBuilder();
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


