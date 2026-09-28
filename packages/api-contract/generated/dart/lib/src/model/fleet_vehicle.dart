//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/fleet_vehicle_eligibility.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fleet_vehicle.g.dart';

/// FleetVehicle
///
/// Properties:
/// * [id]
/// * [lockVersion]
/// * [configurationVersion]
/// * [vehicleCategory]
/// * [vehicleType]
/// * [customTypeName]
/// * [name]
/// * [brand]
/// * [imageFileId]
/// * [numberAvailable]
/// * [capacityKg]
/// * [cargoLengthM]
/// * [cargoWidthM]
/// * [cargoHeightM]
/// * [mixerCapacityM3]
/// * [heavyClassification]
/// * [active] - Enabled for future proposals.
/// * [available] - Temporarily available or unavailable.
/// * [rateVersion]
/// * [baseFeeCentavos]
/// * [perKmCentavos]
/// * [maximumDistanceKm]
/// * [eligibility]
/// * [updatedAt]
@BuiltValue()
abstract class FleetVehicle implements Built<FleetVehicle, FleetVehicleBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'configuration_version')
  int get configurationVersion;

  @BuiltValueField(wireName: r'vehicle_category')
  FleetVehicleVehicleCategoryEnum? get vehicleCategory;
  // enum vehicleCategoryEnum {  MOTORCYCLE,  PICKUP,  VAN,  TRUCK,  ,  };

  @BuiltValueField(wireName: r'vehicle_type')
  String get vehicleType;

  @BuiltValueField(wireName: r'custom_type_name')
  String? get customTypeName;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'brand')
  String? get brand;

  @BuiltValueField(wireName: r'image_file_id')
  String? get imageFileId;

  @BuiltValueField(wireName: r'number_available')
  int get numberAvailable;

  @BuiltValueField(wireName: r'capacity_kg')
  num get capacityKg;

  @BuiltValueField(wireName: r'cargo_length_m')
  num? get cargoLengthM;

  @BuiltValueField(wireName: r'cargo_width_m')
  num? get cargoWidthM;

  @BuiltValueField(wireName: r'cargo_height_m')
  num? get cargoHeightM;

  @BuiltValueField(wireName: r'mixer_capacity_m3')
  num? get mixerCapacityM3;

  @BuiltValueField(wireName: r'heavy_classification')
  FleetVehicleHeavyClassificationEnum? get heavyClassification;
  // enum heavyClassificationEnum {  HEAVY,  NOT_HEAVY,  ,  };

  /// Enabled for future proposals.
  @BuiltValueField(wireName: r'active')
  bool get active;

  /// Temporarily available or unavailable.
  @BuiltValueField(wireName: r'available')
  bool get available;

  @BuiltValueField(wireName: r'rate_version')
  int? get rateVersion;

  @BuiltValueField(wireName: r'base_fee_centavos')
  int? get baseFeeCentavos;

  @BuiltValueField(wireName: r'per_km_centavos')
  int? get perKmCentavos;

  @BuiltValueField(wireName: r'maximum_distance_km')
  int? get maximumDistanceKm;

  @BuiltValueField(wireName: r'eligibility')
  FleetVehicleEligibility get eligibility;

  @BuiltValueField(wireName: r'updated_at')
  String? get updatedAt;

  FleetVehicle._();

  factory FleetVehicle([void updates(FleetVehicleBuilder b)]) = _$FleetVehicle;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FleetVehicleBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FleetVehicle> get serializer => _$FleetVehicleSerializer();
}

class _$FleetVehicleSerializer implements PrimitiveSerializer<FleetVehicle> {
  @override
  final Iterable<Type> types = const [FleetVehicle, _$FleetVehicle];

