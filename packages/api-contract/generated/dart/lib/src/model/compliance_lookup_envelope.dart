//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/compliance_lookup.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'compliance_lookup_envelope.g.dart';

/// ComplianceLookupEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class ComplianceLookupEnvelope implements Built<ComplianceLookupEnvelope, ComplianceLookupEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  ComplianceLookup get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  ComplianceLookupEnvelope._();

  factory ComplianceLookupEnvelope([void updates(ComplianceLookupEnvelopeBuilder b)]) = _$ComplianceLookupEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComplianceLookupEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComplianceLookupEnvelope> get serializer => _$ComplianceLookupEnvelopeSerializer();
}

class _$ComplianceLookupEnvelopeSerializer implements PrimitiveSerializer<ComplianceLookupEnvelope> {
  @override
  final Iterable<Type> types = const [ComplianceLookupEnvelope, _$ComplianceLookupEnvelope];

  @override
  final String wireName = r'ComplianceLookupEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComplianceLookupEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(ComplianceLookup),
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
    ComplianceLookupEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComplianceLookupEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComplianceLookup),
          ) as ComplianceLookup;
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
  ComplianceLookupEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComplianceLookupEnvelopeBuilder();
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


