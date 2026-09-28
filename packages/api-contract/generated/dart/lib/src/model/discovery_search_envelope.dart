//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/supplier_result.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/discovery_search_meta.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'discovery_search_envelope.g.dart';

/// DiscoverySearchEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class DiscoverySearchEnvelope implements Built<DiscoverySearchEnvelope, DiscoverySearchEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<SupplierResult> get data;

  @BuiltValueField(wireName: r'meta')
  DiscoverySearchMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  DiscoverySearchEnvelope._();

  factory DiscoverySearchEnvelope([void updates(DiscoverySearchEnvelopeBuilder b)]) = _$DiscoverySearchEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DiscoverySearchEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DiscoverySearchEnvelope> get serializer => _$DiscoverySearchEnvelopeSerializer();
}

class _$DiscoverySearchEnvelopeSerializer implements PrimitiveSerializer<DiscoverySearchEnvelope> {
  @override
  final Iterable<Type> types = const [DiscoverySearchEnvelope, _$DiscoverySearchEnvelope];

  @override
  final String wireName = r'DiscoverySearchEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DiscoverySearchEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(SupplierResult)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(DiscoverySearchMeta),
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
    DiscoverySearchEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DiscoverySearchEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SupplierResult)]),
          ) as BuiltList<SupplierResult>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DiscoverySearchMeta),
          ) as DiscoverySearchMeta;
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
  DiscoverySearchEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DiscoverySearchEnvelopeBuilder();
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


