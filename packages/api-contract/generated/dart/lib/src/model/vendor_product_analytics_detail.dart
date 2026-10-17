//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_product_analytics_forecast.dart';
import 'package:materyalph_api_client/src/model/vendor_product_analytics_access.dart';
import 'package:materyalph_api_client/src/model/product_analytics_tracking.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/product_analytics_period.dart';
import 'package:materyalph_api_client/src/model/vendor_product_analytics_basket_rules.dart';
import 'package:materyalph_api_client/src/model/vendor_product_analytics_detail_kpis.dart';
import 'package:materyalph_api_client/src/model/product_analytics_row.dart';
import 'package:materyalph_api_client/src/model/product_analytics_suggestion.dart';
import 'package:materyalph_api_client/src/model/vendor_product_analytics_detail_unusual_days.dart';
import 'package:materyalph_api_client/src/model/product_analytics_series_point.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_product_analytics_detail.g.dart';

/// VendorProductAnalyticsDetail
///
/// Properties:
/// * [generatedAt]
/// * [period]
/// * [access]
/// * [definitions]
/// * [tracking]
/// * [product]
/// * [kpis]
/// * [series]
/// * [forecast]
/// * [unusualDays]
/// * [basketRules]
/// * [suggestions]
@BuiltValue()
abstract class VendorProductAnalyticsDetail implements Built<VendorProductAnalyticsDetail, VendorProductAnalyticsDetailBuilder> {
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

  @BuiltValueField(wireName: r'product')
  ProductAnalyticsRow get product;

  @BuiltValueField(wireName: r'kpis')
  VendorProductAnalyticsDetailKpis get kpis;

  @BuiltValueField(wireName: r'series')
  BuiltList<ProductAnalyticsSeriesPoint> get series;

  @BuiltValueField(wireName: r'forecast')
  VendorProductAnalyticsForecast get forecast;

  @BuiltValueField(wireName: r'unusual_days')
  VendorProductAnalyticsDetailUnusualDays get unusualDays;

  @BuiltValueField(wireName: r'basket_rules')
  VendorProductAnalyticsBasketRules get basketRules;

  @BuiltValueField(wireName: r'suggestions')
  BuiltList<ProductAnalyticsSuggestion> get suggestions;

  VendorProductAnalyticsDetail._();

  factory VendorProductAnalyticsDetail([void updates(VendorProductAnalyticsDetailBuilder b)]) = _$VendorProductAnalyticsDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorProductAnalyticsDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorProductAnalyticsDetail> get serializer => _$VendorProductAnalyticsDetailSerializer();
}

class _$VendorProductAnalyticsDetailSerializer implements PrimitiveSerializer<VendorProductAnalyticsDetail> {
  @override
  final Iterable<Type> types = const [VendorProductAnalyticsDetail, _$VendorProductAnalyticsDetail];

  @override
  final String wireName = r'VendorProductAnalyticsDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorProductAnalyticsDetail object, {
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
    yield r'product';
    yield serializers.serialize(
      object.product,
      specifiedType: const FullType(ProductAnalyticsRow),
    );
    yield r'kpis';
    yield serializers.serialize(
      object.kpis,
      specifiedType: const FullType(VendorProductAnalyticsDetailKpis),
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
    yield r'unusual_days';
    yield serializers.serialize(
      object.unusualDays,
      specifiedType: const FullType(VendorProductAnalyticsDetailUnusualDays),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorProductAnalyticsDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorProductAnalyticsDetailBuilder result,
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
        case r'product':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProductAnalyticsRow),
          ) as ProductAnalyticsRow;
          result.product.replace(valueDes);
          break;
        case r'kpis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorProductAnalyticsDetailKpis),
          ) as VendorProductAnalyticsDetailKpis;
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
        case r'unusual_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorProductAnalyticsDetailUnusualDays),
          ) as VendorProductAnalyticsDetailUnusualDays;
          result.unusualDays.replace(valueDes);
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorProductAnalyticsDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorProductAnalyticsDetailBuilder();
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


