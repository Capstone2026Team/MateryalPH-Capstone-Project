//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_team_performance_trend_points_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_performance_trend.g.dart';

/// VendorTeamPerformanceTrend
///
/// Properties:
/// * [metric]
/// * [granularity]
/// * [from]
/// * [to]
/// * [points]
@BuiltValue()
abstract class VendorTeamPerformanceTrend implements Built<VendorTeamPerformanceTrend, VendorTeamPerformanceTrendBuilder> {
  @BuiltValueField(wireName: r'metric')
  VendorTeamPerformanceTrendMetricEnum get metric;
  // enum metricEnum {  SALES,  INVENTORY_UPDATES,  HANDOVERS,  ACTIONS,  };

  @BuiltValueField(wireName: r'granularity')
  VendorTeamPerformanceTrendGranularityEnum get granularity;
  // enum granularityEnum {  DAY,  MONTH,  };

  @BuiltValueField(wireName: r'from')
  String get from;

  @BuiltValueField(wireName: r'to')
  String get to;

  @BuiltValueField(wireName: r'points')
  BuiltList<VendorTeamPerformanceTrendPointsInner> get points;

  VendorTeamPerformanceTrend._();

  factory VendorTeamPerformanceTrend([void updates(VendorTeamPerformanceTrendBuilder b)]) = _$VendorTeamPerformanceTrend;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamPerformanceTrendBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamPerformanceTrend> get serializer => _$VendorTeamPerformanceTrendSerializer();
}

class _$VendorTeamPerformanceTrendSerializer implements PrimitiveSerializer<VendorTeamPerformanceTrend> {
  @override
  final Iterable<Type> types = const [VendorTeamPerformanceTrend, _$VendorTeamPerformanceTrend];

  @override
  final String wireName = r'VendorTeamPerformanceTrend';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamPerformanceTrend object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'metric';
    yield serializers.serialize(
      object.metric,
      specifiedType: const FullType(VendorTeamPerformanceTrendMetricEnum),
    );
    yield r'granularity';
    yield serializers.serialize(
      object.granularity,
      specifiedType: const FullType(VendorTeamPerformanceTrendGranularityEnum),
    );
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(String),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(String),
    );
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType: const FullType(BuiltList, [FullType(VendorTeamPerformanceTrendPointsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeamPerformanceTrend object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamPerformanceTrendBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'metric':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorTeamPerformanceTrendMetricEnum),
          ) as VendorTeamPerformanceTrendMetricEnum;
          result.metric = valueDes;
          break;
        case r'granularity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorTeamPerformanceTrendGranularityEnum),
          ) as VendorTeamPerformanceTrendGranularityEnum;
          result.granularity = valueDes;
          break;
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.to = valueDes;
          break;
        case r'points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorTeamPerformanceTrendPointsInner)]),
          ) as BuiltList<VendorTeamPerformanceTrendPointsInner>;
          result.points.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeamPerformanceTrend deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamPerformanceTrendBuilder();
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


class VendorTeamPerformanceTrendMetricEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SALES')
  static const VendorTeamPerformanceTrendMetricEnum SALES = _$vendorTeamPerformanceTrendMetricEnum_SALES;
  @BuiltValueEnumConst(wireName: r'INVENTORY_UPDATES')
  static const VendorTeamPerformanceTrendMetricEnum INVENTORY_UPDATES = _$vendorTeamPerformanceTrendMetricEnum_INVENTORY_UPDATES;
  @BuiltValueEnumConst(wireName: r'HANDOVERS')
  static const VendorTeamPerformanceTrendMetricEnum HANDOVERS = _$vendorTeamPerformanceTrendMetricEnum_HANDOVERS;
  @BuiltValueEnumConst(wireName: r'ACTIONS')
  static const VendorTeamPerformanceTrendMetricEnum ACTIONS = _$vendorTeamPerformanceTrendMetricEnum_ACTIONS;

  static Serializer<VendorTeamPerformanceTrendMetricEnum> get serializer => _$vendorTeamPerformanceTrendMetricEnumSerializer;

  const VendorTeamPerformanceTrendMetricEnum._(String name): super(name);

  static BuiltSet<VendorTeamPerformanceTrendMetricEnum> get values => _$vendorTeamPerformanceTrendMetricEnumValues;
  static VendorTeamPerformanceTrendMetricEnum valueOf(String name) => _$vendorTeamPerformanceTrendMetricEnumValueOf(name);
}

class VendorTeamPerformanceTrendGranularityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DAY')
  static const VendorTeamPerformanceTrendGranularityEnum DAY = _$vendorTeamPerformanceTrendGranularityEnum_DAY;
  @BuiltValueEnumConst(wireName: r'MONTH')
  static const VendorTeamPerformanceTrendGranularityEnum MONTH = _$vendorTeamPerformanceTrendGranularityEnum_MONTH;

  static Serializer<VendorTeamPerformanceTrendGranularityEnum> get serializer => _$vendorTeamPerformanceTrendGranularityEnumSerializer;

  const VendorTeamPerformanceTrendGranularityEnum._(String name): super(name);

  static BuiltSet<VendorTeamPerformanceTrendGranularityEnum> get values => _$vendorTeamPerformanceTrendGranularityEnumValues;
  static VendorTeamPerformanceTrendGranularityEnum valueOf(String name) => _$vendorTeamPerformanceTrendGranularityEnumValueOf(name);
}

