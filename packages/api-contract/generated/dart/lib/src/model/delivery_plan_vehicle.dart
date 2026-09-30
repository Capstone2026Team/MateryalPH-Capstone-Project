//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_plan_vehicle.g.dart';

/// DeliveryPlanVehicle
///
/// Properties:
/// * [vehicleId]
/// * [name]
/// * [vehicleCategory]
/// * [vehicleType]
/// * [customTypeName]
/// * [brand]
/// * [numberAvailable]
/// * [capacityKg]
/// * [mixerCapacityM3]
/// * [heavyClassification]
/// * [maximumDistanceKm]
/// * [baseFeeCentavos]
/// * [perKmCentavos]
/// * [perTripCentavos]
/// * [withinRange]
/// * [rateVersion]
/// * [configurationVersion]
/// * [numberOfVehicles]
/// * [totalVehicleTrips]
/// * [estimatedChargeCentavos]
/// * [limitingFactor]
@BuiltValue()
abstract class DeliveryPlanVehicle implements Built<DeliveryPlanVehicle, DeliveryPlanVehicleBuilder> {
  @BuiltValueField(wireName: r'vehicle_id')
  String get vehicleId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'vehicle_category')
  String? get vehicleCategory;

  @BuiltValueField(wireName: r'vehicle_type')
  String get vehicleType;

  @BuiltValueField(wireName: r'custom_type_name')
  String? get customTypeName;

  @BuiltValueField(wireName: r'brand')
  String? get brand;

  @BuiltValueField(wireName: r'number_available')
  int get numberAvailable;

  @BuiltValueField(wireName: r'capacity_kg')
  String get capacityKg;

  @BuiltValueField(wireName: r'mixer_capacity_m3')
  String? get mixerCapacityM3;

  @BuiltValueField(wireName: r'heavy_classification')
  String get heavyClassification;

  @BuiltValueField(wireName: r'maximum_distance_km')
  int get maximumDistanceKm;

  @BuiltValueField(wireName: r'base_fee_centavos')
  int get baseFeeCentavos;

  @BuiltValueField(wireName: r'per_km_centavos')
  int get perKmCentavos;

  @BuiltValueField(wireName: r'per_trip_centavos')
  int get perTripCentavos;

  @BuiltValueField(wireName: r'within_range')
  bool get withinRange;

  @BuiltValueField(wireName: r'rate_version')
  int get rateVersion;

  @BuiltValueField(wireName: r'configuration_version')
  int get configurationVersion;

  @BuiltValueField(wireName: r'number_of_vehicles')
  int? get numberOfVehicles;

  @BuiltValueField(wireName: r'total_vehicle_trips')
  int? get totalVehicleTrips;

  @BuiltValueField(wireName: r'estimated_charge_centavos')
  int? get estimatedChargeCentavos;

  @BuiltValueField(wireName: r'limiting_factor')
  String? get limitingFactor;

  DeliveryPlanVehicle._();

  factory DeliveryPlanVehicle([void updates(DeliveryPlanVehicleBuilder b)]) = _$DeliveryPlanVehicle;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryPlanVehicleBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryPlanVehicle> get serializer => _$DeliveryPlanVehicleSerializer();
}

class _$DeliveryPlanVehicleSerializer implements PrimitiveSerializer<DeliveryPlanVehicle> {
  @override
  final Iterable<Type> types = const [DeliveryPlanVehicle, _$DeliveryPlanVehicle];

