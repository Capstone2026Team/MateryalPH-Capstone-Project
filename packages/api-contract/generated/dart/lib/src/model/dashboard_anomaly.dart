//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dashboard_anomaly.g.dart';

/// A day more than three residual standard deviations from its fitted value.
///
/// Properties:
/// * [date]
/// * [value]
/// * [expected]
/// * [deviation]
@BuiltValue()
abstract class DashboardAnomaly implements Built<DashboardAnomaly, DashboardAnomalyBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'value')
  num get value;

  @BuiltValueField(wireName: r'expected')
  num get expected;

  @BuiltValueField(wireName: r'deviation')
  num get deviation;

  DashboardAnomaly._();

  factory DashboardAnomaly([void updates(DashboardAnomalyBuilder b)]) = _$DashboardAnomaly;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DashboardAnomalyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DashboardAnomaly> get serializer => _$DashboardAnomalySerializer();
}

class _$DashboardAnomalySerializer implements PrimitiveSerializer<DashboardAnomaly> {
  @override
  final Iterable<Type> types = const [DashboardAnomaly, _$DashboardAnomaly];

  @override
  final String wireName = r'DashboardAnomaly';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DashboardAnomaly object, {
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
    yield r'expected';
    yield serializers.serialize(
      object.expected,
      specifiedType: const FullType(num),
    );
    yield r'deviation';
    yield serializers.serialize(
      object.deviation,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DashboardAnomaly object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DashboardAnomalyBuilder result,
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
        case r'expected':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.expected = valueDes;
          break;
        case r'deviation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.deviation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DashboardAnomaly deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DashboardAnomalyBuilder();
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


