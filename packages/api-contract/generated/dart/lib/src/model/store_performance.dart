//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/badge_state.dart';
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:materyalph_api_client/src/model/badge_metric.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/score_metric.dart';
import 'package:built_value/json_object.dart';
import 'package:materyalph_api_client/src/model/score_history_point.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'store_performance.g.dart';

/// Owner and Store Manager. The same formulas and thresholds as the System Workflow; no Buyer identity, order amounts or protected finance.
///
/// Properties:
/// * [calculated]
/// * [asOf]
/// * [calculatedAt]
/// * [label]
/// * [scores]
/// * [ratingComponents]
/// * [operations]
/// * [ohsCalculatedOn]
/// * [nextOhsRecalculationOn]
/// * [badgeMetrics]
/// * [completedOrders]
/// * [history]
/// * [badges]
@BuiltValue()
abstract class StorePerformance implements Built<StorePerformance, StorePerformanceBuilder> {
  @BuiltValueField(wireName: r'calculated')
  bool get calculated;

  @BuiltValueField(wireName: r'as_of')
  Date? get asOf;

  @BuiltValueField(wireName: r'calculated_at')
  DateTime? get calculatedAt;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'scores')
  BuiltList<ScoreMetric> get scores;

  @BuiltValueField(wireName: r'rating_components')
  BuiltMap<String, JsonObject?> get ratingComponents;

  @BuiltValueField(wireName: r'operations')
  BuiltMap<String, JsonObject?>? get operations;

  @BuiltValueField(wireName: r'ohs_calculated_on')
  Date? get ohsCalculatedOn;

  @BuiltValueField(wireName: r'next_ohs_recalculation_on')
  Date get nextOhsRecalculationOn;

  @BuiltValueField(wireName: r'badge_metrics')
  BuiltList<BadgeMetric> get badgeMetrics;

  @BuiltValueField(wireName: r'completed_orders')
  BuiltMap<String, JsonObject?> get completedOrders;

  @BuiltValueField(wireName: r'history')
  BuiltList<ScoreHistoryPoint> get history;

  @BuiltValueField(wireName: r'badges')
  BuiltList<BadgeState> get badges;

  StorePerformance._();

  factory StorePerformance([void updates(StorePerformanceBuilder b)]) = _$StorePerformance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StorePerformanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StorePerformance> get serializer => _$StorePerformanceSerializer();
}

class _$StorePerformanceSerializer implements PrimitiveSerializer<StorePerformance> {
  @override
  final Iterable<Type> types = const [StorePerformance, _$StorePerformance];

  @override
  final String wireName = r'StorePerformance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StorePerformance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'calculated';
    yield serializers.serialize(
      object.calculated,
      specifiedType: const FullType(bool),
    );
    if (object.asOf != null) {
      yield r'as_of';
      yield serializers.serialize(
        object.asOf,
        specifiedType: const FullType(Date),
      );
    }
    if (object.calculatedAt != null) {
      yield r'calculated_at';
      yield serializers.serialize(
        object.calculatedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'scores';
    yield serializers.serialize(
      object.scores,
      specifiedType: const FullType(BuiltList, [FullType(ScoreMetric)]),
    );
    yield r'rating_components';
    yield serializers.serialize(
      object.ratingComponents,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    if (object.operations != null) {
      yield r'operations';
      yield serializers.serialize(
        object.operations,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.ohsCalculatedOn != null) {
      yield r'ohs_calculated_on';
      yield serializers.serialize(
        object.ohsCalculatedOn,
        specifiedType: const FullType(Date),
      );
    }
    yield r'next_ohs_recalculation_on';
    yield serializers.serialize(
      object.nextOhsRecalculationOn,
      specifiedType: const FullType(Date),
    );
    yield r'badge_metrics';
    yield serializers.serialize(
      object.badgeMetrics,
      specifiedType: const FullType(BuiltList, [FullType(BadgeMetric)]),
    );
    yield r'completed_orders';
    yield serializers.serialize(
      object.completedOrders,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'history';
    yield serializers.serialize(
      object.history,
      specifiedType: const FullType(BuiltList, [FullType(ScoreHistoryPoint)]),
    );
    yield r'badges';
    yield serializers.serialize(
      object.badges,
      specifiedType: const FullType(BuiltList, [FullType(BadgeState)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StorePerformance object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StorePerformanceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'calculated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.calculated = valueDes;
          break;
        case r'as_of':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.asOf = valueDes;
          break;
        case r'calculated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.calculatedAt = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'scores':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ScoreMetric)]),
          ) as BuiltList<ScoreMetric>;
          result.scores.replace(valueDes);
          break;
        case r'rating_components':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.ratingComponents.replace(valueDes);
          break;
        case r'operations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.operations.replace(valueDes);
          break;
        case r'ohs_calculated_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.ohsCalculatedOn = valueDes;
          break;
        case r'next_ohs_recalculation_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.nextOhsRecalculationOn = valueDes;
          break;
        case r'badge_metrics':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BadgeMetric)]),
          ) as BuiltList<BadgeMetric>;
          result.badgeMetrics.replace(valueDes);
          break;
        case r'completed_orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.completedOrders.replace(valueDes);
          break;
        case r'history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ScoreHistoryPoint)]),
          ) as BuiltList<ScoreHistoryPoint>;
          result.history.replace(valueDes);
          break;
        case r'badges':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BadgeState)]),
          ) as BuiltList<BadgeState>;
          result.badges.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StorePerformance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StorePerformanceBuilder();
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


