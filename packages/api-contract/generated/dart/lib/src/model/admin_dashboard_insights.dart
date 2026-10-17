//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/admin_dashboard_insights_access.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_marketplace.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_vendor_health.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_insights.g.dart';

/// AdminDashboardInsights
///
/// Properties:
/// * [generatedAt]
/// * [access]
/// * [definitions]
/// * [marketplace]
/// * [marketplaceUnavailableReason]
/// * [vendorHealth]
@BuiltValue()
abstract class AdminDashboardInsights implements Built<AdminDashboardInsights, AdminDashboardInsightsBuilder> {
  @BuiltValueField(wireName: r'generated_at')
  DateTime get generatedAt;

  @BuiltValueField(wireName: r'access')
  AdminDashboardInsightsAccess get access;

  @BuiltValueField(wireName: r'definitions')
  BuiltMap<String, String> get definitions;

  @BuiltValueField(wireName: r'marketplace')
  AdminDashboardMarketplace? get marketplace;

  @BuiltValueField(wireName: r'marketplace_unavailable_reason')
  String? get marketplaceUnavailableReason;

  @BuiltValueField(wireName: r'vendor_health')
  AdminDashboardVendorHealth? get vendorHealth;

  AdminDashboardInsights._();

  factory AdminDashboardInsights([void updates(AdminDashboardInsightsBuilder b)]) = _$AdminDashboardInsights;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardInsightsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardInsights> get serializer => _$AdminDashboardInsightsSerializer();
}

class _$AdminDashboardInsightsSerializer implements PrimitiveSerializer<AdminDashboardInsights> {
  @override
  final Iterable<Type> types = const [AdminDashboardInsights, _$AdminDashboardInsights];

  @override
  final String wireName = r'AdminDashboardInsights';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardInsights object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'generated_at';
    yield serializers.serialize(
      object.generatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'access';
    yield serializers.serialize(
      object.access,
      specifiedType: const FullType(AdminDashboardInsightsAccess),
    );
    yield r'definitions';
    yield serializers.serialize(
      object.definitions,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
    if (object.marketplace != null) {
      yield r'marketplace';
      yield serializers.serialize(
        object.marketplace,
        specifiedType: const FullType.nullable(AdminDashboardMarketplace),
      );
    }
    if (object.marketplaceUnavailableReason != null) {
      yield r'marketplace_unavailable_reason';
      yield serializers.serialize(
        object.marketplaceUnavailableReason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.vendorHealth != null) {
      yield r'vendor_health';
      yield serializers.serialize(
        object.vendorHealth,
        specifiedType: const FullType.nullable(AdminDashboardVendorHealth),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardInsights object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardInsightsBuilder result,
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
        case r'access':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminDashboardInsightsAccess),
          ) as AdminDashboardInsightsAccess;
          result.access.replace(valueDes);
          break;
        case r'definitions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.definitions.replace(valueDes);
          break;
        case r'marketplace':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminDashboardMarketplace),
          ) as AdminDashboardMarketplace?;
          if (valueDes == null) continue;
          result.marketplace.replace(valueDes);
          break;
        case r'marketplace_unavailable_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.marketplaceUnavailableReason = valueDes;
          break;
        case r'vendor_health':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminDashboardVendorHealth),
          ) as AdminDashboardVendorHealth?;
          if (valueDes == null) continue;
          result.vendorHealth.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardInsights deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardInsightsBuilder();
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


