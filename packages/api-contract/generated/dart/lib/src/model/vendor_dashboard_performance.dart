//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/badge_state.dart';
import 'package:materyalph_api_client/src/model/dashboard_classification.dart';
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:materyalph_api_client/src/model/badge_metric.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/score_metric.dart';
import 'package:built_value/json_object.dart';
import 'package:materyalph_api_client/src/model/score_history_point.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_performance.g.dart';

/// scores.view_store (Owner and Store Manager). The Score service values; no second formula.
///
/// Properties:
/// * [calculated]
/// * [asOf]
/// * [label]
/// * [scores]
/// * [badgeMetrics]
/// * [operations]
/// * [history]
/// * [classification]
/// * [badges]
@BuiltValue()
abstract class VendorDashboardPerformance implements Built<VendorDashboardPerformance, VendorDashboardPerformanceBuilder> {
  @BuiltValueField(wireName: r'calculated')
  bool get calculated;

  @BuiltValueField(wireName: r'as_of')
  Date? get asOf;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'scores')
  BuiltList<ScoreMetric> get scores;

  @BuiltValueField(wireName: r'badge_metrics')
  BuiltList<BadgeMetric> get badgeMetrics;

  @BuiltValueField(wireName: r'operations')
  BuiltMap<String, JsonObject?>? get operations;

  @BuiltValueField(wireName: r'history')
  BuiltList<ScoreHistoryPoint> get history;

  @BuiltValueField(wireName: r'classification')
  DashboardClassification get classification;

  @BuiltValueField(wireName: r'badges')
  BuiltList<BadgeState> get badges;

  VendorDashboardPerformance._();

  factory VendorDashboardPerformance([void updates(VendorDashboardPerformanceBuilder b)]) = _$VendorDashboardPerformance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardPerformanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardPerformance> get serializer => _$VendorDashboardPerformanceSerializer();
}

class _$VendorDashboardPerformanceSerializer implements PrimitiveSerializer<VendorDashboardPerformance> {
  @override
  final Iterable<Type> types = const [VendorDashboardPerformance, _$VendorDashboardPerformance];

  @override
  final String wireName = r'VendorDashboardPerformance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardPerformance object, {
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
        specifiedType: const FullType.nullable(Date),
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
    yield r'badge_metrics';
    yield serializers.serialize(
      object.badgeMetrics,
      specifiedType: const FullType(BuiltList, [FullType(BadgeMetric)]),
    );
    if (object.operations != null) {
      yield r'operations';
      yield serializers.serialize(
        object.operations,
        specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    yield r'history';
    yield serializers.serialize(
      object.history,
      specifiedType: const FullType(BuiltList, [FullType(ScoreHistoryPoint)]),
    );
    yield r'classification';
    yield serializers.serialize(
      object.classification,
      specifiedType: const FullType(DashboardClassification),
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
    VendorDashboardPerformance object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardPerformanceBuilder result,
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
        case r'badge_metrics':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BadgeMetric)]),
          ) as BuiltList<BadgeMetric>;
          result.badgeMetrics.replace(valueDes);
          break;
        case r'operations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.operations.replace(valueDes);
          break;
        case r'history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ScoreHistoryPoint)]),
          ) as BuiltList<ScoreHistoryPoint>;
          result.history.replace(valueDes);
          break;
        case r'classification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardClassification),
          ) as DashboardClassification;
          result.classification.replace(valueDes);
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
  VendorDashboardPerformance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardPerformanceBuilder();
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


