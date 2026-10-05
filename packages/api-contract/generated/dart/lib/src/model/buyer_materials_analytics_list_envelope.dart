//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/buyer_materials_analytics_list.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_materials_analytics_list_envelope.g.dart';

/// BuyerMaterialsAnalyticsListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class BuyerMaterialsAnalyticsListEnvelope implements Built<BuyerMaterialsAnalyticsListEnvelope, BuyerMaterialsAnalyticsListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuyerMaterialsAnalyticsList get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  BuyerMaterialsAnalyticsListEnvelope._();

  factory BuyerMaterialsAnalyticsListEnvelope([void updates(BuyerMaterialsAnalyticsListEnvelopeBuilder b)]) = _$BuyerMaterialsAnalyticsListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerMaterialsAnalyticsListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerMaterialsAnalyticsListEnvelope> get serializer => _$BuyerMaterialsAnalyticsListEnvelopeSerializer();
}

class _$BuyerMaterialsAnalyticsListEnvelopeSerializer implements PrimitiveSerializer<BuyerMaterialsAnalyticsListEnvelope> {
  @override
  final Iterable<Type> types = const [BuyerMaterialsAnalyticsListEnvelope, _$BuyerMaterialsAnalyticsListEnvelope];

  @override
  final String wireName = r'BuyerMaterialsAnalyticsListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerMaterialsAnalyticsListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuyerMaterialsAnalyticsList),
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
    BuyerMaterialsAnalyticsListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerMaterialsAnalyticsListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerMaterialsAnalyticsList),
          ) as BuyerMaterialsAnalyticsList;
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
  BuyerMaterialsAnalyticsListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerMaterialsAnalyticsListEnvelopeBuilder();
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


