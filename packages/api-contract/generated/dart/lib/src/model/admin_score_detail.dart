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

part 'admin_score_detail.g.dart';

/// AdminScoreDetail
///
/// Properties:
/// * [vendorId]
/// * [storeName]
/// * [calculated]
/// * [asOf]
/// * [label]
/// * [scores]
/// * [operations]
/// * [badgeMetrics]
/// * [badges]
/// * [badgeHistory]
/// * [suppressions]
/// * [exclusions]
/// * [sourceEvents]
/// * [history]
/// * [canInvestigate]
@BuiltValue()
abstract class AdminScoreDetail implements Built<AdminScoreDetail, AdminScoreDetailBuilder> {
  @BuiltValueField(wireName: r'vendor_id')
  String? get vendorId;

  @BuiltValueField(wireName: r'store_name')
  String? get storeName;

  @BuiltValueField(wireName: r'calculated')
  bool? get calculated;

  @BuiltValueField(wireName: r'as_of')
  Date? get asOf;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'scores')
  BuiltList<ScoreMetric>? get scores;

  @BuiltValueField(wireName: r'operations')
  BuiltMap<String, JsonObject?>? get operations;

  @BuiltValueField(wireName: r'badge_metrics')
  BuiltList<BadgeMetric>? get badgeMetrics;

  @BuiltValueField(wireName: r'badges')
  BuiltList<BadgeState>? get badges;

  @BuiltValueField(wireName: r'badge_history')
  BuiltList<BuiltMap<String, JsonObject?>>? get badgeHistory;

  @BuiltValueField(wireName: r'suppressions')
  BuiltList<BuiltMap<String, JsonObject?>>? get suppressions;

  @BuiltValueField(wireName: r'exclusions')
  BuiltList<BuiltMap<String, JsonObject?>>? get exclusions;

  @BuiltValueField(wireName: r'source_events')
  BuiltMap<String, JsonObject?>? get sourceEvents;

  @BuiltValueField(wireName: r'history')
  BuiltList<ScoreHistoryPoint>? get history;

  @BuiltValueField(wireName: r'can_investigate')
  bool? get canInvestigate;

  AdminScoreDetail._();

  factory AdminScoreDetail([void updates(AdminScoreDetailBuilder b)]) = _$AdminScoreDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminScoreDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminScoreDetail> get serializer => _$AdminScoreDetailSerializer();
}

class _$AdminScoreDetailSerializer implements PrimitiveSerializer<AdminScoreDetail> {
  @override
  final Iterable<Type> types = const [AdminScoreDetail, _$AdminScoreDetail];

  @override
  final String wireName = r'AdminScoreDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminScoreDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.vendorId != null) {
      yield r'vendor_id';
      yield serializers.serialize(
        object.vendorId,
        specifiedType: const FullType(String),
      );
    }
    if (object.storeName != null) {
      yield r'store_name';
      yield serializers.serialize(
        object.storeName,
        specifiedType: const FullType(String),
      );
    }
    if (object.calculated != null) {
      yield r'calculated';
      yield serializers.serialize(
        object.calculated,
        specifiedType: const FullType(bool),
      );
    }
    if (object.asOf != null) {
      yield r'as_of';
      yield serializers.serialize(
        object.asOf,
        specifiedType: const FullType(Date),
      );
    }
    if (object.label != null) {
      yield r'label';
      yield serializers.serialize(
        object.label,
        specifiedType: const FullType(String),
      );
    }
    if (object.scores != null) {
      yield r'scores';
      yield serializers.serialize(
        object.scores,
        specifiedType: const FullType(BuiltList, [FullType(ScoreMetric)]),
      );
    }
    if (object.operations != null) {
      yield r'operations';
      yield serializers.serialize(
        object.operations,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.badgeMetrics != null) {
      yield r'badge_metrics';
      yield serializers.serialize(
        object.badgeMetrics,
        specifiedType: const FullType(BuiltList, [FullType(BadgeMetric)]),
      );
    }
    if (object.badges != null) {
      yield r'badges';
      yield serializers.serialize(
        object.badges,
        specifiedType: const FullType(BuiltList, [FullType(BadgeState)]),
      );
    }
    if (object.badgeHistory != null) {
      yield r'badge_history';
      yield serializers.serialize(
        object.badgeHistory,
        specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
      );
    }
    if (object.suppressions != null) {
      yield r'suppressions';
      yield serializers.serialize(
        object.suppressions,
        specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
      );
    }
    if (object.exclusions != null) {
      yield r'exclusions';
      yield serializers.serialize(
        object.exclusions,
        specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
      );
    }
    if (object.sourceEvents != null) {
      yield r'source_events';
      yield serializers.serialize(
        object.sourceEvents,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.history != null) {
      yield r'history';
      yield serializers.serialize(
        object.history,
        specifiedType: const FullType(BuiltList, [FullType(ScoreHistoryPoint)]),
      );
    }
    if (object.canInvestigate != null) {
      yield r'can_investigate';
      yield serializers.serialize(
        object.canInvestigate,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminScoreDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminScoreDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vendorId = valueDes;
          break;
        case r'store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.storeName = valueDes;
          break;
        case r'calculated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'scores':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ScoreMetric)]),
          ) as BuiltList<ScoreMetric>?;
          if (valueDes == null) continue;
          result.scores.replace(valueDes);
          break;
        case r'operations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.operations.replace(valueDes);
          break;
        case r'badge_metrics':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(BadgeMetric)]),
          ) as BuiltList<BadgeMetric>?;
          if (valueDes == null) continue;
          result.badgeMetrics.replace(valueDes);
          break;
        case r'badges':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(BadgeState)]),
          ) as BuiltList<BadgeState>?;
          if (valueDes == null) continue;
          result.badges.replace(valueDes);
          break;
        case r'badge_history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>?;
          if (valueDes == null) continue;
          result.badgeHistory.replace(valueDes);
          break;
        case r'suppressions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>?;
          if (valueDes == null) continue;
          result.suppressions.replace(valueDes);
          break;
        case r'exclusions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>?;
          if (valueDes == null) continue;
          result.exclusions.replace(valueDes);
          break;
        case r'source_events':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.sourceEvents.replace(valueDes);
          break;
        case r'history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ScoreHistoryPoint)]),
          ) as BuiltList<ScoreHistoryPoint>?;
          if (valueDes == null) continue;
          result.history.replace(valueDes);
          break;
        case r'can_investigate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.canInvestigate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminScoreDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminScoreDetailBuilder();
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