  @override
  final String wireName = r'DeliveryPlanVehicle';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryPlanVehicle object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vehicle_id';
    yield serializers.serialize(
      object.vehicleId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'vehicle_category';
    yield object.vehicleCategory == null ? null : serializers.serialize(
      object.vehicleCategory,
      specifiedType: const FullType.nullable(String),
    );
    yield r'vehicle_type';
    yield serializers.serialize(
      object.vehicleType,
      specifiedType: const FullType(String),
    );
    yield r'custom_type_name';
    yield object.customTypeName == null ? null : serializers.serialize(
      object.customTypeName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'brand';
    yield object.brand == null ? null : serializers.serialize(
      object.brand,
      specifiedType: const FullType.nullable(String),
    );
    yield r'number_available';
    yield serializers.serialize(
      object.numberAvailable,
      specifiedType: const FullType(int),
    );
    yield r'capacity_kg';
    yield serializers.serialize(
      object.capacityKg,
      specifiedType: const FullType(String),
    );
    yield r'mixer_capacity_m3';
    yield object.mixerCapacityM3 == null ? null : serializers.serialize(
      object.mixerCapacityM3,
      specifiedType: const FullType.nullable(String),
    );
    yield r'heavy_classification';
    yield serializers.serialize(
      object.heavyClassification,
      specifiedType: const FullType(String),
    );
    yield r'maximum_distance_km';
    yield serializers.serialize(
      object.maximumDistanceKm,
      specifiedType: const FullType(int),
    );
    yield r'base_fee_centavos';
    yield serializers.serialize(
      object.baseFeeCentavos,
      specifiedType: const FullType(int),
    );
    yield r'per_km_centavos';
    yield serializers.serialize(
      object.perKmCentavos,
      specifiedType: const FullType(int),
    );
    yield r'per_trip_centavos';
    yield serializers.serialize(
      object.perTripCentavos,
      specifiedType: const FullType(int),
    );
    yield r'within_range';
    yield serializers.serialize(
      object.withinRange,
      specifiedType: const FullType(bool),
    );
    yield r'rate_version';
    yield serializers.serialize(
      object.rateVersion,
      specifiedType: const FullType(int),
    );
    yield r'configuration_version';
    yield serializers.serialize(
      object.configurationVersion,
      specifiedType: const FullType(int),
    );
    if (object.numberOfVehicles != null) {
      yield r'number_of_vehicles';
      yield serializers.serialize(
        object.numberOfVehicles,
        specifiedType: const FullType(int),
      );
    }
    if (object.totalVehicleTrips != null) {
      yield r'total_vehicle_trips';
      yield serializers.serialize(
        object.totalVehicleTrips,
        specifiedType: const FullType(int),
      );
    }
    if (object.estimatedChargeCentavos != null) {
      yield r'estimated_charge_centavos';
      yield serializers.serialize(
        object.estimatedChargeCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.limitingFactor != null) {
      yield r'limiting_factor';
      yield serializers.serialize(
        object.limitingFactor,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryPlanVehicle object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryPlanVehicleBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vehicle_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vehicleId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'vehicle_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehicleCategory = valueDes;
          break;
        case r'vehicle_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vehicleType = valueDes;
          break;
        case r'custom_type_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.customTypeName = valueDes;
          break;
        case r'brand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.brand = valueDes;
          break;
        case r'number_available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.numberAvailable = valueDes;
          break;
        case r'capacity_kg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.capacityKg = valueDes;
          break;
        case r'mixer_capacity_m3':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.mixerCapacityM3 = valueDes;
          break;
        case r'heavy_classification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.heavyClassification = valueDes;
          break;
        case r'maximum_distance_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maximumDistanceKm = valueDes;
          break;
        case r'base_fee_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.baseFeeCentavos = valueDes;
          break;
        case r'per_km_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.perKmCentavos = valueDes;
          break;
        case r'per_trip_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.perTripCentavos = valueDes;
          break;
        case r'within_range':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.withinRange = valueDes;
          break;
        case r'rate_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rateVersion = valueDes;
          break;
        case r'configuration_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.configurationVersion = valueDes;
          break;
        case r'number_of_vehicles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.numberOfVehicles = valueDes;
          break;
        case r'total_vehicle_trips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.totalVehicleTrips = valueDes;
          break;
        case r'estimated_charge_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.estimatedChargeCentavos = valueDes;
          break;
        case r'limiting_factor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.limitingFactor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryPlanVehicle deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryPlanVehicleBuilder();
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


