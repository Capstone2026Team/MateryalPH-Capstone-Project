//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/catalog_listing_summary.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/catalog_listing_list_meta.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_listing_summary_list_envelope.g.dart';

/// CatalogListingSummaryListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class CatalogListingSummaryListEnvelope implements Built<CatalogListingSummaryListEnvelope, CatalogListingSummaryListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<CatalogListingSummary> get data;

  @BuiltValueField(wireName: r'meta')
  CatalogListingListMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  CatalogListingSummaryListEnvelope._();

  factory CatalogListingSummaryListEnvelope([void updates(CatalogListingSummaryListEnvelopeBuilder b)]) = _$CatalogListingSummaryListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogListingSummaryListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogListingSummaryListEnvelope> get serializer => _$CatalogListingSummaryListEnvelopeSerializer();
}

class _$CatalogListingSummaryListEnvelopeSerializer implements PrimitiveSerializer<CatalogListingSummaryListEnvelope> {
  @override
  final Iterable<Type> types = const [CatalogListingSummaryListEnvelope, _$CatalogListingSummaryListEnvelope];

  @override
  final String wireName = r'CatalogListingSummaryListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogListingSummaryListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(CatalogListingSummary)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(CatalogListingListMeta),
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
    CatalogListingSummaryListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogListingSummaryListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CatalogListingSummary)]),
          ) as BuiltList<CatalogListingSummary>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CatalogListingListMeta),
          ) as CatalogListingListMeta;
          result.meta = valueDes.toBuilder();
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
  CatalogListingSummaryListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogListingSummaryListEnvelopeBuilder();
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


