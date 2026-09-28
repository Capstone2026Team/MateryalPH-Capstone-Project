//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fleet_vehicle_eligibility.g.dart';

/// FleetVehicleEligibility
///
/// Properties:
/// * [eligible]
/// * [reasons]
@BuiltValue()
abstract class FleetVehicleEligibility implements Built<FleetVehicleEligibility, FleetVehicleEligibilityBuilder> {
  @BuiltValueField(wireName: r'eligible')
  bool get eligible;

  @BuiltValueField(wireName: r'reasons')
  BuiltList<FleetVehicleEligibilityReasonsEnum> get reasons;
  // enum reasonsEnum {  DELIVERY_NOT_ENABLED,  VEHICLE_DISABLED,  VEHICLE_UNAVAILABLE,  VEHICLE_INCOMPLETE,  IMAGE_MISSING,  RATE_MISSING,  };

  FleetVehicleEligibility._();

  factory FleetVehicleEligibility([void updates(FleetVehicleEligibilityBuilder b)]) = _$FleetVehicleEligibility;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FleetVehicleEligibilityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FleetVehicleEligibility> get serializer => _$FleetVehicleEligibilitySerializer();
}

class _$FleetVehicleEligibilitySerializer implements PrimitiveSerializer<FleetVehicleEligibility> {
  @override
  final Iterable<Type> types = const [FleetVehicleEligibility, _$FleetVehicleEligibility];

  @override
  final String wireName = r'FleetVehicleEligibility';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FleetVehicleEligibility object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'eligible';
    yield serializers.serialize(
      object.eligible,
      specifiedType: const FullType(bool),
    );
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(BuiltList, [FullType(FleetVehicleEligibilityReasonsEnum)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FleetVehicleEligibility object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FleetVehicleEligibilityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'eligible':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.eligible = valueDes;
          break;
        case r'reasons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FleetVehicleEligibilityReasonsEnum)]),
          ) as BuiltList<FleetVehicleEligibilityReasonsEnum>;
          result.reasons.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FleetVehicleEligibility deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FleetVehicleEligibilityBuilder();
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


class FleetVehicleEligibilityReasonsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY_NOT_ENABLED')
  static const FleetVehicleEligibilityReasonsEnum DELIVERY_NOT_ENABLED = _$fleetVehicleEligibilityReasonsEnum_DELIVERY_NOT_ENABLED;
  @BuiltValueEnumConst(wireName: r'VEHICLE_DISABLED')
  static const FleetVehicleEligibilityReasonsEnum VEHICLE_DISABLED = _$fleetVehicleEligibilityReasonsEnum_VEHICLE_DISABLED;
  @BuiltValueEnumConst(wireName: r'VEHICLE_UNAVAILABLE')
  static const FleetVehicleEligibilityReasonsEnum VEHICLE_UNAVAILABLE = _$fleetVehicleEligibilityReasonsEnum_VEHICLE_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'VEHICLE_INCOMPLETE')
  static const FleetVehicleEligibilityReasonsEnum VEHICLE_INCOMPLETE = _$fleetVehicleEligibilityReasonsEnum_VEHICLE_INCOMPLETE;
  @BuiltValueEnumConst(wireName: r'IMAGE_MISSING')
  static const FleetVehicleEligibilityReasonsEnum IMAGE_MISSING = _$fleetVehicleEligibilityReasonsEnum_IMAGE_MISSING;
  @BuiltValueEnumConst(wireName: r'RATE_MISSING')
  static const FleetVehicleEligibilityReasonsEnum RATE_MISSING = _$fleetVehicleEligibilityReasonsEnum_RATE_MISSING;

  static Serializer<FleetVehicleEligibilityReasonsEnum> get serializer => _$fleetVehicleEligibilityReasonsEnumSerializer;

  const FleetVehicleEligibilityReasonsEnum._(String name): super(name);

  static BuiltSet<FleetVehicleEligibilityReasonsEnum> get values => _$fleetVehicleEligibilityReasonsEnumValues;
  static FleetVehicleEligibilityReasonsEnum valueOf(String name) => _$fleetVehicleEligibilityReasonsEnumValueOf(name);
}

