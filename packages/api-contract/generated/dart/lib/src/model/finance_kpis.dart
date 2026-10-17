//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/finance_kpis_period.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/commission_trend_point.dart';
import 'package:materyalph_api_client/src/model/finance_kpi.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'finance_kpis.g.dart';

/// FinanceKpis
///
/// Properties:
/// * [label]
/// * [scenario]
/// * [period]
/// * [commerce]
/// * [finance]
/// * [counts]
/// * [trend]
/// * [trendGranularity] - DAY when the recorded range spans at most 92 days (empty days are zero-filled); otherwise MONTH, recorded months only.
@BuiltValue()
abstract class FinanceKpis implements Built<FinanceKpis, FinanceKpisBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'scenario')
  String get scenario;

  @BuiltValueField(wireName: r'period')
  FinanceKpisPeriod get period;

  @BuiltValueField(wireName: r'commerce')
  BuiltList<FinanceKpi> get commerce;

  @BuiltValueField(wireName: r'finance')
  BuiltList<FinanceKpi> get finance;

  @BuiltValueField(wireName: r'counts')
  BuiltMap<String, int> get counts;

  @BuiltValueField(wireName: r'trend')
  BuiltList<CommissionTrendPoint>? get trend;

  /// DAY when the recorded range spans at most 92 days (empty days are zero-filled); otherwise MONTH, recorded months only.
  @BuiltValueField(wireName: r'trend_granularity')
  FinanceKpisTrendGranularityEnum? get trendGranularity;
  // enum trendGranularityEnum {  DAY,  MONTH,  };

  FinanceKpis._();

  factory FinanceKpis([void updates(FinanceKpisBuilder b)]) = _$FinanceKpis;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FinanceKpisBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FinanceKpis> get serializer => _$FinanceKpisSerializer();
}

class _$FinanceKpisSerializer implements PrimitiveSerializer<FinanceKpis> {
  @override
  final Iterable<Type> types = const [FinanceKpis, _$FinanceKpis];

  @override
  final String wireName = r'FinanceKpis';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FinanceKpis object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'scenario';
    yield serializers.serialize(
      object.scenario,
      specifiedType: const FullType(String),
    );
    yield r'period';
    yield serializers.serialize(
      object.period,
      specifiedType: const FullType(FinanceKpisPeriod),
    );
    yield r'commerce';
    yield serializers.serialize(
      object.commerce,
      specifiedType: const FullType(BuiltList, [FullType(FinanceKpi)]),
    );
    yield r'finance';
    yield serializers.serialize(
      object.finance,
      specifiedType: const FullType(BuiltList, [FullType(FinanceKpi)]),
    );
    yield r'counts';
    yield serializers.serialize(
      object.counts,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
    );
    if (object.trend != null) {
      yield r'trend';
      yield serializers.serialize(
        object.trend,
        specifiedType: const FullType(BuiltList, [FullType(CommissionTrendPoint)]),
      );
    }
    if (object.trendGranularity != null) {
      yield r'trend_granularity';
      yield serializers.serialize(
        object.trendGranularity,
        specifiedType: const FullType(FinanceKpisTrendGranularityEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FinanceKpis object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FinanceKpisBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'scenario':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.scenario = valueDes;
          break;
        case r'period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FinanceKpisPeriod),
          ) as FinanceKpisPeriod;
          result.period.replace(valueDes);
          break;
        case r'commerce':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FinanceKpi)]),
          ) as BuiltList<FinanceKpi>;
          result.commerce.replace(valueDes);
          break;
        case r'finance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FinanceKpi)]),
          ) as BuiltList<FinanceKpi>;
          result.finance.replace(valueDes);
          break;
        case r'counts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>;
          result.counts.replace(valueDes);
          break;
        case r'trend':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(CommissionTrendPoint)]),
          ) as BuiltList<CommissionTrendPoint>?;
          if (valueDes == null) continue;
          result.trend.replace(valueDes);
          break;
        case r'trend_granularity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FinanceKpisTrendGranularityEnum),
          ) as FinanceKpisTrendGranularityEnum?;
          if (valueDes == null) continue;
          result.trendGranularity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FinanceKpis deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FinanceKpisBuilder();
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


/// DAY when the recorded range spans at most 92 days (empty days are zero-filled); otherwise MONTH, recorded months only.
class FinanceKpisTrendGranularityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DAY')
  static const FinanceKpisTrendGranularityEnum DAY = _$financeKpisTrendGranularityEnum_DAY;
  @BuiltValueEnumConst(wireName: r'MONTH')
  static const FinanceKpisTrendGranularityEnum MONTH = _$financeKpisTrendGranularityEnum_MONTH;

  static Serializer<FinanceKpisTrendGranularityEnum> get serializer => _$financeKpisTrendGranularityEnumSerializer;

  const FinanceKpisTrendGranularityEnum._(String name): super(name);

  static BuiltSet<FinanceKpisTrendGranularityEnum> get values => _$financeKpisTrendGranularityEnumValues;
  static FinanceKpisTrendGranularityEnum valueOf(String name) => _$financeKpisTrendGranularityEnumValueOf(name);
}

