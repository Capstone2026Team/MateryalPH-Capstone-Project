//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_rate.g.dart';

/// Numerator and denominator are always shown with the percentage, or all null when suppressed.
///
/// Properties:
/// * [percent]
/// * [numerator]
/// * [denominator]
/// * [suppressed]
/// * [reason]
@BuiltValue()
abstract class GeoRate implements Built<GeoRate, GeoRateBuilder> {
  @BuiltValueField(wireName: r'percent')
  String? get percent;

  @BuiltValueField(wireName: r'numerator')
  int? get numerator;

  @BuiltValueField(wireName: r'denominator')
  int? get denominator;

  @BuiltValueField(wireName: r'suppressed')
  bool? get suppressed;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  GeoRate._();

  factory GeoRate([void updates(GeoRateBuilder b)]) = _$GeoRate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoRateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoRate> get serializer => _$GeoRateSerializer();
}

class _$GeoRateSerializer implements PrimitiveSerializer<GeoRate> {
  @override
  final Iterable<Type> types = const [GeoRate, _$GeoRate];

  @override
  final String wireName = r'GeoRate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoRate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.percent != null) {
      yield r'percent';
      yield serializers.serialize(
        object.percent,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.numerator != null) {
      yield r'numerator';
      yield serializers.serialize(
        object.numerator,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.denominator != null) {
      yield r'denominator';
      yield serializers.serialize(
        object.denominator,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.suppressed != null) {
      yield r'suppressed';
      yield serializers.serialize(
        object.suppressed,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoRate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoRateBuilder result,
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
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.numerator = valueDes;
          break;
        case r'denominator':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.denominator = valueDes;
          break;
        case r'suppressed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.suppressed = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoRate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoRateBuilder();
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


