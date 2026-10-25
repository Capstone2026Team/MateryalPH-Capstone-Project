//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/analytics_category_ref.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_analytics_category_summary.g.dart';

/// BuyerAnalyticsCategorySummary
///
/// Properties:
/// * [category]
/// * [productCount]
/// * [variantCount]
@BuiltValue()
abstract class BuyerAnalyticsCategorySummary implements Built<BuyerAnalyticsCategorySummary, BuyerAnalyticsCategorySummaryBuilder> {
  @BuiltValueField(wireName: r'category')
  AnalyticsCategoryRef get category;

  @BuiltValueField(wireName: r'product_count')
  int get productCount;

  @BuiltValueField(wireName: r'variant_count')
  int get variantCount;

  BuyerAnalyticsCategorySummary._();

  factory BuyerAnalyticsCategorySummary([void updates(BuyerAnalyticsCategorySummaryBuilder b)]) = _$BuyerAnalyticsCategorySummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerAnalyticsCategorySummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerAnalyticsCategorySummary> get serializer => _$BuyerAnalyticsCategorySummarySerializer();
}

class _$BuyerAnalyticsCategorySummarySerializer implements PrimitiveSerializer<BuyerAnalyticsCategorySummary> {
  @override
  final Iterable<Type> types = const [BuyerAnalyticsCategorySummary, _$BuyerAnalyticsCategorySummary];

  @override
  final String wireName = r'BuyerAnalyticsCategorySummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerAnalyticsCategorySummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(AnalyticsCategoryRef),
    );
    yield r'product_count';
    yield serializers.serialize(
      object.productCount,
      specifiedType: const FullType(int),
    );
    yield r'variant_count';
    yield serializers.serialize(
      object.variantCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerAnalyticsCategorySummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerAnalyticsCategorySummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsCategoryRef),
          ) as AnalyticsCategoryRef;
          result.category.replace(valueDes);
          break;
        case r'product_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.productCount = valueDes;
          break;
        case r'variant_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.variantCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerAnalyticsCategorySummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerAnalyticsCategorySummaryBuilder();
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


