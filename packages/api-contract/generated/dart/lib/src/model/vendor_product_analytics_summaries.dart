//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/product_analytics_period.dart';
import 'package:materyalph_api_client/src/model/vendor_product_analytics_summaries_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_product_analytics_summaries.g.dart';

/// Compact measures for the My Products list; listings outside the caller’s store are left out.
///
/// Properties:
/// * [period]
/// * [items]
@BuiltValue()
abstract class VendorProductAnalyticsSummaries implements Built<VendorProductAnalyticsSummaries, VendorProductAnalyticsSummariesBuilder> {
  @BuiltValueField(wireName: r'period')
  ProductAnalyticsPeriod get period;

  @BuiltValueField(wireName: r'items')
  BuiltList<VendorProductAnalyticsSummariesItemsInner> get items;

  VendorProductAnalyticsSummaries._();

  factory VendorProductAnalyticsSummaries([void updates(VendorProductAnalyticsSummariesBuilder b)]) = _$VendorProductAnalyticsSummaries;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorProductAnalyticsSummariesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorProductAnalyticsSummaries> get serializer => _$VendorProductAnalyticsSummariesSerializer();
}

class _$VendorProductAnalyticsSummariesSerializer implements PrimitiveSerializer<VendorProductAnalyticsSummaries> {
  @override
  final Iterable<Type> types = const [VendorProductAnalyticsSummaries, _$VendorProductAnalyticsSummaries];

  @override
  final String wireName = r'VendorProductAnalyticsSummaries';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorProductAnalyticsSummaries object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'period';
    yield serializers.serialize(
      object.period,
      specifiedType: const FullType(ProductAnalyticsPeriod),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(VendorProductAnalyticsSummariesItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorProductAnalyticsSummaries object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorProductAnalyticsSummariesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProductAnalyticsPeriod),
          ) as ProductAnalyticsPeriod;
          result.period.replace(valueDes);
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorProductAnalyticsSummariesItemsInner)]),
          ) as BuiltList<VendorProductAnalyticsSummariesItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorProductAnalyticsSummaries deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorProductAnalyticsSummariesBuilder();
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


