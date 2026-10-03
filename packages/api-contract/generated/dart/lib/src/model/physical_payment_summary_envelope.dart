//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:built_value/json_object.dart';
import 'package:materyalph_api_client/src/model/physical_payment_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'physical_payment_summary_envelope.g.dart';

/// PhysicalPaymentSummaryEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class PhysicalPaymentSummaryEnvelope implements Built<PhysicalPaymentSummaryEnvelope, PhysicalPaymentSummaryEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  PhysicalPaymentSummary get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  PhysicalPaymentSummaryEnvelope._();

  factory PhysicalPaymentSummaryEnvelope([void updates(PhysicalPaymentSummaryEnvelopeBuilder b)]) = _$PhysicalPaymentSummaryEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PhysicalPaymentSummaryEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PhysicalPaymentSummaryEnvelope> get serializer => _$PhysicalPaymentSummaryEnvelopeSerializer();
}

class _$PhysicalPaymentSummaryEnvelopeSerializer implements PrimitiveSerializer<PhysicalPaymentSummaryEnvelope> {
  @override
  final Iterable<Type> types = const [PhysicalPaymentSummaryEnvelope, _$PhysicalPaymentSummaryEnvelope];

  @override
  final String wireName = r'PhysicalPaymentSummaryEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PhysicalPaymentSummaryEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(PhysicalPaymentSummary),
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
    PhysicalPaymentSummaryEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PhysicalPaymentSummaryEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PhysicalPaymentSummary),
          ) as PhysicalPaymentSummary;
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
  PhysicalPaymentSummaryEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PhysicalPaymentSummaryEnvelopeBuilder();
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


