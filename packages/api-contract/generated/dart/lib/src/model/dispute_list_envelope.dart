//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dispute_list_meta.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/dispute_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_list_envelope.g.dart';

/// DisputeListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class DisputeListEnvelope implements Built<DisputeListEnvelope, DisputeListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<DisputeSummary> get data;

  @BuiltValueField(wireName: r'meta')
  DisputeListMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  DisputeListEnvelope._();

  factory DisputeListEnvelope([void updates(DisputeListEnvelopeBuilder b)]) = _$DisputeListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeListEnvelope> get serializer => _$DisputeListEnvelopeSerializer();
}

class _$DisputeListEnvelopeSerializer implements PrimitiveSerializer<DisputeListEnvelope> {
  @override
  final Iterable<Type> types = const [DisputeListEnvelope, _$DisputeListEnvelope];

  @override
  final String wireName = r'DisputeListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(DisputeSummary)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(DisputeListMeta),
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
    DisputeListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeSummary)]),
          ) as BuiltList<DisputeSummary>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeListMeta),
          ) as DisputeListMeta;
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
  DisputeListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeListEnvelopeBuilder();
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


