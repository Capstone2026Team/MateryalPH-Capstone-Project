//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/product_analytics_tracking.dart';
import 'package:materyalph_api_client/src/model/product_analytics_period.dart';
import 'package:materyalph_api_client/src/model/vendor_product_analytics_kpis.dart';
import 'package:materyalph_api_client/src/model/product_analytics_row.dart';
import 'package:materyalph_api_client/src/model/product_analytics_suggestion.dart';
import 'package:materyalph_api_client/src/model/product_analytics_segments.dart';
import 'package:materyalph_api_client/src/model/vendor_product_analytics_products.dart';
import 'package:materyalph_api_client/src/model/product_analytics_series_point.dart';
import 'package:materyalph_api_client/src/model/vendor_product_analytics_categories_inner.dart';
import 'package:materyalph_api_client/src/model/vendor_product_analytics_forecast.dart';
import 'package:materyalph_api_client/src/model/vendor_product_analytics_access.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_product_analytics_basket_rules.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_product_analytics.g.dart';

/// VendorProductAnalytics
///
/// Properties:
/// * [generatedAt]
/// * [period]
/// * [access]
/// * [definitions]
/// * [tracking]
/// * [kpis]
/// * [series]
/// * [forecast]
/// * [topSelling]
/// * [topPerforming]
/// * [mostViewed]
/// * [categories]
/// * [segments]
/// * [basketRules]
/// * [suggestions]
/// * [products]
@BuiltValue()
abstract class VendorProductAnalytics implements Built<VendorProductAnalytics, VendorProductAnalyticsBuilder> {
  @BuiltValueField(wireName: r'generated_at')
  DateTime get generatedAt;

  @BuiltValueField(wireName: r'period')
  ProductAnalyticsPeriod get period;

  @BuiltValueField(wireName: r'access')
  VendorProductAnalyticsAccess get access;

  @BuiltValueField(wireName: r'definitions')
  BuiltMap<String, String> get definitions;

  @BuiltValueField(wireName: r'tracking')
  ProductAnalyticsTracking get tracking;

  @BuiltValueField(wireName: r'kpis')
  VendorProductAnalyticsKpis get kpis;

  @BuiltValueField(wireName: r'series')
  BuiltList<ProductAnalyticsSeriesPoint> get series;

  @BuiltValueField(wireName: r'forecast')
  VendorProductAnalyticsForecast get forecast;

  @BuiltValueField(wireName: r'top_selling')
  BuiltList<ProductAnalyticsRow> get topSelling;

  @BuiltValueField(wireName: r'top_performing')
  BuiltList<ProductAnalyticsRow> get topPerforming;

  @BuiltValueField(wireName: r'most_viewed')
  BuiltList<ProductAnalyticsRow> get mostViewed;

  @BuiltValueField(wireName: r'categories')
  BuiltList<VendorProductAnalyticsCategoriesInner> get categories;

  @BuiltValueField(wireName: r'segments')
  ProductAnalyticsSegments get segments;

  @BuiltValueField(wireName: r'basket_rules')
  VendorProductAnalyticsBasketRules get basketRules;

  @BuiltValueField(wireName: r'suggestions')
  BuiltList<ProductAnalyticsSuggestion> get suggestions;

  @BuiltValueField(wireName: r'products')
  VendorProductAnalyticsProducts get products;

  VendorProductAnalytics._();

  factory VendorProductAnalytics([void updates(VendorProductAnalyticsBuilder b)]) = _$VendorProductAnalytics;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorProductAnalyticsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorProductAnalytics> get serializer => _$VendorProductAnalyticsSerializer();
}

class _$VendorProductAnalyticsSerializer implements PrimitiveSerializer<VendorProductAnalytics> {
  @override
  final Iterable<Type> types = const [VendorProductAnalytics, _$VendorProductAnalytics];

