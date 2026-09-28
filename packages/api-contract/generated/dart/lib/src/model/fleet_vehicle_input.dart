//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fleet_vehicle_input.g.dart';

/// FleetVehicleInput
///
/// Properties:
/// * [id] - Omit for a new configuration.
/// * [lockVersion] - Required with id.
/// * [removed] - True removes a saved configuration from future use; its versions and accepted snapshots are kept.
/// * [vehicleCategory]
/// * [vehicleType]
/// * [customTypeName]
/// * [name]
/// * [brand]
/// * [imageFileId]
/// * [numberAvailable]
/// * [capacityKg] - Payload in kilograms
/// * [cargoLengthM]
/// * [cargoWidthM]
/// * [cargoHeightM]
/// * [mixerCapacityM3] - Required for a Concrete Mixer Truck / Transit Mixer; cargo dimensions are then not applicable.
/// * [heavyClassification]
/// * [active]
/// * [available]
/// * [baseFeeCentavos]
/// * [perKmCentavos]
/// * [maximumDistanceKm]
@BuiltValue()
abstract class FleetVehicleInput implements Built<FleetVehicleInput, FleetVehicleInputBuilder> {
  /// Omit for a new configuration.
  @BuiltValueField(wireName: r'id')
  String? get id;

  /// Required with id.
  @BuiltValueField(wireName: r'lock_version')
  int? get lockVersion;

  /// True removes a saved configuration from future use; its versions and accepted snapshots are kept.
  @BuiltValueField(wireName: r'removed')
  bool? get removed;

  @BuiltValueField(wireName: r'vehicle_category')
  FleetVehicleInputVehicleCategoryEnum? get vehicleCategory;
  // enum vehicleCategoryEnum {  MOTORCYCLE,  PICKUP,  VAN,  TRUCK,  ,  };

  @BuiltValueField(wireName: r'vehicle_type')
  String? get vehicleType;

  @BuiltValueField(wireName: r'custom_type_name')
  String? get customTypeName;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'brand')
  String? get brand;

  @BuiltValueField(wireName: r'image_file_id')
  String? get imageFileId;

  @BuiltValueField(wireName: r'number_available')
  int? get numberAvailable;

  /// Payload in kilograms
  @BuiltValueField(wireName: r'capacity_kg')
  num? get capacityKg;

  @BuiltValueField(wireName: r'cargo_length_m')
  num? get cargoLengthM;

  @BuiltValueField(wireName: r'cargo_width_m')
  num? get cargoWidthM;

  @BuiltValueField(wireName: r'cargo_height_m')
  num? get cargoHeightM;

  /// Required for a Concrete Mixer Truck / Transit Mixer; cargo dimensions are then not applicable.
  @BuiltValueField(wireName: r'mixer_capacity_m3')
  num? get mixerCapacityM3;

  @BuiltValueField(wireName: r'heavy_classification')
  FleetVehicleInputHeavyClassificationEnum? get heavyClassification;
  // enum heavyClassificationEnum {  HEAVY,  NOT_HEAVY,  ,  };

  @BuiltValueField(wireName: r'active')
  bool? get active;

  @BuiltValueField(wireName: r'available')
  bool? get available;

  @BuiltValueField(wireName: r'base_fee_centavos')
  int? get baseFeeCentavos;

  @BuiltValueField(wireName: r'per_km_centavos')
  int? get perKmCentavos;

  @BuiltValueField(wireName: r'maximum_distance_km')
  int? get maximumDistanceKm;

  FleetVehicleInput._();

  factory FleetVehicleInput([void updates(FleetVehicleInputBuilder b)]) = _$FleetVehicleInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FleetVehicleInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FleetVehicleInput> get serializer => _$FleetVehicleInputSerializer();
}

class _$FleetVehicleInputSerializer implements PrimitiveSerializer<FleetVehicleInput> {
  @override
  final Iterable<Type> types = const [FleetVehicleInput, _$FleetVehicleInput];

