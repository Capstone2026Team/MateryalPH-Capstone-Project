//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dashboard_forecast_point.g.dart';

/// DashboardForecastPoint
///
/// Properties:
/// * [date]
/// * [value]
/// * [lower]
/// * [upper]
@BuiltValue()
abstract class DashboardForecastPoint implements Built<DashboardForecastPoint, DashboardForecastPointBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'value')
  num get value;

  @BuiltValueField(wireName: r'lower')
  num get lower;

  @BuiltValueField(wireName: r'upper')
  num get upper;

  DashboardForecastPoint._();

  factory DashboardForecastPoint([void updates(DashboardForecastPointBuilder b)]) = _$DashboardForecastPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DashboardForecastPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DashboardForecastPoint> get serializer => _$DashboardForecastPointSerializer();
}

class _$DashboardForecastPointSerializer implements PrimitiveSerializer<DashboardForecastPoint> {
  @override
  final Iterable<Type> types = const [DashboardForecastPoint, _$DashboardForecastPoint];

  @override
  final String wireName = r'DashboardForecastPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DashboardForecastPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(num),
    );
    yield r'lower';
    yield serializers.serialize(
      object.lower,
      specifiedType: const FullType(num),
    );
    yield r'upper';
    yield serializers.serialize(
      object.upper,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DashboardForecastPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DashboardForecastPointBuilder result,
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
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.value = valueDes;
          break;
        case r'lower':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.lower = valueDes;
          break;
        case r'upper':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.upper = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DashboardForecastPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DashboardForecastPointBuilder();
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


