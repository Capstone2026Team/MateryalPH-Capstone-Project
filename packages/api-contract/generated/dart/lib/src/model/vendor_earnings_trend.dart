//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:materyalph_api_client/src/model/vendor_earnings_trend_point.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_earnings_trend_comparison.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_earnings_trend.g.dart';

/// The Earnings figures bucketed by Asia/Manila day (by calendar month when the period exceeds 92 days) over the filtered period, which ends today at the latest and starts at the store's first order when no start date is given; each figure uses the same date column as its total. Records only: no forecast, ratio or derived income figure. TEST/DEMO.
///
/// Properties:
/// * [granularity]
/// * [timezone]
/// * [from]
/// * [to]
/// * [days]
/// * [points] - One point per day or month in order; a bucket with no records is zero. Empty when the period starts after today.
/// * [previous] - Totals of the equal-length period just before this one, for comparison; null when the period is empty.
@BuiltValue()
abstract class VendorEarningsTrend implements Built<VendorEarningsTrend, VendorEarningsTrendBuilder> {
  @BuiltValueField(wireName: r'granularity')
  VendorEarningsTrendGranularityEnum get granularity;
  // enum granularityEnum {  DAY,  MONTH,  };

  @BuiltValueField(wireName: r'timezone')
  String get timezone;

  @BuiltValueField(wireName: r'from')
  Date get from;

  @BuiltValueField(wireName: r'to')
  Date get to;

  @BuiltValueField(wireName: r'days')
  int get days;

  /// One point per day or month in order; a bucket with no records is zero. Empty when the period starts after today.
  @BuiltValueField(wireName: r'points')
  BuiltList<VendorEarningsTrendPoint> get points;

  /// Totals of the equal-length period just before this one, for comparison; null when the period is empty.
  @BuiltValueField(wireName: r'previous')
  VendorEarningsTrendComparison? get previous;

  VendorEarningsTrend._();

  factory VendorEarningsTrend([void updates(VendorEarningsTrendBuilder b)]) = _$VendorEarningsTrend;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorEarningsTrendBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorEarningsTrend> get serializer => _$VendorEarningsTrendSerializer();
}

class _$VendorEarningsTrendSerializer implements PrimitiveSerializer<VendorEarningsTrend> {
  @override
  final Iterable<Type> types = const [VendorEarningsTrend, _$VendorEarningsTrend];

  @override
  final String wireName = r'VendorEarningsTrend';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorEarningsTrend object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'granularity';
    yield serializers.serialize(
      object.granularity,
      specifiedType: const FullType(VendorEarningsTrendGranularityEnum),
    );
    yield r'timezone';
    yield serializers.serialize(
      object.timezone,
      specifiedType: const FullType(String),
    );
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(Date),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(Date),
    );
    yield r'days';
    yield serializers.serialize(
      object.days,
      specifiedType: const FullType(int),
    );
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType: const FullType(BuiltList, [FullType(VendorEarningsTrendPoint)]),
    );
    yield r'previous';
    yield object.previous == null ? null : serializers.serialize(
      object.previous,
      specifiedType: const FullType.nullable(VendorEarningsTrendComparison),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorEarningsTrend object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorEarningsTrendBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'granularity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorEarningsTrendGranularityEnum),
          ) as VendorEarningsTrendGranularityEnum;
          result.granularity = valueDes;
          break;
        case r'timezone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.timezone = valueDes;
          break;
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.to = valueDes;
          break;
        case r'days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.days = valueDes;
          break;
        case r'points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorEarningsTrendPoint)]),
          ) as BuiltList<VendorEarningsTrendPoint>;
          result.points.replace(valueDes);
          break;
        case r'previous':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorEarningsTrendComparison),
          ) as VendorEarningsTrendComparison?;
          if (valueDes == null) continue;
          result.previous.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorEarningsTrend deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorEarningsTrendBuilder();
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


class VendorEarningsTrendGranularityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DAY')
  static const VendorEarningsTrendGranularityEnum DAY = _$vendorEarningsTrendGranularityEnum_DAY;
  @BuiltValueEnumConst(wireName: r'MONTH')
  static const VendorEarningsTrendGranularityEnum MONTH = _$vendorEarningsTrendGranularityEnum_MONTH;

  static Serializer<VendorEarningsTrendGranularityEnum> get serializer => _$vendorEarningsTrendGranularityEnumSerializer;

  const VendorEarningsTrendGranularityEnum._(String name): super(name);

  static BuiltSet<VendorEarningsTrendGranularityEnum> get values => _$vendorEarningsTrendGranularityEnumValues;
  static VendorEarningsTrendGranularityEnum valueOf(String name) => _$vendorEarningsTrendGranularityEnumValueOf(name);
}

