//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_team_fulfillment_performance.dart';
import 'package:materyalph_api_client/src/model/vendor_team_inventory_performance.dart';
import 'package:materyalph_api_client/src/model/vendor_team_quotation_performance.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_team_dispute_performance.dart';
import 'package:materyalph_api_client/src/model/vendor_team_performance_activity.dart';
import 'package:materyalph_api_client/src/model/vendor_team_performance_trend.dart';
import 'package:materyalph_api_client/src/model/vendor_team_sales_performance.dart';
import 'package:materyalph_api_client/src/model/vendor_team_confirmation_performance.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_performance.g.dart';

/// VendorTeamPerformance
///
/// Properties:
/// * [memberId]
/// * [role] - The member's current role.
/// * [timezone]
/// * [from]
/// * [to]
/// * [salesValueVisible]
/// * [activity]
/// * [sales]
/// * [quotations]
/// * [orders]
/// * [disputes]
/// * [inventory]
/// * [fulfillment]
/// * [trend]
@BuiltValue()
abstract class VendorTeamPerformance implements Built<VendorTeamPerformance, VendorTeamPerformanceBuilder> {
  @BuiltValueField(wireName: r'member_id')
  String get memberId;

  /// The member's current role.
  @BuiltValueField(wireName: r'role')
  VendorTeamPerformanceRoleEnum get role;
  // enum roleEnum {  OWNER,  STORE_MANAGER,  STORE_STAFF,  CUSTOMER_SERVICE,  INVENTORY,  FULFILLMENT,  };

  @BuiltValueField(wireName: r'timezone')
  VendorTeamPerformanceTimezoneEnum get timezone;
  // enum timezoneEnum {  Asia/Manila,  };

  @BuiltValueField(wireName: r'from')
  String? get from;

  @BuiltValueField(wireName: r'to')
  String? get to;

  @BuiltValueField(wireName: r'sales_value_visible')
  bool get salesValueVisible;

  @BuiltValueField(wireName: r'activity')
  VendorTeamPerformanceActivity get activity;

  @BuiltValueField(wireName: r'sales')
  VendorTeamSalesPerformance? get sales;

  @BuiltValueField(wireName: r'quotations')
  VendorTeamQuotationPerformance? get quotations;

  @BuiltValueField(wireName: r'orders')
  VendorTeamConfirmationPerformance? get orders;

  @BuiltValueField(wireName: r'disputes')
  VendorTeamDisputePerformance? get disputes;

  @BuiltValueField(wireName: r'inventory')
  VendorTeamInventoryPerformance? get inventory;

  @BuiltValueField(wireName: r'fulfillment')
  VendorTeamFulfillmentPerformance? get fulfillment;

  @BuiltValueField(wireName: r'trend')
  VendorTeamPerformanceTrend get trend;

  VendorTeamPerformance._();

  factory VendorTeamPerformance([void updates(VendorTeamPerformanceBuilder b)]) = _$VendorTeamPerformance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamPerformanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamPerformance> get serializer => _$VendorTeamPerformanceSerializer();
}

class _$VendorTeamPerformanceSerializer implements PrimitiveSerializer<VendorTeamPerformance> {
  @override
  final Iterable<Type> types = const [VendorTeamPerformance, _$VendorTeamPerformance];

