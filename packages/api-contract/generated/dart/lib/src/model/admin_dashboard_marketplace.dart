//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/admin_dashboard_marketplace_period.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_categories.dart';
import 'package:materyalph_api_client/src/model/geo_kpis.dart';
import 'package:materyalph_api_client/src/model/geo_scope.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_series_point.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_activity_point.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_marketplace_disclosure.dart';
import 'package:materyalph_api_client/src/model/geo_dataset.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_marketplace_forecast.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_areas.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_marketplace.g.dart';

/// analytics.view_aggregates. Built from the disclosure-controlled geographic read model.
///
/// Properties:
/// * [scope]
/// * [dataset]
/// * [period]
/// * [disclosure]
/// * [kpis]
/// * [series]
/// * [forecast]
/// * [activity]
/// * [areas]
/// * [categories]
@BuiltValue()
abstract class AdminDashboardMarketplace implements Built<AdminDashboardMarketplace, AdminDashboardMarketplaceBuilder> {
  @BuiltValueField(wireName: r'scope')
  GeoScope get scope;

  @BuiltValueField(wireName: r'dataset')
  GeoDataset get dataset;

  @BuiltValueField(wireName: r'period')
  AdminDashboardMarketplacePeriod get period;

  @BuiltValueField(wireName: r'disclosure')
  AdminDashboardMarketplaceDisclosure get disclosure;

  @BuiltValueField(wireName: r'kpis')
  GeoKpis get kpis;

  @BuiltValueField(wireName: r'series')
  BuiltList<AdminDashboardSeriesPoint> get series;

  @BuiltValueField(wireName: r'forecast')
  AdminDashboardMarketplaceForecast get forecast;

  @BuiltValueField(wireName: r'activity')
  BuiltList<AdminDashboardActivityPoint> get activity;

  @BuiltValueField(wireName: r'areas')
  AdminDashboardAreas get areas;

  @BuiltValueField(wireName: r'categories')
  AdminDashboardCategories get categories;

  AdminDashboardMarketplace._();

  factory AdminDashboardMarketplace([void updates(AdminDashboardMarketplaceBuilder b)]) = _$AdminDashboardMarketplace;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardMarketplaceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardMarketplace> get serializer => _$AdminDashboardMarketplaceSerializer();
}

class _$AdminDashboardMarketplaceSerializer implements PrimitiveSerializer<AdminDashboardMarketplace> {
  @override
  final Iterable<Type> types = const [AdminDashboardMarketplace, _$AdminDashboardMarketplace];

  @override
  final String wireName = r'AdminDashboardMarketplace';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardMarketplace object, {
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
      specifiedType: const FullType(AdminDashboardMarketplacePeriod),
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
    yield r'series';
    yield serializers.serialize(
      object.series,
      specifiedType: const FullType(BuiltList, [FullType(AdminDashboardSeriesPoint)]),
    );
    yield r'forecast';
    yield serializers.serialize(
      object.forecast,
      specifiedType: const FullType(AdminDashboardMarketplaceForecast),
    );
    yield r'activity';
    yield serializers.serialize(
      object.activity,
      specifiedType: const FullType(BuiltList, [FullType(AdminDashboardActivityPoint)]),
    );
    yield r'areas';
    yield serializers.serialize(
      object.areas,
      specifiedType: const FullType(AdminDashboardAreas),
    );
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(AdminDashboardCategories),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardMarketplace object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardMarketplaceBuilder result,
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
            specifiedType: const FullType(AdminDashboardMarketplacePeriod),
          ) as AdminDashboardMarketplacePeriod;
          result.period.replace(valueDes);
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
        case r'series':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminDashboardSeriesPoint)]),
          ) as BuiltList<AdminDashboardSeriesPoint>;
          result.series.replace(valueDes);
          break;
        case r'forecast':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminDashboardMarketplaceForecast),
          ) as AdminDashboardMarketplaceForecast;
          result.forecast.replace(valueDes);
          break;
        case r'activity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminDashboardActivityPoint)]),
          ) as BuiltList<AdminDashboardActivityPoint>;
          result.activity.replace(valueDes);
          break;
        case r'areas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminDashboardAreas),
          ) as AdminDashboardAreas;
          result.areas.replace(valueDes);
          break;
        case r'categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminDashboardCategories),
          ) as AdminDashboardCategories;
          result.categories.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardMarketplace deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardMarketplaceBuilder();
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


