//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/dashboard_forecast.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_product_analytics_forecast.g.dart';

/// VendorProductAnalyticsForecast
///
/// Properties:
/// * [horizonDays]
/// * [views]
@BuiltValue()
abstract class VendorProductAnalyticsForecast implements Built<VendorProductAnalyticsForecast, VendorProductAnalyticsForecastBuilder> {
  @BuiltValueField(wireName: r'horizon_days')
  int get horizonDays;

  @BuiltValueField(wireName: r'views')
  DashboardForecast get views;

  VendorProductAnalyticsForecast._();

  factory VendorProductAnalyticsForecast([void updates(VendorProductAnalyticsForecastBuilder b)]) = _$VendorProductAnalyticsForecast;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorProductAnalyticsForecastBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorProductAnalyticsForecast> get serializer => _$VendorProductAnalyticsForecastSerializer();
}

class _$VendorProductAnalyticsForecastSerializer implements PrimitiveSerializer<VendorProductAnalyticsForecast> {
  @override
  final Iterable<Type> types = const [VendorProductAnalyticsForecast, _$VendorProductAnalyticsForecast];

  @override
  final String wireName = r'VendorProductAnalyticsForecast';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorProductAnalyticsForecast object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'horizon_days';
    yield serializers.serialize(
      object.horizonDays,
      specifiedType: const FullType(int),
    );
    yield r'views';
    yield serializers.serialize(
      object.views,
      specifiedType: const FullType(DashboardForecast),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorProductAnalyticsForecast object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorProductAnalyticsForecastBuilder result,
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
        case r'views':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardForecast),
          ) as DashboardForecast;
          result.views.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorProductAnalyticsForecast deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorProductAnalyticsForecastBuilder();
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


