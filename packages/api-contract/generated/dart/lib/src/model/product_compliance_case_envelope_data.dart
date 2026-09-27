//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/regulated_material_rule.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_compliance_case_envelope_data.g.dart';

/// ProductComplianceCaseEnvelopeData
///
/// Properties:
/// * [submission]
/// * [listing]
/// * [rule]
/// * [evidence]
/// * [extractions]
/// * [referenceMatch]
/// * [previousSubmissions]
/// * [reviews]
/// * [officialReferences]
@BuiltValue()
abstract class ProductComplianceCaseEnvelopeData implements Built<ProductComplianceCaseEnvelopeData, ProductComplianceCaseEnvelopeDataBuilder> {
  @BuiltValueField(wireName: r'submission')
  BuiltMap<String, JsonObject?> get submission;

  @BuiltValueField(wireName: r'listing')
  BuiltMap<String, JsonObject?>? get listing;

  @BuiltValueField(wireName: r'rule')
  RegulatedMaterialRule? get rule;

  @BuiltValueField(wireName: r'evidence')
  BuiltList<BuiltMap<String, JsonObject?>> get evidence;

  @BuiltValueField(wireName: r'extractions')
  BuiltList<BuiltMap<String, JsonObject?>> get extractions;

  @BuiltValueField(wireName: r'reference_match')
  BuiltMap<String, JsonObject?>? get referenceMatch;

  @BuiltValueField(wireName: r'previous_submissions')
  BuiltList<BuiltMap<String, JsonObject?>> get previousSubmissions;

  @BuiltValueField(wireName: r'reviews')
  BuiltList<BuiltMap<String, JsonObject?>> get reviews;

  @BuiltValueField(wireName: r'official_references')
  BuiltList<BuiltMap<String, JsonObject?>> get officialReferences;

  ProductComplianceCaseEnvelopeData._();

  factory ProductComplianceCaseEnvelopeData([void updates(ProductComplianceCaseEnvelopeDataBuilder b)]) = _$ProductComplianceCaseEnvelopeData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductComplianceCaseEnvelopeDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductComplianceCaseEnvelopeData> get serializer => _$ProductComplianceCaseEnvelopeDataSerializer();
}

class _$ProductComplianceCaseEnvelopeDataSerializer implements PrimitiveSerializer<ProductComplianceCaseEnvelopeData> {
  @override
  final Iterable<Type> types = const [ProductComplianceCaseEnvelopeData, _$ProductComplianceCaseEnvelopeData];

  @override
  final String wireName = r'ProductComplianceCaseEnvelopeData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductComplianceCaseEnvelopeData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'submission';
    yield serializers.serialize(
      object.submission,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'listing';
    yield object.listing == null ? null : serializers.serialize(
      object.listing,
      specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'rule';
    yield object.rule == null ? null : serializers.serialize(
      object.rule,
      specifiedType: const FullType.nullable(RegulatedMaterialRule),
    );
    yield r'evidence';
    yield serializers.serialize(
      object.evidence,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
    yield r'extractions';
    yield serializers.serialize(
      object.extractions,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
    yield r'reference_match';
    yield object.referenceMatch == null ? null : serializers.serialize(
      object.referenceMatch,
      specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'previous_submissions';
    yield serializers.serialize(
      object.previousSubmissions,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
    yield r'reviews';
    yield serializers.serialize(
      object.reviews,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
    yield r'official_references';
    yield serializers.serialize(
      object.officialReferences,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProductComplianceCaseEnvelopeData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductComplianceCaseEnvelopeDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'submission':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.submission.replace(valueDes);
          break;
        case r'listing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.listing.replace(valueDes);
          break;
        case r'rule':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RegulatedMaterialRule),
          ) as RegulatedMaterialRule?;
          if (valueDes == null) continue;
          result.rule.replace(valueDes);
          break;
        case r'evidence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.evidence.replace(valueDes);
          break;
        case r'extractions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.extractions.replace(valueDes);
          break;
        case r'reference_match':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.referenceMatch.replace(valueDes);
          break;
        case r'previous_submissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.previousSubmissions.replace(valueDes);
          break;
        case r'reviews':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.reviews.replace(valueDes);
          break;
        case r'official_references':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.officialReferences.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProductComplianceCaseEnvelopeData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductComplianceCaseEnvelopeDataBuilder();
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