  @override
  final String wireName = r'FleetVehicleInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FleetVehicleInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.lockVersion != null) {
      yield r'lock_version';
      yield serializers.serialize(
        object.lockVersion,
        specifiedType: const FullType(int),
      );
    }
    if (object.removed != null) {
      yield r'removed';
      yield serializers.serialize(
        object.removed,
        specifiedType: const FullType(bool),
      );
    }
    if (object.vehicleCategory != null) {
      yield r'vehicle_category';
      yield serializers.serialize(
        object.vehicleCategory,
        specifiedType: const FullType.nullable(FleetVehicleInputVehicleCategoryEnum),
      );
    }
    if (object.vehicleType != null) {
      yield r'vehicle_type';
      yield serializers.serialize(
        object.vehicleType,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.customTypeName != null) {
      yield r'custom_type_name';
      yield serializers.serialize(
        object.customTypeName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    if (object.numberAvailable != null) {
      yield r'number_available';
      yield serializers.serialize(
        object.numberAvailable,
        specifiedType: const FullType(int),
      );
    }
    if (object.capacityKg != null) {
      yield r'capacity_kg';
      yield serializers.serialize(
        object.capacityKg,
        specifiedType: const FullType(num),
      );
    }
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
    if (object.heavyClassification != null) {
      yield r'heavy_classification';
      yield serializers.serialize(
        object.heavyClassification,
        specifiedType: const FullType.nullable(FleetVehicleInputHeavyClassificationEnum),
      );
    }
    if (object.active != null) {
      yield r'active';
      yield serializers.serialize(
        object.active,
        specifiedType: const FullType(bool),
      );
    }
    if (object.available != null) {
      yield r'available';
      yield serializers.serialize(
        object.available,
        specifiedType: const FullType(bool),
      );
    }
    if (object.baseFeeCentavos != null) {
      yield r'base_fee_centavos';
      yield serializers.serialize(
        object.baseFeeCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.perKmCentavos != null) {
      yield r'per_km_centavos';
      yield serializers.serialize(
        object.perKmCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.maximumDistanceKm != null) {
      yield r'maximum_distance_km';
      yield serializers.serialize(
        object.maximumDistanceKm,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FleetVehicleInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FleetVehicleInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.lockVersion = valueDes;
          break;
        case r'removed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.removed = valueDes;
          break;
        case r'vehicle_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FleetVehicleInputVehicleCategoryEnum),
          ) as FleetVehicleInputVehicleCategoryEnum?;
          if (valueDes == null) continue;
          result.vehicleCategory = valueDes;
          break;
        case r'vehicle_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.numberAvailable = valueDes;
          break;
        case r'capacity_kg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(FleetVehicleInputHeavyClassificationEnum),
          ) as FleetVehicleInputHeavyClassificationEnum?;
          if (valueDes == null) continue;
          result.heavyClassification = valueDes;
          break;
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.active = valueDes;
          break;
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.available = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FleetVehicleInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FleetVehicleInputBuilder();
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


class FleetVehicleInputVehicleCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MOTORCYCLE')
  static const FleetVehicleInputVehicleCategoryEnum MOTORCYCLE = _$fleetVehicleInputVehicleCategoryEnum_MOTORCYCLE;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const FleetVehicleInputVehicleCategoryEnum PICKUP = _$fleetVehicleInputVehicleCategoryEnum_PICKUP;
  @BuiltValueEnumConst(wireName: r'VAN')
  static const FleetVehicleInputVehicleCategoryEnum VAN = _$fleetVehicleInputVehicleCategoryEnum_VAN;
  @BuiltValueEnumConst(wireName: r'TRUCK')
  static const FleetVehicleInputVehicleCategoryEnum TRUCK = _$fleetVehicleInputVehicleCategoryEnum_TRUCK;

  static Serializer<FleetVehicleInputVehicleCategoryEnum> get serializer => _$fleetVehicleInputVehicleCategoryEnumSerializer;

  const FleetVehicleInputVehicleCategoryEnum._(String name): super(name);

  static BuiltSet<FleetVehicleInputVehicleCategoryEnum> get values => _$fleetVehicleInputVehicleCategoryEnumValues;
  static FleetVehicleInputVehicleCategoryEnum valueOf(String name) => _$fleetVehicleInputVehicleCategoryEnumValueOf(name);
}

class FleetVehicleInputHeavyClassificationEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'HEAVY')
  static const FleetVehicleInputHeavyClassificationEnum HEAVY = _$fleetVehicleInputHeavyClassificationEnum_HEAVY;
  @BuiltValueEnumConst(wireName: r'NOT_HEAVY')
  static const FleetVehicleInputHeavyClassificationEnum NOT_HEAVY = _$fleetVehicleInputHeavyClassificationEnum_NOT_HEAVY;

  static Serializer<FleetVehicleInputHeavyClassificationEnum> get serializer => _$fleetVehicleInputHeavyClassificationEnumSerializer;

  const FleetVehicleInputHeavyClassificationEnum._(String name): super(name);

  static BuiltSet<FleetVehicleInputHeavyClassificationEnum> get values => _$fleetVehicleInputHeavyClassificationEnumValues;
  static FleetVehicleInputHeavyClassificationEnum valueOf(String name) => _$fleetVehicleInputHeavyClassificationEnumValueOf(name);
}

