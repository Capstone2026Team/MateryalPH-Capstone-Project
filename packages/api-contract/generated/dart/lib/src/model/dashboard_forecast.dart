//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dashboard_forecast_point.dart';
import 'package:materyalph_api_client/src/model/dashboard_anomaly.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dashboard_forecast.g.dart';

/// Least-squares trend plus a weekday pattern with a 95% prediction band. A planning estimate only; INSUFFICIENT_DATA below seven active days. Money forecasts are integer centavos.
///
/// Properties:
/// * [state]
/// * [observedDays]
/// * [direction]
/// * [changePercent]
/// * [rSquared]
/// * [weekdayStrength]
/// * [expectedTotal]
/// * [points]
/// * [anomalies]
@BuiltValue()
abstract class DashboardForecast implements Built<DashboardForecast, DashboardForecastBuilder> {
  @BuiltValueField(wireName: r'state')
  DashboardForecastStateEnum get state;
  // enum stateEnum {  OK,  INSUFFICIENT_DATA,  };

  @BuiltValueField(wireName: r'observed_days')
  int get observedDays;

  @BuiltValueField(wireName: r'direction')
  DashboardForecastDirectionEnum get direction;
  // enum directionEnum {  INCREASING,  DECREASING,  FLAT,  UNKNOWN,  };

  @BuiltValueField(wireName: r'change_percent')
  num? get changePercent;

  @BuiltValueField(wireName: r'r_squared')
  num? get rSquared;

  @BuiltValueField(wireName: r'weekday_strength')
  num? get weekdayStrength;

  @BuiltValueField(wireName: r'expected_total')
  num? get expectedTotal;

  @BuiltValueField(wireName: r'points')
  BuiltList<DashboardForecastPoint> get points;

  @BuiltValueField(wireName: r'anomalies')
  BuiltList<DashboardAnomaly> get anomalies;

  DashboardForecast._();

  factory DashboardForecast([void updates(DashboardForecastBuilder b)]) = _$DashboardForecast;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DashboardForecastBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DashboardForecast> get serializer => _$DashboardForecastSerializer();
}

class _$DashboardForecastSerializer implements PrimitiveSerializer<DashboardForecast> {
  @override
  final Iterable<Type> types = const [DashboardForecast, _$DashboardForecast];

  @override
  final String wireName = r'DashboardForecast';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DashboardForecast object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(DashboardForecastStateEnum),
    );
    yield r'observed_days';
    yield serializers.serialize(
      object.observedDays,
      specifiedType: const FullType(int),
    );
    yield r'direction';
    yield serializers.serialize(
      object.direction,
      specifiedType: const FullType(DashboardForecastDirectionEnum),
    );
    if (object.changePercent != null) {
      yield r'change_percent';
      yield serializers.serialize(
        object.changePercent,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.rSquared != null) {
      yield r'r_squared';
      yield serializers.serialize(
        object.rSquared,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.weekdayStrength != null) {
      yield r'weekday_strength';
      yield serializers.serialize(
        object.weekdayStrength,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.expectedTotal != null) {
      yield r'expected_total';
      yield serializers.serialize(
        object.expectedTotal,
        specifiedType: const FullType.nullable(num),
      );
    }
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType: const FullType(BuiltList, [FullType(DashboardForecastPoint)]),
    );
    yield r'anomalies';
    yield serializers.serialize(
      object.anomalies,
      specifiedType: const FullType(BuiltList, [FullType(DashboardAnomaly)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DashboardForecast object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DashboardForecastBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardForecastStateEnum),
          ) as DashboardForecastStateEnum;
          result.state = valueDes;
          break;
        case r'observed_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.observedDays = valueDes;
          break;
        case r'direction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardForecastDirectionEnum),
          ) as DashboardForecastDirectionEnum;
          result.direction = valueDes;
          break;
        case r'change_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.changePercent = valueDes;
          break;
        case r'r_squared':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.rSquared = valueDes;
          break;
        case r'weekday_strength':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.weekdayStrength = valueDes;
          break;
        case r'expected_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.expectedTotal = valueDes;
          break;
        case r'points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DashboardForecastPoint)]),
          ) as BuiltList<DashboardForecastPoint>;
          result.points.replace(valueDes);
          break;
        case r'anomalies':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DashboardAnomaly)]),
          ) as BuiltList<DashboardAnomaly>;
          result.anomalies.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DashboardForecast deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DashboardForecastBuilder();
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


class DashboardForecastStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OK')
  static const DashboardForecastStateEnum OK = _$dashboardForecastStateEnum_OK;
  @BuiltValueEnumConst(wireName: r'INSUFFICIENT_DATA')
  static const DashboardForecastStateEnum INSUFFICIENT_DATA = _$dashboardForecastStateEnum_INSUFFICIENT_DATA;

  static Serializer<DashboardForecastStateEnum> get serializer => _$dashboardForecastStateEnumSerializer;

  const DashboardForecastStateEnum._(String name): super(name);

  static BuiltSet<DashboardForecastStateEnum> get values => _$dashboardForecastStateEnumValues;
  static DashboardForecastStateEnum valueOf(String name) => _$dashboardForecastStateEnumValueOf(name);
}

class DashboardForecastDirectionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INCREASING')
  static const DashboardForecastDirectionEnum INCREASING = _$dashboardForecastDirectionEnum_INCREASING;
  @BuiltValueEnumConst(wireName: r'DECREASING')
  static const DashboardForecastDirectionEnum DECREASING = _$dashboardForecastDirectionEnum_DECREASING;
  @BuiltValueEnumConst(wireName: r'FLAT')
  static const DashboardForecastDirectionEnum FLAT = _$dashboardForecastDirectionEnum_FLAT;
  @BuiltValueEnumConst(wireName: r'UNKNOWN')
  static const DashboardForecastDirectionEnum UNKNOWN = _$dashboardForecastDirectionEnum_UNKNOWN;

  static Serializer<DashboardForecastDirectionEnum> get serializer => _$dashboardForecastDirectionEnumSerializer;

  const DashboardForecastDirectionEnum._(String name): super(name);

  static BuiltSet<DashboardForecastDirectionEnum> get values => _$dashboardForecastDirectionEnumValues;
  static DashboardForecastDirectionEnum valueOf(String name) => _$dashboardForecastDirectionEnumValueOf(name);
}

