//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/geo_child.dart';
import 'package:materyalph_api_client/src/model/geo_kpis.dart';
import 'package:materyalph_api_client/src/model/geo_scope.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_marketplace_disclosure.dart';
import 'package:materyalph_api_client/src/model/geo_dataset.dart';
import 'package:materyalph_api_client/src/model/geo_filter_applicability.dart';
import 'package:materyalph_api_client/src/model/geo_dashboard_period.dart';
import 'package:materyalph_api_client/src/model/geo_dashboard_unresolved.dart';
import 'package:materyalph_api_client/src/model/geo_activity_point.dart';
import 'package:materyalph_api_client/src/model/geo_trend_point.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_dashboard.g.dart';

/// Aggregate facts only: PSGC codes and counts, never coordinates, Buyer identities or private evidence. Suppressed person-derived values are null with the reason; they stay counted in the parent total.
///
/// Properties:
/// * [scope]
/// * [dataset]
/// * [period]
/// * [filters]
/// * [filterApplicability]
/// * [disclosure]
/// * [kpis]
/// * [trends]
/// * [activityTrend]
/// * [children]
/// * [unresolved]
/// * [definitions]
@BuiltValue()
abstract class GeoDashboard implements Built<GeoDashboard, GeoDashboardBuilder> {
  @BuiltValueField(wireName: r'scope')
  GeoScope get scope;

  @BuiltValueField(wireName: r'dataset')
  GeoDataset get dataset;

  @BuiltValueField(wireName: r'period')
  GeoDashboardPeriod get period;

  @BuiltValueField(wireName: r'filters')
  BuiltMap<String, JsonObject?> get filters;

  @BuiltValueField(wireName: r'filter_applicability')
  BuiltList<GeoFilterApplicability> get filterApplicability;

  @BuiltValueField(wireName: r'disclosure')
  AdminDashboardMarketplaceDisclosure get disclosure;

  @BuiltValueField(wireName: r'kpis')
  GeoKpis get kpis;

  @BuiltValueField(wireName: r'trends')
  BuiltList<GeoTrendPoint> get trends;

  @BuiltValueField(wireName: r'activity_trend')
  BuiltList<GeoActivityPoint> get activityTrend;

  @BuiltValueField(wireName: r'children')
  BuiltList<GeoChild> get children;

  @BuiltValueField(wireName: r'unresolved')
  GeoDashboardUnresolved get unresolved;

  @BuiltValueField(wireName: r'definitions')
  BuiltMap<String, String> get definitions;

  GeoDashboard._();

  factory GeoDashboard([void updates(GeoDashboardBuilder b)]) = _$GeoDashboard;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoDashboardBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoDashboard> get serializer => _$GeoDashboardSerializer();
}

class _$GeoDashboardSerializer implements PrimitiveSerializer<GeoDashboard> {
  @override
  final Iterable<Type> types = const [GeoDashboard, _$GeoDashboard];

  @override
  final String wireName = r'GeoDashboard';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoDashboard object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(GeoScope),
    );
    yield r'dataset';
    yield serializers.serialize(
      object.dataset,
      specifiedType: const FullType(GeoDataset),
    );
    yield r'period';
    yield serializers.serialize(
      object.period,
      specifiedType: const FullType(GeoDashboardPeriod),
    );
    yield r'filters';
    yield serializers.serialize(
      object.filters,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'filter_applicability';
    yield serializers.serialize(
      object.filterApplicability,
      specifiedType: const FullType(BuiltList, [FullType(GeoFilterApplicability)]),
    );
    yield r'disclosure';
    yield serializers.serialize(
      object.disclosure,
      specifiedType: const FullType(AdminDashboardMarketplaceDisclosure),
    );
    yield r'kpis';
    yield serializers.serialize(
      object.kpis,
      specifiedType: const FullType(GeoKpis),
    );
    yield r'trends';
    yield serializers.serialize(
      object.trends,
      specifiedType: const FullType(BuiltList, [FullType(GeoTrendPoint)]),
    );
    yield r'activity_trend';
    yield serializers.serialize(
      object.activityTrend,
      specifiedType: const FullType(BuiltList, [FullType(GeoActivityPoint)]),
    );
    yield r'children';
    yield serializers.serialize(
      object.children,
      specifiedType: const FullType(BuiltList, [FullType(GeoChild)]),
    );
    yield r'unresolved';
    yield serializers.serialize(
      object.unresolved,
      specifiedType: const FullType(GeoDashboardUnresolved),
    );
    yield r'definitions';
    yield serializers.serialize(
      object.definitions,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoDashboard object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoDashboardBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoScope),
          ) as GeoScope;
          result.scope.replace(valueDes);
          break;
        case r'dataset':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoDataset),
          ) as GeoDataset;
          result.dataset.replace(valueDes);
          break;
        case r'period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoDashboardPeriod),
          ) as GeoDashboardPeriod;
          result.period.replace(valueDes);
          break;
        case r'filters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.filters.replace(valueDes);
          break;
        case r'filter_applicability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GeoFilterApplicability)]),
          ) as BuiltList<GeoFilterApplicability>;
          result.filterApplicability.replace(valueDes);
          break;
        case r'disclosure':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminDashboardMarketplaceDisclosure),
          ) as AdminDashboardMarketplaceDisclosure;
          result.disclosure.replace(valueDes);
          break;
        case r'kpis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoKpis),
          ) as GeoKpis;
          result.kpis.replace(valueDes);
          break;
        case r'trends':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GeoTrendPoint)]),
          ) as BuiltList<GeoTrendPoint>;
          result.trends.replace(valueDes);
          break;
        case r'activity_trend':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GeoActivityPoint)]),
          ) as BuiltList<GeoActivityPoint>;
          result.activityTrend.replace(valueDes);
          break;
        case r'children':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GeoChild)]),
          ) as BuiltList<GeoChild>;
          result.children.replace(valueDes);
          break;
        case r'unresolved':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoDashboardUnresolved),
          ) as GeoDashboardUnresolved;
          result.unresolved.replace(valueDes);
          break;
        case r'definitions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.definitions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoDashboard deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoDashboardBuilder();
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


