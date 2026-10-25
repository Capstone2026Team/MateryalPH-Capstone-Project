//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/buyer_analytics_product_detail.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_analytics_product_detail_envelope.g.dart';

/// BuyerAnalyticsProductDetailEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class BuyerAnalyticsProductDetailEnvelope implements Built<BuyerAnalyticsProductDetailEnvelope, BuyerAnalyticsProductDetailEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuyerAnalyticsProductDetail get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  BuyerAnalyticsProductDetailEnvelope._();

  factory BuyerAnalyticsProductDetailEnvelope([void updates(BuyerAnalyticsProductDetailEnvelopeBuilder b)]) = _$BuyerAnalyticsProductDetailEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerAnalyticsProductDetailEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerAnalyticsProductDetailEnvelope> get serializer => _$BuyerAnalyticsProductDetailEnvelopeSerializer();
}

class _$BuyerAnalyticsProductDetailEnvelopeSerializer implements PrimitiveSerializer<BuyerAnalyticsProductDetailEnvelope> {
  @override
  final Iterable<Type> types = const [BuyerAnalyticsProductDetailEnvelope, _$BuyerAnalyticsProductDetailEnvelope];

  @override
  final String wireName = r'BuyerAnalyticsProductDetailEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerAnalyticsProductDetailEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuyerAnalyticsProductDetail),
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
    BuyerAnalyticsProductDetailEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerAnalyticsProductDetailEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerAnalyticsProductDetail),
          ) as BuyerAnalyticsProductDetail;
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
  BuyerAnalyticsProductDetailEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerAnalyticsProductDetailEnvelopeBuilder();
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


