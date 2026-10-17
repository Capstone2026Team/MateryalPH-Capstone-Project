//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_dashboard_orders_kpis.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_orders_mix.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_orders_forecast.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_orders_pipeline_inner.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_orders_unusual_days.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_orders_funnel_inner.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_orders_incoming_inner.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_series_point.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_orders_products.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_orders.g.dart';

/// Store-wide order measures (orders.confirm). Peso fields are null unless the caller holds finance.view (Owner).
///
/// Properties:
/// * [kpis]
/// * [series]
/// * [forecast]
/// * [pipeline]
/// * [incoming]
/// * [funnel]
/// * [mix]
/// * [products]
/// * [unusualDays]
@BuiltValue()
abstract class VendorDashboardOrders implements Built<VendorDashboardOrders, VendorDashboardOrdersBuilder> {
  @BuiltValueField(wireName: r'kpis')
  VendorDashboardOrdersKpis get kpis;

  @BuiltValueField(wireName: r'series')
  BuiltList<VendorDashboardSeriesPoint> get series;

  @BuiltValueField(wireName: r'forecast')
  VendorDashboardOrdersForecast get forecast;

  @BuiltValueField(wireName: r'pipeline')
  BuiltList<VendorDashboardOrdersPipelineInner> get pipeline;

  @BuiltValueField(wireName: r'incoming')
  BuiltList<VendorDashboardOrdersIncomingInner> get incoming;

  @BuiltValueField(wireName: r'funnel')
  BuiltList<VendorDashboardOrdersFunnelInner> get funnel;

  @BuiltValueField(wireName: r'mix')
  VendorDashboardOrdersMix get mix;

  @BuiltValueField(wireName: r'products')
  VendorDashboardOrdersProducts get products;

  @BuiltValueField(wireName: r'unusual_days')
  VendorDashboardOrdersUnusualDays get unusualDays;

  VendorDashboardOrders._();

  factory VendorDashboardOrders([void updates(VendorDashboardOrdersBuilder b)]) = _$VendorDashboardOrders;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardOrdersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardOrders> get serializer => _$VendorDashboardOrdersSerializer();
}

class _$VendorDashboardOrdersSerializer implements PrimitiveSerializer<VendorDashboardOrders> {
  @override
  final Iterable<Type> types = const [VendorDashboardOrders, _$VendorDashboardOrders];

  @override
  final String wireName = r'VendorDashboardOrders';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardOrders object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kpis';
    yield serializers.serialize(
      object.kpis,
      specifiedType: const FullType(VendorDashboardOrdersKpis),
    );
    yield r'series';
    yield serializers.serialize(
      object.series,
      specifiedType: const FullType(BuiltList, [FullType(VendorDashboardSeriesPoint)]),
    );
    yield r'forecast';
    yield serializers.serialize(
      object.forecast,
      specifiedType: const FullType(VendorDashboardOrdersForecast),
    );
    yield r'pipeline';
    yield serializers.serialize(
      object.pipeline,
      specifiedType: const FullType(BuiltList, [FullType(VendorDashboardOrdersPipelineInner)]),
    );
    yield r'incoming';
    yield serializers.serialize(
      object.incoming,
      specifiedType: const FullType(BuiltList, [FullType(VendorDashboardOrdersIncomingInner)]),
    );
    yield r'funnel';
    yield serializers.serialize(
      object.funnel,
      specifiedType: const FullType(BuiltList, [FullType(VendorDashboardOrdersFunnelInner)]),
    );
    yield r'mix';
    yield serializers.serialize(
      object.mix,
      specifiedType: const FullType(VendorDashboardOrdersMix),
    );
    yield r'products';
    yield serializers.serialize(
      object.products,
      specifiedType: const FullType(VendorDashboardOrdersProducts),
    );
    yield r'unusual_days';
    yield serializers.serialize(
      object.unusualDays,
      specifiedType: const FullType(VendorDashboardOrdersUnusualDays),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardOrders object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardOrdersBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kpis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDashboardOrdersKpis),
          ) as VendorDashboardOrdersKpis;
          result.kpis.replace(valueDes);
          break;
        case r'series':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorDashboardSeriesPoint)]),
          ) as BuiltList<VendorDashboardSeriesPoint>;
          result.series.replace(valueDes);
          break;
        case r'forecast':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDashboardOrdersForecast),
          ) as VendorDashboardOrdersForecast;
          result.forecast.replace(valueDes);
          break;
        case r'pipeline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorDashboardOrdersPipelineInner)]),
          ) as BuiltList<VendorDashboardOrdersPipelineInner>;
          result.pipeline.replace(valueDes);
          break;
        case r'incoming':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorDashboardOrdersIncomingInner)]),
          ) as BuiltList<VendorDashboardOrdersIncomingInner>;
          result.incoming.replace(valueDes);
          break;
        case r'funnel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorDashboardOrdersFunnelInner)]),
          ) as BuiltList<VendorDashboardOrdersFunnelInner>;
          result.funnel.replace(valueDes);
          break;
        case r'mix':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDashboardOrdersMix),
          ) as VendorDashboardOrdersMix;
          result.mix.replace(valueDes);
          break;
        case r'products':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDashboardOrdersProducts),
          ) as VendorDashboardOrdersProducts;
          result.products.replace(valueDes);
          break;
        case r'unusual_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDashboardOrdersUnusualDays),
          ) as VendorDashboardOrdersUnusualDays;
          result.unusualDays.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardOrders deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardOrdersBuilder();
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


