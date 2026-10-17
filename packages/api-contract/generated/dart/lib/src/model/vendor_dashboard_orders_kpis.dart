//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/dashboard_response_time.dart';
import 'package:materyalph_api_client/src/model/dashboard_rate.dart';
import 'package:materyalph_api_client/src/model/dashboard_delta.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_orders_kpis_average_order_value_centavos.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_orders_kpis.g.dart';

/// VendorDashboardOrdersKpis
///
/// Properties:
/// * [orderVolume]
/// * [grossSalesCentavos]
/// * [netSalesCentavos]
/// * [averageOrderValueCentavos]
/// * [fulfillmentRate]
/// * [cancellationRate]
/// * [disputeRate]
/// * [responseTime]
@BuiltValue()
abstract class VendorDashboardOrdersKpis implements Built<VendorDashboardOrdersKpis, VendorDashboardOrdersKpisBuilder> {
  @BuiltValueField(wireName: r'order_volume')
  DashboardDelta get orderVolume;

  @BuiltValueField(wireName: r'gross_sales_centavos')
  DashboardDelta? get grossSalesCentavos;

  @BuiltValueField(wireName: r'net_sales_centavos')
  DashboardDelta? get netSalesCentavos;

  @BuiltValueField(wireName: r'average_order_value_centavos')
  VendorDashboardOrdersKpisAverageOrderValueCentavos? get averageOrderValueCentavos;

  @BuiltValueField(wireName: r'fulfillment_rate')
  DashboardRate get fulfillmentRate;

  @BuiltValueField(wireName: r'cancellation_rate')
  DashboardRate get cancellationRate;

  @BuiltValueField(wireName: r'dispute_rate')
  DashboardRate get disputeRate;

  @BuiltValueField(wireName: r'response_time')
  DashboardResponseTime get responseTime;

  VendorDashboardOrdersKpis._();

  factory VendorDashboardOrdersKpis([void updates(VendorDashboardOrdersKpisBuilder b)]) = _$VendorDashboardOrdersKpis;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardOrdersKpisBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardOrdersKpis> get serializer => _$VendorDashboardOrdersKpisSerializer();
}

class _$VendorDashboardOrdersKpisSerializer implements PrimitiveSerializer<VendorDashboardOrdersKpis> {
  @override
  final Iterable<Type> types = const [VendorDashboardOrdersKpis, _$VendorDashboardOrdersKpis];

  @override
  final String wireName = r'VendorDashboardOrdersKpis';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardOrdersKpis object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order_volume';
    yield serializers.serialize(
      object.orderVolume,
      specifiedType: const FullType(DashboardDelta),
    );
    if (object.grossSalesCentavos != null) {
      yield r'gross_sales_centavos';
      yield serializers.serialize(
        object.grossSalesCentavos,
        specifiedType: const FullType.nullable(DashboardDelta),
      );
    }
    if (object.netSalesCentavos != null) {
      yield r'net_sales_centavos';
      yield serializers.serialize(
        object.netSalesCentavos,
        specifiedType: const FullType.nullable(DashboardDelta),
      );
    }
    if (object.averageOrderValueCentavos != null) {
      yield r'average_order_value_centavos';
      yield serializers.serialize(
        object.averageOrderValueCentavos,
        specifiedType: const FullType.nullable(VendorDashboardOrdersKpisAverageOrderValueCentavos),
      );
    }
    yield r'fulfillment_rate';
    yield serializers.serialize(
      object.fulfillmentRate,
      specifiedType: const FullType(DashboardRate),
    );
    yield r'cancellation_rate';
    yield serializers.serialize(
      object.cancellationRate,
      specifiedType: const FullType(DashboardRate),
    );
    yield r'dispute_rate';
    yield serializers.serialize(
      object.disputeRate,
      specifiedType: const FullType(DashboardRate),
    );
    yield r'response_time';
    yield serializers.serialize(
      object.responseTime,
      specifiedType: const FullType(DashboardResponseTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardOrdersKpis object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardOrdersKpisBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'order_volume':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardDelta),
          ) as DashboardDelta;
          result.orderVolume.replace(valueDes);
          break;
        case r'gross_sales_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DashboardDelta),
          ) as DashboardDelta?;
          if (valueDes == null) continue;
          result.grossSalesCentavos.replace(valueDes);
          break;
        case r'net_sales_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DashboardDelta),
          ) as DashboardDelta?;
          if (valueDes == null) continue;
          result.netSalesCentavos.replace(valueDes);
          break;
        case r'average_order_value_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorDashboardOrdersKpisAverageOrderValueCentavos),
          ) as VendorDashboardOrdersKpisAverageOrderValueCentavos?;
          if (valueDes == null) continue;
          result.averageOrderValueCentavos.replace(valueDes);
          break;
        case r'fulfillment_rate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardRate),
          ) as DashboardRate;
          result.fulfillmentRate.replace(valueDes);
          break;
        case r'cancellation_rate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardRate),
          ) as DashboardRate;
          result.cancellationRate.replace(valueDes);
          break;
        case r'dispute_rate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardRate),
          ) as DashboardRate;
          result.disputeRate.replace(valueDes);
          break;
        case r'response_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardResponseTime),
          ) as DashboardResponseTime;
          result.responseTime.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardOrdersKpis deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardOrdersKpisBuilder();
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


