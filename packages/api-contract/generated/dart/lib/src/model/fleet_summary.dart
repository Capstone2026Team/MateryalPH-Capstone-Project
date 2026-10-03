//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fleet_summary.g.dart';

/// Saved fleet counts for the current Vendor organization. Unit totals use number_available, not configuration row counts. Delivery assignments use immutable accepted snapshots on orders currently OUT_FOR_DELIVERY, including subsequently disabled or removed configurations; they are not unique physical vehicles or trip counts and do not reduce manually configured availability.
///
/// Properties:
/// * [configurations] - Saved configurations excluding removed records.
/// * [totalVehicles] - Vehicle units in saved nonremoved configurations.
/// * [activeVehicles] - Vehicle units in enabled nonremoved configurations.
/// * [availableVehicles] - Vehicle units in enabled nonremoved configurations marked available. Does not imply eligibility or absence of delivery assignments.
/// * [outForDeliveryVehicleAssignments] - Sum of number_of_vehicles per confirmed snapshot entry on this Vendor's DELIVERY orders with order_state OUT_FOR_DELIVERY. Repeated assignments count separately.
/// * [outForDeliveryOrders] - Distinct OUT_FOR_DELIVERY orders contributing confirmed vehicle assignments.
@BuiltValue()
abstract class FleetSummary implements Built<FleetSummary, FleetSummaryBuilder> {
  /// Saved configurations excluding removed records.
  @BuiltValueField(wireName: r'configurations')
  int get configurations;

  /// Vehicle units in saved nonremoved configurations.
  @BuiltValueField(wireName: r'total_vehicles')
  int get totalVehicles;

  /// Vehicle units in enabled nonremoved configurations.
  @BuiltValueField(wireName: r'active_vehicles')
  int get activeVehicles;

  /// Vehicle units in enabled nonremoved configurations marked available. Does not imply eligibility or absence of delivery assignments.
  @BuiltValueField(wireName: r'available_vehicles')
  int get availableVehicles;

  /// Sum of number_of_vehicles per confirmed snapshot entry on this Vendor's DELIVERY orders with order_state OUT_FOR_DELIVERY. Repeated assignments count separately.
  @BuiltValueField(wireName: r'out_for_delivery_vehicle_assignments')
  int get outForDeliveryVehicleAssignments;

  /// Distinct OUT_FOR_DELIVERY orders contributing confirmed vehicle assignments.
  @BuiltValueField(wireName: r'out_for_delivery_orders')
  int get outForDeliveryOrders;

  FleetSummary._();

  factory FleetSummary([void updates(FleetSummaryBuilder b)]) = _$FleetSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FleetSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FleetSummary> get serializer => _$FleetSummarySerializer();
}

class _$FleetSummarySerializer implements PrimitiveSerializer<FleetSummary> {
  @override
  final Iterable<Type> types = const [FleetSummary, _$FleetSummary];

  @override
  final String wireName = r'FleetSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FleetSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'configurations';
    yield serializers.serialize(
      object.configurations,
      specifiedType: const FullType(int),
    );
    yield r'total_vehicles';
    yield serializers.serialize(
      object.totalVehicles,
      specifiedType: const FullType(int),
    );
    yield r'active_vehicles';
    yield serializers.serialize(
      object.activeVehicles,
      specifiedType: const FullType(int),
    );
    yield r'available_vehicles';
    yield serializers.serialize(
      object.availableVehicles,
      specifiedType: const FullType(int),
    );
    yield r'out_for_delivery_vehicle_assignments';
    yield serializers.serialize(
      object.outForDeliveryVehicleAssignments,
      specifiedType: const FullType(int),
    );
    yield r'out_for_delivery_orders';
    yield serializers.serialize(
      object.outForDeliveryOrders,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FleetSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FleetSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'configurations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.configurations = valueDes;
          break;
        case r'total_vehicles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalVehicles = valueDes;
          break;
        case r'active_vehicles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.activeVehicles = valueDes;
          break;
        case r'available_vehicles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.availableVehicles = valueDes;
          break;
        case r'out_for_delivery_vehicle_assignments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.outForDeliveryVehicleAssignments = valueDes;
          break;
        case r'out_for_delivery_orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.outForDeliveryOrders = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FleetSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FleetSummaryBuilder();
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