  @override
  final String wireName = r'FleetVehicle';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FleetVehicle object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'configuration_version';
    yield serializers.serialize(
      object.configurationVersion,
      specifiedType: const FullType(int),
    );
    yield r'vehicle_category';
    yield object.vehicleCategory == null ? null : serializers.serialize(
      object.vehicleCategory,
      specifiedType: const FullType.nullable(FleetVehicleVehicleCategoryEnum),
    );
    yield r'vehicle_type';
    yield serializers.serialize(
      object.vehicleType,
      specifiedType: const FullType(String),
    );
    if (object.customTypeName != null) {
      yield r'custom_type_name';
      yield serializers.serialize(
        object.customTypeName,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.brand != null) {
      yield r'brand';
      yield serializers.serialize(
        object.brand,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.imageFileId != null) {
      yield r'image_file_id';
      yield serializers.serialize(
        object.imageFileId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'number_available';
    yield serializers.serialize(
      object.numberAvailable,
      specifiedType: const FullType(int),
    );
    yield r'capacity_kg';
    yield serializers.serialize(
      object.capacityKg,
      specifiedType: const FullType(num),
    );
    if (object.cargoLengthM != null) {
      yield r'cargo_length_m';
      yield serializers.serialize(
        object.cargoLengthM,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.cargoWidthM != null) {
      yield r'cargo_width_m';
      yield serializers.serialize(
        object.cargoWidthM,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.cargoHeightM != null) {
      yield r'cargo_height_m';
      yield serializers.serialize(
        object.cargoHeightM,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.mixerCapacityM3 != null) {
      yield r'mixer_capacity_m3';
      yield serializers.serialize(
        object.mixerCapacityM3,
        specifiedType: const FullType.nullable(num),
      );
    }
    yield r'heavy_classification';
    yield object.heavyClassification == null ? null : serializers.serialize(
      object.heavyClassification,
      specifiedType: const FullType.nullable(FleetVehicleHeavyClassificationEnum),
    );
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(bool),
    );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    if (object.rateVersion != null) {
      yield r'rate_version';
      yield serializers.serialize(
        object.rateVersion,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.baseFeeCentavos != null) {
      yield r'base_fee_centavos';
      yield serializers.serialize(
        object.baseFeeCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.perKmCentavos != null) {
      yield r'per_km_centavos';
      yield serializers.serialize(
        object.perKmCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.maximumDistanceKm != null) {
      yield r'maximum_distance_km';
      yield serializers.serialize(
        object.maximumDistanceKm,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'eligibility';
    yield serializers.serialize(
      object.eligibility,
      specifiedType: const FullType(FleetVehicleEligibility),
    );
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FleetVehicle object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FleetVehicleBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'configuration_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.configurationVersion = valueDes;
          break;
        case r'vehicle_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FleetVehicleVehicleCategoryEnum),
          ) as FleetVehicleVehicleCategoryEnum?;
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'brand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.brand = valueDes;
          break;
        case r'image_file_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.imageFileId = valueDes;
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
            specifiedType: const FullType(num),
          ) as num;
          result.capacityKg = valueDes;
          break;
        case r'cargo_length_m':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.cargoLengthM = valueDes;
          break;
        case r'cargo_width_m':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.cargoWidthM = valueDes;
          break;
        case r'cargo_height_m':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.cargoHeightM = valueDes;
          break;
        case r'mixer_capacity_m3':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.mixerCapacityM3 = valueDes;
          break;
        case r'heavy_classification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FleetVehicleHeavyClassificationEnum),
          ) as FleetVehicleHeavyClassificationEnum?;
          if (valueDes == null) continue;
          result.heavyClassification = valueDes;
          break;
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.active = valueDes;
          break;
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        case r'rate_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.rateVersion = valueDes;
          break;
        case r'base_fee_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.baseFeeCentavos = valueDes;
          break;
        case r'per_km_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.perKmCentavos = valueDes;
          break;
        case r'maximum_distance_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maximumDistanceKm = valueDes;
          break;
        case r'eligibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FleetVehicleEligibility),
          ) as FleetVehicleEligibility;
          result.eligibility.replace(valueDes);
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FleetVehicle deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FleetVehicleBuilder();
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


class FleetVehicleVehicleCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MOTORCYCLE')
  static const FleetVehicleVehicleCategoryEnum MOTORCYCLE = _$fleetVehicleVehicleCategoryEnum_MOTORCYCLE;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const FleetVehicleVehicleCategoryEnum PICKUP = _$fleetVehicleVehicleCategoryEnum_PICKUP;
  @BuiltValueEnumConst(wireName: r'VAN')
  static const FleetVehicleVehicleCategoryEnum VAN = _$fleetVehicleVehicleCategoryEnum_VAN;
  @BuiltValueEnumConst(wireName: r'TRUCK')
  static const FleetVehicleVehicleCategoryEnum TRUCK = _$fleetVehicleVehicleCategoryEnum_TRUCK;

  static Serializer<FleetVehicleVehicleCategoryEnum> get serializer => _$fleetVehicleVehicleCategoryEnumSerializer;

  const FleetVehicleVehicleCategoryEnum._(String name): super(name);

  static BuiltSet<FleetVehicleVehicleCategoryEnum> get values => _$fleetVehicleVehicleCategoryEnumValues;
  static FleetVehicleVehicleCategoryEnum valueOf(String name) => _$fleetVehicleVehicleCategoryEnumValueOf(name);
}

class FleetVehicleHeavyClassificationEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'HEAVY')
  static const FleetVehicleHeavyClassificationEnum HEAVY = _$fleetVehicleHeavyClassificationEnum_HEAVY;
  @BuiltValueEnumConst(wireName: r'NOT_HEAVY')
  static const FleetVehicleHeavyClassificationEnum NOT_HEAVY = _$fleetVehicleHeavyClassificationEnum_NOT_HEAVY;

  static Serializer<FleetVehicleHeavyClassificationEnum> get serializer => _$fleetVehicleHeavyClassificationEnumSerializer;

  const FleetVehicleHeavyClassificationEnum._(String name): super(name);

  static BuiltSet<FleetVehicleHeavyClassificationEnum> get values => _$fleetVehicleHeavyClassificationEnumValues;
  static FleetVehicleHeavyClassificationEnum valueOf(String name) => _$fleetVehicleHeavyClassificationEnumValueOf(name);
}

