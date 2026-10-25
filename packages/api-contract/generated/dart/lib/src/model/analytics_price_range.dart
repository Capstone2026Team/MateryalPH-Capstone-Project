//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'analytics_price_range.g.dart';

/// Current per-Vendor prices per canonical unit (each Vendor once per variant at its lowest normalized price), half-up at 2 dp; all null when there is no current offer.
///
/// Properties:
/// * [minPhp]
/// * [medianPhp]
/// * [maxPhp]
@BuiltValue()
abstract class AnalyticsPriceRange implements Built<AnalyticsPriceRange, AnalyticsPriceRangeBuilder> {
  @BuiltValueField(wireName: r'min_php')
  String get minPhp;

  @BuiltValueField(wireName: r'median_php')
  String get medianPhp;

  @BuiltValueField(wireName: r'max_php')
  String get maxPhp;

  AnalyticsPriceRange._();

  factory AnalyticsPriceRange([void updates(AnalyticsPriceRangeBuilder b)]) = _$AnalyticsPriceRange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AnalyticsPriceRangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AnalyticsPriceRange> get serializer => _$AnalyticsPriceRangeSerializer();
}

class _$AnalyticsPriceRangeSerializer implements PrimitiveSerializer<AnalyticsPriceRange> {
  @override
  final Iterable<Type> types = const [AnalyticsPriceRange, _$AnalyticsPriceRange];

  @override
  final String wireName = r'AnalyticsPriceRange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AnalyticsPriceRange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'min_php';
    yield serializers.serialize(
      object.minPhp,
      specifiedType: const FullType(String),
    );
    yield r'median_php';
    yield serializers.serialize(
      object.medianPhp,
      specifiedType: const FullType(String),
    );
    yield r'max_php';
    yield serializers.serialize(
      object.maxPhp,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AnalyticsPriceRange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AnalyticsPriceRangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'min_php':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.minPhp = valueDes;
          break;
        case r'median_php':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.medianPhp = valueDes;
          break;
        case r'max_php':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.maxPhp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AnalyticsPriceRange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AnalyticsPriceRangeBuilder();
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


