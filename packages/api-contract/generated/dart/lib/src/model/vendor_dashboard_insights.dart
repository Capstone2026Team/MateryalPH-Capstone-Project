//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_dashboard_stock.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dashboard_action.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_disputes.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_orders.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_performance.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_insights_period.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_insights_access.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_insights_traffic.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_insights.g.dart';

/// VendorDashboardInsights
///
/// Properties:
/// * [generatedAt]
/// * [period]
/// * [access]
/// * [definitions]
/// * [orders]
/// * [performance]
/// * [stock]
/// * [disputes]
/// * [actions]
/// * [traffic]
@BuiltValue()
abstract class VendorDashboardInsights implements Built<VendorDashboardInsights, VendorDashboardInsightsBuilder> {
  @BuiltValueField(wireName: r'generated_at')
  DateTime get generatedAt;

  @BuiltValueField(wireName: r'period')
  VendorDashboardInsightsPeriod get period;

  @BuiltValueField(wireName: r'access')
  VendorDashboardInsightsAccess get access;

  @BuiltValueField(wireName: r'definitions')
  BuiltMap<String, String> get definitions;

  @BuiltValueField(wireName: r'orders')
  VendorDashboardOrders? get orders;

  @BuiltValueField(wireName: r'performance')
  VendorDashboardPerformance? get performance;

  @BuiltValueField(wireName: r'stock')
  VendorDashboardStock? get stock;

  @BuiltValueField(wireName: r'disputes')
  VendorDashboardDisputes? get disputes;

  @BuiltValueField(wireName: r'actions')
  BuiltList<DashboardAction> get actions;

  @BuiltValueField(wireName: r'traffic')
  VendorDashboardInsightsTraffic get traffic;

  VendorDashboardInsights._();

  factory VendorDashboardInsights([void updates(VendorDashboardInsightsBuilder b)]) = _$VendorDashboardInsights;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardInsightsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardInsights> get serializer => _$VendorDashboardInsightsSerializer();
}

class _$VendorDashboardInsightsSerializer implements PrimitiveSerializer<VendorDashboardInsights> {
  @override
  final Iterable<Type> types = const [VendorDashboardInsights, _$VendorDashboardInsights];

  @override
  final String wireName = r'VendorDashboardInsights';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardInsights object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'generated_at';
    yield serializers.serialize(
      object.generatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'period';
    yield serializers.serialize(
      object.period,
      specifiedType: const FullType(VendorDashboardInsightsPeriod),
    );
    yield r'access';
    yield serializers.serialize(
      object.access,
      specifiedType: const FullType(VendorDashboardInsightsAccess),
    );
    yield r'definitions';
    yield serializers.serialize(
      object.definitions,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
    if (object.orders != null) {
      yield r'orders';
      yield serializers.serialize(
        object.orders,
        specifiedType: const FullType.nullable(VendorDashboardOrders),
      );
    }
    if (object.performance != null) {
      yield r'performance';
      yield serializers.serialize(
        object.performance,
        specifiedType: const FullType.nullable(VendorDashboardPerformance),
      );
    }
    if (object.stock != null) {
      yield r'stock';
      yield serializers.serialize(
        object.stock,
        specifiedType: const FullType.nullable(VendorDashboardStock),
      );
    }
    if (object.disputes != null) {
      yield r'disputes';
      yield serializers.serialize(
        object.disputes,
        specifiedType: const FullType.nullable(VendorDashboardDisputes),
      );
    }
    yield r'actions';
    yield serializers.serialize(
      object.actions,
      specifiedType: const FullType(BuiltList, [FullType(DashboardAction)]),
    );
    yield r'traffic';
    yield serializers.serialize(
      object.traffic,
      specifiedType: const FullType(VendorDashboardInsightsTraffic),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardInsights object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardInsightsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'generated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.generatedAt = valueDes;
          break;
        case r'period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDashboardInsightsPeriod),
          ) as VendorDashboardInsightsPeriod;
          result.period.replace(valueDes);
          break;
        case r'access':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDashboardInsightsAccess),
          ) as VendorDashboardInsightsAccess;
          result.access.replace(valueDes);
          break;
        case r'definitions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.definitions.replace(valueDes);
          break;
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorDashboardOrders),
          ) as VendorDashboardOrders?;
          if (valueDes == null) continue;
          result.orders.replace(valueDes);
          break;
        case r'performance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorDashboardPerformance),
          ) as VendorDashboardPerformance?;
          if (valueDes == null) continue;
          result.performance.replace(valueDes);
          break;
        case r'stock':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorDashboardStock),
          ) as VendorDashboardStock?;
          if (valueDes == null) continue;
          result.stock.replace(valueDes);
          break;
        case r'disputes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorDashboardDisputes),
          ) as VendorDashboardDisputes?;
          if (valueDes == null) continue;
          result.disputes.replace(valueDes);
          break;
        case r'actions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DashboardAction)]),
          ) as BuiltList<DashboardAction>;
          result.actions.replace(valueDes);
          break;
        case r'traffic':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDashboardInsightsTraffic),
          ) as VendorDashboardInsightsTraffic;
          result.traffic.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardInsights deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardInsightsBuilder();
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


