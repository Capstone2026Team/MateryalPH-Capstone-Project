//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/product_compliance_queue_item.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_compliance_queue_envelope.g.dart';

/// ProductComplianceQueueEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class ProductComplianceQueueEnvelope implements Built<ProductComplianceQueueEnvelope, ProductComplianceQueueEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<ProductComplianceQueueItem> get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  ProductComplianceQueueEnvelope._();

  factory ProductComplianceQueueEnvelope([void updates(ProductComplianceQueueEnvelopeBuilder b)]) = _$ProductComplianceQueueEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductComplianceQueueEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductComplianceQueueEnvelope> get serializer => _$ProductComplianceQueueEnvelopeSerializer();
}

class _$ProductComplianceQueueEnvelopeSerializer implements PrimitiveSerializer<ProductComplianceQueueEnvelope> {
  @override
  final Iterable<Type> types = const [ProductComplianceQueueEnvelope, _$ProductComplianceQueueEnvelope];

  @override
  final String wireName = r'ProductComplianceQueueEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductComplianceQueueEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(ProductComplianceQueueItem)]),
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
    ProductComplianceQueueEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductComplianceQueueEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProductComplianceQueueItem)]),
          ) as BuiltList<ProductComplianceQueueItem>;
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
  ProductComplianceQueueEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductComplianceQueueEnvelopeBuilder();
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


