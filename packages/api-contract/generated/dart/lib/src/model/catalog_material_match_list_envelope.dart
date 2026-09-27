//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/catalog_material_match.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_material_match_list_envelope.g.dart';

/// CatalogMaterialMatchListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class CatalogMaterialMatchListEnvelope implements Built<CatalogMaterialMatchListEnvelope, CatalogMaterialMatchListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<CatalogMaterialMatch> get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  CatalogMaterialMatchListEnvelope._();

  factory CatalogMaterialMatchListEnvelope([void updates(CatalogMaterialMatchListEnvelopeBuilder b)]) = _$CatalogMaterialMatchListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogMaterialMatchListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogMaterialMatchListEnvelope> get serializer => _$CatalogMaterialMatchListEnvelopeSerializer();
}

class _$CatalogMaterialMatchListEnvelopeSerializer implements PrimitiveSerializer<CatalogMaterialMatchListEnvelope> {
  @override
  final Iterable<Type> types = const [CatalogMaterialMatchListEnvelope, _$CatalogMaterialMatchListEnvelope];

  @override
  final String wireName = r'CatalogMaterialMatchListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogMaterialMatchListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(CatalogMaterialMatch)]),
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
    CatalogMaterialMatchListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogMaterialMatchListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CatalogMaterialMatch)]),
          ) as BuiltList<CatalogMaterialMatch>;
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
  CatalogMaterialMatchListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogMaterialMatchListEnvelopeBuilder();
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


