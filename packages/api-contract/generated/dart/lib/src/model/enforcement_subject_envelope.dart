//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/enforcement_subject_envelope_data.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'enforcement_subject_envelope.g.dart';

/// EnforcementSubjectEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class EnforcementSubjectEnvelope implements Built<EnforcementSubjectEnvelope, EnforcementSubjectEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  EnforcementSubjectEnvelopeData get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  EnforcementSubjectEnvelope._();

  factory EnforcementSubjectEnvelope([void updates(EnforcementSubjectEnvelopeBuilder b)]) = _$EnforcementSubjectEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EnforcementSubjectEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnforcementSubjectEnvelope> get serializer => _$EnforcementSubjectEnvelopeSerializer();
}

class _$EnforcementSubjectEnvelopeSerializer implements PrimitiveSerializer<EnforcementSubjectEnvelope> {
  @override
  final Iterable<Type> types = const [EnforcementSubjectEnvelope, _$EnforcementSubjectEnvelope];

  @override
  final String wireName = r'EnforcementSubjectEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EnforcementSubjectEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(EnforcementSubjectEnvelopeData),
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
    EnforcementSubjectEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EnforcementSubjectEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EnforcementSubjectEnvelopeData),
          ) as EnforcementSubjectEnvelopeData;
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
  EnforcementSubjectEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EnforcementSubjectEnvelopeBuilder();
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


