//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_series_point.g.dart';

/// VendorDashboardSeriesPoint
///
/// Properties:
/// * [date]
/// * [orders]
/// * [orderRequests]
/// * [ordersAverage]
/// * [grossSalesCentavos]
/// * [netSalesCentavos]
/// * [salesAverageCentavos]
@BuiltValue()
abstract class VendorDashboardSeriesPoint implements Built<VendorDashboardSeriesPoint, VendorDashboardSeriesPointBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'order_requests')
  int get orderRequests;

  @BuiltValueField(wireName: r'orders_average')
  num? get ordersAverage;

  @BuiltValueField(wireName: r'gross_sales_centavos')
  int? get grossSalesCentavos;

  @BuiltValueField(wireName: r'net_sales_centavos')
  int? get netSalesCentavos;

  @BuiltValueField(wireName: r'sales_average_centavos')
  int? get salesAverageCentavos;

  VendorDashboardSeriesPoint._();

  factory VendorDashboardSeriesPoint([void updates(VendorDashboardSeriesPointBuilder b)]) = _$VendorDashboardSeriesPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardSeriesPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardSeriesPoint> get serializer => _$VendorDashboardSeriesPointSerializer();
}

class _$VendorDashboardSeriesPointSerializer implements PrimitiveSerializer<VendorDashboardSeriesPoint> {
  @override
  final Iterable<Type> types = const [VendorDashboardSeriesPoint, _$VendorDashboardSeriesPoint];

  @override
  final String wireName = r'VendorDashboardSeriesPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardSeriesPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'order_requests';
    yield serializers.serialize(
      object.orderRequests,
      specifiedType: const FullType(int),
    );
    if (object.ordersAverage != null) {
      yield r'orders_average';
      yield serializers.serialize(
        object.ordersAverage,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.grossSalesCentavos != null) {
      yield r'gross_sales_centavos';
      yield serializers.serialize(
        object.grossSalesCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.netSalesCentavos != null) {
      yield r'net_sales_centavos';
      yield serializers.serialize(
        object.netSalesCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.salesAverageCentavos != null) {
      yield r'sales_average_centavos';
      yield serializers.serialize(
        object.salesAverageCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardSeriesPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardSeriesPointBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date = valueDes;
          break;
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orders = valueDes;
          break;
        case r'order_requests':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orderRequests = valueDes;
          break;
        case r'orders_average':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.ordersAverage = valueDes;
          break;
        case r'gross_sales_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.grossSalesCentavos = valueDes;
          break;
        case r'net_sales_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.netSalesCentavos = valueDes;
          break;
        case r'sales_average_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.salesAverageCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardSeriesPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardSeriesPointBuilder();
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