  @override
  final String wireName = r'VendorProductAnalytics';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorProductAnalytics object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'generated_at';
    yield serializers.serialize(
      object.generatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'period';
    yield serializers.serialize(
      object.period,
      specifiedType: const FullType(ProductAnalyticsPeriod),
    );
    yield r'access';
    yield serializers.serialize(
      object.access,
      specifiedType: const FullType(VendorProductAnalyticsAccess),
    );
    yield r'definitions';
    yield serializers.serialize(
      object.definitions,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
    yield r'tracking';
    yield serializers.serialize(
      object.tracking,
      specifiedType: const FullType(ProductAnalyticsTracking),
    );
    yield r'kpis';
    yield serializers.serialize(
      object.kpis,
      specifiedType: const FullType(VendorProductAnalyticsKpis),
    );
    yield r'series';
    yield serializers.serialize(
      object.series,
      specifiedType: const FullType(BuiltList, [FullType(ProductAnalyticsSeriesPoint)]),
    );
    yield r'forecast';
    yield serializers.serialize(
      object.forecast,
      specifiedType: const FullType(VendorProductAnalyticsForecast),
    );
    yield r'top_selling';
    yield serializers.serialize(
      object.topSelling,
      specifiedType: const FullType(BuiltList, [FullType(ProductAnalyticsRow)]),
    );
    yield r'top_performing';
    yield serializers.serialize(
      object.topPerforming,
      specifiedType: const FullType(BuiltList, [FullType(ProductAnalyticsRow)]),
    );
    yield r'most_viewed';
    yield serializers.serialize(
      object.mostViewed,
      specifiedType: const FullType(BuiltList, [FullType(ProductAnalyticsRow)]),
    );
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [FullType(VendorProductAnalyticsCategoriesInner)]),
    );
    yield r'segments';
    yield serializers.serialize(
      object.segments,
      specifiedType: const FullType(ProductAnalyticsSegments),
    );
    yield r'basket_rules';
    yield serializers.serialize(
      object.basketRules,
      specifiedType: const FullType(VendorProductAnalyticsBasketRules),
    );
    yield r'suggestions';
    yield serializers.serialize(
      object.suggestions,
      specifiedType: const FullType(BuiltList, [FullType(ProductAnalyticsSuggestion)]),
    );
    yield r'products';
    yield serializers.serialize(
      object.products,
      specifiedType: const FullType(VendorProductAnalyticsProducts),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorProductAnalytics object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorProductAnalyticsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'generated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.generatedAt = valueDes;
          break;
        case r'period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProductAnalyticsPeriod),
          ) as ProductAnalyticsPeriod;
          result.period.replace(valueDes);
          break;
        case r'access':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorProductAnalyticsAccess),
          ) as VendorProductAnalyticsAccess;
          result.access.replace(valueDes);
          break;
        case r'definitions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.definitions.replace(valueDes);
          break;
        case r'tracking':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProductAnalyticsTracking),
          ) as ProductAnalyticsTracking;
          result.tracking.replace(valueDes);
          break;
        case r'kpis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorProductAnalyticsKpis),
          ) as VendorProductAnalyticsKpis;
          result.kpis.replace(valueDes);
          break;
        case r'series':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProductAnalyticsSeriesPoint)]),
          ) as BuiltList<ProductAnalyticsSeriesPoint>;
          result.series.replace(valueDes);
          break;
        case r'forecast':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorProductAnalyticsForecast),
          ) as VendorProductAnalyticsForecast;
          result.forecast.replace(valueDes);
          break;
        case r'top_selling':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProductAnalyticsRow)]),
          ) as BuiltList<ProductAnalyticsRow>;
          result.topSelling.replace(valueDes);
          break;
        case r'top_performing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProductAnalyticsRow)]),
          ) as BuiltList<ProductAnalyticsRow>;
          result.topPerforming.replace(valueDes);
          break;
        case r'most_viewed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProductAnalyticsRow)]),
          ) as BuiltList<ProductAnalyticsRow>;
          result.mostViewed.replace(valueDes);
          break;
        case r'categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorProductAnalyticsCategoriesInner)]),
          ) as BuiltList<VendorProductAnalyticsCategoriesInner>;
          result.categories.replace(valueDes);
          break;
        case r'segments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProductAnalyticsSegments),
          ) as ProductAnalyticsSegments;
          result.segments.replace(valueDes);
          break;
        case r'basket_rules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorProductAnalyticsBasketRules),
          ) as VendorProductAnalyticsBasketRules;
          result.basketRules.replace(valueDes);
          break;
        case r'suggestions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProductAnalyticsSuggestion)]),
          ) as BuiltList<ProductAnalyticsSuggestion>;
          result.suggestions.replace(valueDes);
          break;
        case r'products':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorProductAnalyticsProducts),
          ) as VendorProductAnalyticsProducts;
          result.products.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorProductAnalytics deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorProductAnalyticsBuilder();
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


