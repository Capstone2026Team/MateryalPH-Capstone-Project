//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/remittance_reconciliation_decision.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'remittance_reconciliation_decision_envelope.g.dart';

/// RemittanceReconciliationDecisionEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class RemittanceReconciliationDecisionEnvelope implements Built<RemittanceReconciliationDecisionEnvelope, RemittanceReconciliationDecisionEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  RemittanceReconciliationDecision get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  RemittanceReconciliationDecisionEnvelope._();

  factory RemittanceReconciliationDecisionEnvelope([void updates(RemittanceReconciliationDecisionEnvelopeBuilder b)]) = _$RemittanceReconciliationDecisionEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RemittanceReconciliationDecisionEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RemittanceReconciliationDecisionEnvelope> get serializer => _$RemittanceReconciliationDecisionEnvelopeSerializer();
}

class _$RemittanceReconciliationDecisionEnvelopeSerializer implements PrimitiveSerializer<RemittanceReconciliationDecisionEnvelope> {
  @override
  final Iterable<Type> types = const [RemittanceReconciliationDecisionEnvelope, _$RemittanceReconciliationDecisionEnvelope];

  @override
  final String wireName = r'RemittanceReconciliationDecisionEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RemittanceReconciliationDecisionEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(RemittanceReconciliationDecision),
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
    RemittanceReconciliationDecisionEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RemittanceReconciliationDecisionEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RemittanceReconciliationDecision),
          ) as RemittanceReconciliationDecision;
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
  RemittanceReconciliationDecisionEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RemittanceReconciliationDecisionEnvelopeBuilder();
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


