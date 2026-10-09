//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/audit_event.dart';
import 'package:materyalph_api_client/src/model/audit_search_meta.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'audit_event_list_envelope.g.dart';

/// AuditEventListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class AuditEventListEnvelope implements Built<AuditEventListEnvelope, AuditEventListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<AuditEvent> get data;

  @BuiltValueField(wireName: r'meta')
  AuditSearchMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  AuditEventListEnvelope._();

  factory AuditEventListEnvelope([void updates(AuditEventListEnvelopeBuilder b)]) = _$AuditEventListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuditEventListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuditEventListEnvelope> get serializer => _$AuditEventListEnvelopeSerializer();
}

class _$AuditEventListEnvelopeSerializer implements PrimitiveSerializer<AuditEventListEnvelope> {
  @override
  final Iterable<Type> types = const [AuditEventListEnvelope, _$AuditEventListEnvelope];

  @override
  final String wireName = r'AuditEventListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuditEventListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(AuditEvent)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(AuditSearchMeta),
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
    AuditEventListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuditEventListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AuditEvent)]),
          ) as BuiltList<AuditEvent>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AuditSearchMeta),
          ) as AuditSearchMeta;
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
  AuditEventListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuditEventListEnvelopeBuilder();
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


