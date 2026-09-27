//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/public_store_list_envelope_meta.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:materyalph_api_client/src/model/public_store_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_store_list_envelope.g.dart';

/// PublicStoreListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class PublicStoreListEnvelope implements Built<PublicStoreListEnvelope, PublicStoreListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<PublicStoreSummary> get data;

  @BuiltValueField(wireName: r'meta')
  PublicStoreListEnvelopeMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  PublicStoreListEnvelope._();

  factory PublicStoreListEnvelope([void updates(PublicStoreListEnvelopeBuilder b)]) = _$PublicStoreListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicStoreListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicStoreListEnvelope> get serializer => _$PublicStoreListEnvelopeSerializer();
}

class _$PublicStoreListEnvelopeSerializer implements PrimitiveSerializer<PublicStoreListEnvelope> {
  @override
  final Iterable<Type> types = const [PublicStoreListEnvelope, _$PublicStoreListEnvelope];

  @override
  final String wireName = r'PublicStoreListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicStoreListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(PublicStoreSummary)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(PublicStoreListEnvelopeMeta),
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
    PublicStoreListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicStoreListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PublicStoreSummary)]),
          ) as BuiltList<PublicStoreSummary>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicStoreListEnvelopeMeta),
          ) as PublicStoreListEnvelopeMeta;
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
  PublicStoreListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicStoreListEnvelopeBuilder();
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


