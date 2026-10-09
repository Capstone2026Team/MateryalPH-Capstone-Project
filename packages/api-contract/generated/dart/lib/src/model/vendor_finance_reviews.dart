//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_finance_reviews_open_reviews_inner.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_finance_reviews.g.dart';

/// Owner only. Statement approval and payment status, tax adjustments, evidence review state and open finance reviews; no reviewer notes or taxpayer identifiers.
///
/// Properties:
/// * [label]
/// * [statements]
/// * [taxAdjustments]
/// * [evidence]
/// * [openReviews]
@BuiltValue()
abstract class VendorFinanceReviews implements Built<VendorFinanceReviews, VendorFinanceReviewsBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'statements')
  BuiltList<BuiltMap<String, JsonObject?>> get statements;

  @BuiltValueField(wireName: r'tax_adjustments')
  BuiltList<BuiltMap<String, JsonObject?>> get taxAdjustments;

  @BuiltValueField(wireName: r'evidence')
  BuiltList<BuiltMap<String, JsonObject?>> get evidence;

  @BuiltValueField(wireName: r'open_reviews')
  BuiltList<VendorFinanceReviewsOpenReviewsInner> get openReviews;

  VendorFinanceReviews._();

  factory VendorFinanceReviews([void updates(VendorFinanceReviewsBuilder b)]) = _$VendorFinanceReviews;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorFinanceReviewsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorFinanceReviews> get serializer => _$VendorFinanceReviewsSerializer();
}

class _$VendorFinanceReviewsSerializer implements PrimitiveSerializer<VendorFinanceReviews> {
  @override
  final Iterable<Type> types = const [VendorFinanceReviews, _$VendorFinanceReviews];

  @override
  final String wireName = r'VendorFinanceReviews';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorFinanceReviews object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'statements';
    yield serializers.serialize(
      object.statements,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
    yield r'tax_adjustments';
    yield serializers.serialize(
      object.taxAdjustments,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
    yield r'evidence';
    yield serializers.serialize(
      object.evidence,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
    yield r'open_reviews';
    yield serializers.serialize(
      object.openReviews,
      specifiedType: const FullType(BuiltList, [FullType(VendorFinanceReviewsOpenReviewsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorFinanceReviews object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorFinanceReviewsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'statements':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.statements.replace(valueDes);
          break;
        case r'tax_adjustments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.taxAdjustments.replace(valueDes);
          break;
        case r'evidence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.evidence.replace(valueDes);
          break;
        case r'open_reviews':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorFinanceReviewsOpenReviewsInner)]),
          ) as BuiltList<VendorFinanceReviewsOpenReviewsInner>;
          result.openReviews.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorFinanceReviews deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorFinanceReviewsBuilder();
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


