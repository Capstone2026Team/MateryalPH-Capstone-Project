//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/explore_labels.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dataset_label.dart';
import 'package:materyalph_api_client/src/model/discovery_scope.dart';
import 'package:materyalph_api_client/src/model/feature_availability.dart';
import 'package:materyalph_api_client/src/model/explore_category_count.dart';
import 'package:materyalph_api_client/src/model/explore_counts.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'explore_summary.g.dart';

/// ExploreSummary
///
/// Properties:
/// * [scope]
/// * [countScope]
/// * [scopeLabel]
/// * [currentAsOf] - Capture time of the shared snapshot; a cached value keeps its original time.
/// * [eligibilityVersion]
/// * [counts]
/// * [labels]
/// * [categories]
/// * [materialsAnalytics]
/// * [dataset]
@BuiltValue()
abstract class ExploreSummary implements Built<ExploreSummary, ExploreSummaryBuilder> {
  @BuiltValueField(wireName: r'scope')
  DiscoveryScope get scope;

  @BuiltValueField(wireName: r'count_scope')
  ExploreSummaryCountScopeEnum get countScope;
  // enum countScopeEnum {  ALL_CATEGORIES_AT_LOCATION_RADIUS,  };

  @BuiltValueField(wireName: r'scope_label')
  String get scopeLabel;

  /// Capture time of the shared snapshot; a cached value keeps its original time.
  @BuiltValueField(wireName: r'current_as_of')
  DateTime get currentAsOf;

  @BuiltValueField(wireName: r'eligibility_version')
  String get eligibilityVersion;

  @BuiltValueField(wireName: r'counts')
  ExploreCounts get counts;

  @BuiltValueField(wireName: r'labels')
  ExploreLabels get labels;

  @BuiltValueField(wireName: r'categories')
  BuiltList<ExploreCategoryCount> get categories;

  @BuiltValueField(wireName: r'materials_analytics')
  FeatureAvailability get materialsAnalytics;

  @BuiltValueField(wireName: r'dataset')
  DatasetLabel get dataset;

  ExploreSummary._();

  factory ExploreSummary([void updates(ExploreSummaryBuilder b)]) = _$ExploreSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExploreSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExploreSummary> get serializer => _$ExploreSummarySerializer();
}

class _$ExploreSummarySerializer implements PrimitiveSerializer<ExploreSummary> {
  @override
  final Iterable<Type> types = const [ExploreSummary, _$ExploreSummary];

  @override
  final String wireName = r'ExploreSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExploreSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(DiscoveryScope),
    );
    yield r'count_scope';
    yield serializers.serialize(
      object.countScope,
      specifiedType: const FullType(ExploreSummaryCountScopeEnum),
    );
    yield r'scope_label';
    yield serializers.serialize(
      object.scopeLabel,
      specifiedType: const FullType(String),
    );
    yield r'current_as_of';
    yield serializers.serialize(
      object.currentAsOf,
      specifiedType: const FullType(DateTime),
    );
    yield r'eligibility_version';
    yield serializers.serialize(
      object.eligibilityVersion,
      specifiedType: const FullType(String),
    );
    yield r'counts';
    yield serializers.serialize(
      object.counts,
      specifiedType: const FullType(ExploreCounts),
    );
    yield r'labels';
    yield serializers.serialize(
      object.labels,
      specifiedType: const FullType(ExploreLabels),
    );
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [FullType(ExploreCategoryCount)]),
    );
    yield r'materials_analytics';
    yield serializers.serialize(
      object.materialsAnalytics,
      specifiedType: const FullType(FeatureAvailability),
    );
    yield r'dataset';
    yield serializers.serialize(
      object.dataset,
      specifiedType: const FullType(DatasetLabel),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ExploreSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExploreSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DiscoveryScope),
          ) as DiscoveryScope;
          result.scope.replace(valueDes);
          break;
        case r'count_scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ExploreSummaryCountScopeEnum),
          ) as ExploreSummaryCountScopeEnum;
          result.countScope = valueDes;
          break;
        case r'scope_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.scopeLabel = valueDes;
          break;
        case r'current_as_of':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.currentAsOf = valueDes;
          break;
        case r'eligibility_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.eligibilityVersion = valueDes;
          break;
        case r'counts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ExploreCounts),
          ) as ExploreCounts;
          result.counts.replace(valueDes);
          break;
        case r'labels':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ExploreLabels),
          ) as ExploreLabels;
          result.labels.replace(valueDes);
          break;
        case r'categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ExploreCategoryCount)]),
          ) as BuiltList<ExploreCategoryCount>;
          result.categories.replace(valueDes);
          break;
        case r'materials_analytics':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FeatureAvailability),
          ) as FeatureAvailability;
          result.materialsAnalytics.replace(valueDes);
          break;
        case r'dataset':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DatasetLabel),
          ) as DatasetLabel;
          result.dataset.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExploreSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExploreSummaryBuilder();
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


class ExploreSummaryCountScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ALL_CATEGORIES_AT_LOCATION_RADIUS')
  static const ExploreSummaryCountScopeEnum ALL_CATEGORIES_AT_LOCATION_RADIUS = _$exploreSummaryCountScopeEnum_ALL_CATEGORIES_AT_LOCATION_RADIUS;

  static Serializer<ExploreSummaryCountScopeEnum> get serializer => _$exploreSummaryCountScopeEnumSerializer;

  const ExploreSummaryCountScopeEnum._(String name): super(name);

  static BuiltSet<ExploreSummaryCountScopeEnum> get values => _$exploreSummaryCountScopeEnumValues;
  static ExploreSummaryCountScopeEnum valueOf(String name) => _$exploreSummaryCountScopeEnumValueOf(name);
}