  @override
  final String wireName = r'VendorTeamPerformance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamPerformance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'member_id';
    yield serializers.serialize(
      object.memberId,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(VendorTeamPerformanceRoleEnum),
    );
    yield r'timezone';
    yield serializers.serialize(
      object.timezone,
      specifiedType: const FullType(VendorTeamPerformanceTimezoneEnum),
    );
    if (object.from != null) {
      yield r'from';
      yield serializers.serialize(
        object.from,
        specifiedType: const FullType(String),
      );
    }
    if (object.to != null) {
      yield r'to';
      yield serializers.serialize(
        object.to,
        specifiedType: const FullType(String),
      );
    }
    yield r'sales_value_visible';
    yield serializers.serialize(
      object.salesValueVisible,
      specifiedType: const FullType(bool),
    );
    yield r'activity';
    yield serializers.serialize(
      object.activity,
      specifiedType: const FullType(VendorTeamPerformanceActivity),
    );
    if (object.sales != null) {
      yield r'sales';
      yield serializers.serialize(
        object.sales,
        specifiedType: const FullType(VendorTeamSalesPerformance),
      );
    }
    if (object.quotations != null) {
      yield r'quotations';
      yield serializers.serialize(
        object.quotations,
        specifiedType: const FullType(VendorTeamQuotationPerformance),
      );
    }
    if (object.orders != null) {
      yield r'orders';
      yield serializers.serialize(
        object.orders,
        specifiedType: const FullType(VendorTeamConfirmationPerformance),
      );
    }
    if (object.disputes != null) {
      yield r'disputes';
      yield serializers.serialize(
        object.disputes,
        specifiedType: const FullType(VendorTeamDisputePerformance),
      );
    }
    if (object.inventory != null) {
      yield r'inventory';
      yield serializers.serialize(
        object.inventory,
        specifiedType: const FullType(VendorTeamInventoryPerformance),
      );
    }
    if (object.fulfillment != null) {
      yield r'fulfillment';
      yield serializers.serialize(
        object.fulfillment,
        specifiedType: const FullType(VendorTeamFulfillmentPerformance),
      );
    }
    yield r'trend';
    yield serializers.serialize(
      object.trend,
      specifiedType: const FullType(VendorTeamPerformanceTrend),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeamPerformance object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamPerformanceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.memberId = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorTeamPerformanceRoleEnum),
          ) as VendorTeamPerformanceRoleEnum;
          result.role = valueDes;
          break;
        case r'timezone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorTeamPerformanceTimezoneEnum),
          ) as VendorTeamPerformanceTimezoneEnum;
          result.timezone = valueDes;
          break;
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.to = valueDes;
          break;
        case r'sales_value_visible':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.salesValueVisible = valueDes;
          break;
        case r'activity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorTeamPerformanceActivity),
          ) as VendorTeamPerformanceActivity;
          result.activity.replace(valueDes);
          break;
        case r'sales':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorTeamSalesPerformance),
          ) as VendorTeamSalesPerformance?;
          if (valueDes == null) continue;
          result.sales.replace(valueDes);
          break;
        case r'quotations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorTeamQuotationPerformance),
          ) as VendorTeamQuotationPerformance?;
          if (valueDes == null) continue;
          result.quotations.replace(valueDes);
          break;
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorTeamConfirmationPerformance),
          ) as VendorTeamConfirmationPerformance?;
          if (valueDes == null) continue;
          result.orders.replace(valueDes);
          break;
        case r'disputes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorTeamDisputePerformance),
          ) as VendorTeamDisputePerformance?;
          if (valueDes == null) continue;
          result.disputes.replace(valueDes);
          break;
        case r'inventory':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorTeamInventoryPerformance),
          ) as VendorTeamInventoryPerformance?;
          if (valueDes == null) continue;
          result.inventory.replace(valueDes);
          break;
        case r'fulfillment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorTeamFulfillmentPerformance),
          ) as VendorTeamFulfillmentPerformance?;
          if (valueDes == null) continue;
          result.fulfillment.replace(valueDes);
          break;
        case r'trend':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorTeamPerformanceTrend),
          ) as VendorTeamPerformanceTrend;
          result.trend.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeamPerformance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamPerformanceBuilder();
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


/// The member's current role.
class VendorTeamPerformanceRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OWNER')
  static const VendorTeamPerformanceRoleEnum OWNER = _$vendorTeamPerformanceRoleEnum_OWNER;
  @BuiltValueEnumConst(wireName: r'STORE_MANAGER')
  static const VendorTeamPerformanceRoleEnum STORE_MANAGER = _$vendorTeamPerformanceRoleEnum_STORE_MANAGER;
  @BuiltValueEnumConst(wireName: r'STORE_STAFF')
  static const VendorTeamPerformanceRoleEnum STORE_STAFF = _$vendorTeamPerformanceRoleEnum_STORE_STAFF;
  @BuiltValueEnumConst(wireName: r'CUSTOMER_SERVICE')
  static const VendorTeamPerformanceRoleEnum CUSTOMER_SERVICE = _$vendorTeamPerformanceRoleEnum_CUSTOMER_SERVICE;
  @BuiltValueEnumConst(wireName: r'INVENTORY')
  static const VendorTeamPerformanceRoleEnum INVENTORY = _$vendorTeamPerformanceRoleEnum_INVENTORY;
  @BuiltValueEnumConst(wireName: r'FULFILLMENT')
  static const VendorTeamPerformanceRoleEnum FULFILLMENT = _$vendorTeamPerformanceRoleEnum_FULFILLMENT;

  static Serializer<VendorTeamPerformanceRoleEnum> get serializer => _$vendorTeamPerformanceRoleEnumSerializer;

  const VendorTeamPerformanceRoleEnum._(String name): super(name);

  static BuiltSet<VendorTeamPerformanceRoleEnum> get values => _$vendorTeamPerformanceRoleEnumValues;
  static VendorTeamPerformanceRoleEnum valueOf(String name) => _$vendorTeamPerformanceRoleEnumValueOf(name);
}

class VendorTeamPerformanceTimezoneEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Asia/Manila')
  static const VendorTeamPerformanceTimezoneEnum asiaSlashManila = _$vendorTeamPerformanceTimezoneEnum_asiaSlashManila;

  static Serializer<VendorTeamPerformanceTimezoneEnum> get serializer => _$vendorTeamPerformanceTimezoneEnumSerializer;

  const VendorTeamPerformanceTimezoneEnum._(String name): super(name);

  static BuiltSet<VendorTeamPerformanceTimezoneEnum> get values => _$vendorTeamPerformanceTimezoneEnumValues;
  static VendorTeamPerformanceTimezoneEnum valueOf(String name) => _$vendorTeamPerformanceTimezoneEnumValueOf(name);
}

