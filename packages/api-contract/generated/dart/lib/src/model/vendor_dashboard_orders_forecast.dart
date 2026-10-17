//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/dashboard_forecast.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_orders_forecast.g.dart';

/// VendorDashboardOrdersForecast
///
/// Properties:
/// * [horizonDays]
/// * [orders]
/// * [sales]
@BuiltValue()
abstract class VendorDashboardOrdersForecast implements Built<VendorDashboardOrdersForecast, VendorDashboardOrdersForecastBuilder> {
  @BuiltValueField(wireName: r'horizon_days')
  int get horizonDays;

  @BuiltValueField(wireName: r'orders')
  DashboardForecast get orders;

  @BuiltValueField(wireName: r'sales')
  DashboardForecast? get sales;

  VendorDashboardOrdersForecast._();

  factory VendorDashboardOrdersForecast([void updates(VendorDashboardOrdersForecastBuilder b)]) = _$VendorDashboardOrdersForecast;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardOrdersForecastBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardOrdersForecast> get serializer => _$VendorDashboardOrdersForecastSerializer();
}

class _$VendorDashboardOrdersForecastSerializer implements PrimitiveSerializer<VendorDashboardOrdersForecast> {
  @override
  final Iterable<Type> types = const [VendorDashboardOrdersForecast, _$VendorDashboardOrdersForecast];

  @override
  final String wireName = r'VendorDashboardOrdersForecast';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardOrdersForecast object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'horizon_days';
    yield serializers.serialize(
      object.horizonDays,
      specifiedType: const FullType(int),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(DashboardForecast),
    );
    if (object.sales != null) {
      yield r'sales';
      yield serializers.serialize(
        object.sales,
        specifiedType: const FullType.nullable(DashboardForecast),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardOrdersForecast object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardOrdersForecastBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'horizon_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.horizonDays = valueDes;
          break;
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardForecast),
          ) as DashboardForecast;
          result.orders.replace(valueDes);
          break;
        case r'sales':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DashboardForecast),
          ) as DashboardForecast?;
          if (valueDes == null) continue;
          result.sales.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardOrdersForecast deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardOrdersForecastBuilder();
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


