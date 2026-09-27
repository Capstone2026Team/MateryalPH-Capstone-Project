//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/product_compliance_case_envelope_data.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_compliance_case_envelope.g.dart';

/// ProductComplianceCaseEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class ProductComplianceCaseEnvelope implements Built<ProductComplianceCaseEnvelope, ProductComplianceCaseEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  ProductComplianceCaseEnvelopeData get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  ProductComplianceCaseEnvelope._();

  factory ProductComplianceCaseEnvelope([void updates(ProductComplianceCaseEnvelopeBuilder b)]) = _$ProductComplianceCaseEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductComplianceCaseEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductComplianceCaseEnvelope> get serializer => _$ProductComplianceCaseEnvelopeSerializer();
}

class _$ProductComplianceCaseEnvelopeSerializer implements PrimitiveSerializer<ProductComplianceCaseEnvelope> {
  @override
  final Iterable<Type> types = const [ProductComplianceCaseEnvelope, _$ProductComplianceCaseEnvelope];

  @override
  final String wireName = r'ProductComplianceCaseEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductComplianceCaseEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(ProductComplianceCaseEnvelopeData),
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
    ProductComplianceCaseEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductComplianceCaseEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProductComplianceCaseEnvelopeData),
          ) as ProductComplianceCaseEnvelopeData;
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
  ProductComplianceCaseEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductComplianceCaseEnvelopeBuilder();
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


