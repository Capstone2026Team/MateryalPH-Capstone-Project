//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/delivery_plan_vehicle.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/delivery_plan_group.dart';
import 'package:materyalph_api_client/src/model/delivery_plan_route.dart';
import 'package:materyalph_api_client/src/model/delivery_plan_endpoint.dart';
import 'package:materyalph_api_client/src/model/delivery_plan_formula.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_plan.g.dart';

/// DeliveryPlan
///
/// Properties:
/// * [advisory]
/// * [status]
/// * [reason]
/// * [route]
/// * [endpoint]
/// * [groups]
/// * [eligibleVehicles]
/// * [feeFormula]
/// * [notice]
@BuiltValue()
abstract class DeliveryPlan implements Built<DeliveryPlan, DeliveryPlanBuilder> {
  @BuiltValueField(wireName: r'advisory')
  DeliveryPlanAdvisoryEnum get advisory;
  // enum advisoryEnum {  true,  };

  @BuiltValueField(wireName: r'status')
  DeliveryPlanStatusEnum get status;
  // enum statusEnum {  CANDIDATES_AVAILABLE,  MANUAL_REVIEW_REQUIRED,  NO_ELIGIBLE_VEHICLE,  ACCESS_NOT_CONFIRMED,  ROUTE_REQUIRED,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'route')
  DeliveryPlanRoute get route;

  @BuiltValueField(wireName: r'endpoint')
  DeliveryPlanEndpoint get endpoint;

  @BuiltValueField(wireName: r'groups')
  BuiltList<DeliveryPlanGroup> get groups;

  @BuiltValueField(wireName: r'eligible_vehicles')
  BuiltList<DeliveryPlanVehicle> get eligibleVehicles;

  @BuiltValueField(wireName: r'fee_formula')
  DeliveryPlanFormula get feeFormula;

  @BuiltValueField(wireName: r'notice')
  String get notice;

  DeliveryPlan._();

  factory DeliveryPlan([void updates(DeliveryPlanBuilder b)]) = _$DeliveryPlan;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryPlanBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryPlan> get serializer => _$DeliveryPlanSerializer();
}

class _$DeliveryPlanSerializer implements PrimitiveSerializer<DeliveryPlan> {
  @override
  final Iterable<Type> types = const [DeliveryPlan, _$DeliveryPlan];

  @override
  final String wireName = r'DeliveryPlan';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryPlan object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'advisory';
    yield serializers.serialize(
      object.advisory,
      specifiedType: const FullType(DeliveryPlanAdvisoryEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DeliveryPlanStatusEnum),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'route';
    yield serializers.serialize(
      object.route,
      specifiedType: const FullType(DeliveryPlanRoute),
    );
    yield r'endpoint';
    yield serializers.serialize(
      object.endpoint,
      specifiedType: const FullType(DeliveryPlanEndpoint),
    );
    yield r'groups';
    yield serializers.serialize(
      object.groups,
      specifiedType: const FullType(BuiltList, [FullType(DeliveryPlanGroup)]),
    );
    yield r'eligible_vehicles';
    yield serializers.serialize(
      object.eligibleVehicles,
      specifiedType: const FullType(BuiltList, [FullType(DeliveryPlanVehicle)]),
    );
    yield r'fee_formula';
    yield serializers.serialize(
      object.feeFormula,
      specifiedType: const FullType(DeliveryPlanFormula),
    );
    yield r'notice';
    yield serializers.serialize(
      object.notice,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryPlan object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryPlanBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'advisory':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeliveryPlanAdvisoryEnum),
          ) as DeliveryPlanAdvisoryEnum;
          result.advisory = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeliveryPlanStatusEnum),
          ) as DeliveryPlanStatusEnum;
          result.status = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'route':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeliveryPlanRoute),
          ) as DeliveryPlanRoute;
          result.route.replace(valueDes);
          break;
        case r'endpoint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeliveryPlanEndpoint),
          ) as DeliveryPlanEndpoint;
          result.endpoint.replace(valueDes);
          break;
        case r'groups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DeliveryPlanGroup)]),
          ) as BuiltList<DeliveryPlanGroup>;
          result.groups.replace(valueDes);
          break;
        case r'eligible_vehicles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DeliveryPlanVehicle)]),
          ) as BuiltList<DeliveryPlanVehicle>;
          result.eligibleVehicles.replace(valueDes);
          break;
        case r'fee_formula':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeliveryPlanFormula),
          ) as DeliveryPlanFormula;
          result.feeFormula.replace(valueDes);
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.notice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryPlan deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryPlanBuilder();
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


class DeliveryPlanAdvisoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const DeliveryPlanAdvisoryEnum true_ = _$deliveryPlanAdvisoryEnum_true_;

  static Serializer<DeliveryPlanAdvisoryEnum> get serializer => _$deliveryPlanAdvisoryEnumSerializer;

  const DeliveryPlanAdvisoryEnum._(String name): super(name);

  static BuiltSet<DeliveryPlanAdvisoryEnum> get values => _$deliveryPlanAdvisoryEnumValues;
  static DeliveryPlanAdvisoryEnum valueOf(String name) => _$deliveryPlanAdvisoryEnumValueOf(name);
}

class DeliveryPlanStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CANDIDATES_AVAILABLE')
  static const DeliveryPlanStatusEnum CANDIDATES_AVAILABLE = _$deliveryPlanStatusEnum_CANDIDATES_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'MANUAL_REVIEW_REQUIRED')
  static const DeliveryPlanStatusEnum MANUAL_REVIEW_REQUIRED = _$deliveryPlanStatusEnum_MANUAL_REVIEW_REQUIRED;
  @BuiltValueEnumConst(wireName: r'NO_ELIGIBLE_VEHICLE')
  static const DeliveryPlanStatusEnum NO_ELIGIBLE_VEHICLE = _$deliveryPlanStatusEnum_NO_ELIGIBLE_VEHICLE;
  @BuiltValueEnumConst(wireName: r'ACCESS_NOT_CONFIRMED')
  static const DeliveryPlanStatusEnum ACCESS_NOT_CONFIRMED = _$deliveryPlanStatusEnum_ACCESS_NOT_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'ROUTE_REQUIRED')
  static const DeliveryPlanStatusEnum ROUTE_REQUIRED = _$deliveryPlanStatusEnum_ROUTE_REQUIRED;

  static Serializer<DeliveryPlanStatusEnum> get serializer => _$deliveryPlanStatusEnumSerializer;

  const DeliveryPlanStatusEnum._(String name): super(name);

  static BuiltSet<DeliveryPlanStatusEnum> get values => _$deliveryPlanStatusEnumValues;
  static DeliveryPlanStatusEnum valueOf(String name) => _$deliveryPlanStatusEnumValueOf(name);
}

