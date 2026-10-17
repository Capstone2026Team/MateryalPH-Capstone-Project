//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dashboard_rate.g.dart';

/// A rate with its numerator and denominator; percent is null when the denominator is zero.
///
/// Properties:
/// * [percent]
/// * [numerator]
/// * [denominator]
@BuiltValue()
abstract class DashboardRate implements Built<DashboardRate, DashboardRateBuilder> {
  @BuiltValueField(wireName: r'percent')
  String? get percent;

  @BuiltValueField(wireName: r'numerator')
  int get numerator;

  @BuiltValueField(wireName: r'denominator')
  int get denominator;

  DashboardRate._();

  factory DashboardRate([void updates(DashboardRateBuilder b)]) = _$DashboardRate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DashboardRateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DashboardRate> get serializer => _$DashboardRateSerializer();
}

class _$DashboardRateSerializer implements PrimitiveSerializer<DashboardRate> {
  @override
  final Iterable<Type> types = const [DashboardRate, _$DashboardRate];

  @override
  final String wireName = r'DashboardRate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DashboardRate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.percent != null) {
      yield r'percent';
      yield serializers.serialize(
        object.percent,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'numerator';
    yield serializers.serialize(
      object.numerator,
      specifiedType: const FullType(int),
    );
    yield r'denominator';
    yield serializers.serialize(
      object.denominator,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DashboardRate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DashboardRateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.percent = valueDes;
          break;
        case r'numerator':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.numerator = valueDes;
          break;
        case r'denominator':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.denominator = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DashboardRate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DashboardRateBuilder();
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


