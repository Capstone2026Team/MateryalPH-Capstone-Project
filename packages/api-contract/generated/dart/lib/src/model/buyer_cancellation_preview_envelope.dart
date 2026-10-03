//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/buyer_cancellation_preview.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_cancellation_preview_envelope.g.dart';

/// BuyerCancellationPreviewEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class BuyerCancellationPreviewEnvelope implements Built<BuyerCancellationPreviewEnvelope, BuyerCancellationPreviewEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuyerCancellationPreview get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  BuyerCancellationPreviewEnvelope._();

  factory BuyerCancellationPreviewEnvelope([void updates(BuyerCancellationPreviewEnvelopeBuilder b)]) = _$BuyerCancellationPreviewEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerCancellationPreviewEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerCancellationPreviewEnvelope> get serializer => _$BuyerCancellationPreviewEnvelopeSerializer();
}

class _$BuyerCancellationPreviewEnvelopeSerializer implements PrimitiveSerializer<BuyerCancellationPreviewEnvelope> {
  @override
  final Iterable<Type> types = const [BuyerCancellationPreviewEnvelope, _$BuyerCancellationPreviewEnvelope];

  @override
  final String wireName = r'BuyerCancellationPreviewEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerCancellationPreviewEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuyerCancellationPreview),
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
    BuyerCancellationPreviewEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerCancellationPreviewEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerCancellationPreview),
          ) as BuyerCancellationPreview;
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
  BuyerCancellationPreviewEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerCancellationPreviewEnvelopeBuilder();
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


