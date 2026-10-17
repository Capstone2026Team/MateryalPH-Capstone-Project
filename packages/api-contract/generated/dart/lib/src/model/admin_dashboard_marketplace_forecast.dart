//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/dashboard_forecast.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_marketplace_forecast.g.dart';

/// AdminDashboardMarketplaceForecast
///
/// Properties:
/// * [horizonDays]
/// * [grossGmv]
/// * [orderVolume]
@BuiltValue()
abstract class AdminDashboardMarketplaceForecast implements Built<AdminDashboardMarketplaceForecast, AdminDashboardMarketplaceForecastBuilder> {
  @BuiltValueField(wireName: r'horizon_days')
  int get horizonDays;

  @BuiltValueField(wireName: r'gross_gmv')
  DashboardForecast get grossGmv;

  @BuiltValueField(wireName: r'order_volume')
  DashboardForecast get orderVolume;

  AdminDashboardMarketplaceForecast._();

  factory AdminDashboardMarketplaceForecast([void updates(AdminDashboardMarketplaceForecastBuilder b)]) = _$AdminDashboardMarketplaceForecast;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardMarketplaceForecastBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardMarketplaceForecast> get serializer => _$AdminDashboardMarketplaceForecastSerializer();
}

class _$AdminDashboardMarketplaceForecastSerializer implements PrimitiveSerializer<AdminDashboardMarketplaceForecast> {
  @override
  final Iterable<Type> types = const [AdminDashboardMarketplaceForecast, _$AdminDashboardMarketplaceForecast];

  @override
  final String wireName = r'AdminDashboardMarketplaceForecast';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardMarketplaceForecast object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'horizon_days';
    yield serializers.serialize(
      object.horizonDays,
      specifiedType: const FullType(int),
    );
    yield r'gross_gmv';
    yield serializers.serialize(
      object.grossGmv,
      specifiedType: const FullType(DashboardForecast),
    );
    yield r'order_volume';
    yield serializers.serialize(
      object.orderVolume,
      specifiedType: const FullType(DashboardForecast),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardMarketplaceForecast object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardMarketplaceForecastBuilder result,
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
        case r'gross_gmv':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardForecast),
          ) as DashboardForecast;
          result.grossGmv.replace(valueDes);
          break;
        case r'order_volume':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardForecast),
          ) as DashboardForecast;
          result.orderVolume.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardMarketplaceForecast deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardMarketplaceForecastBuilder();
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


