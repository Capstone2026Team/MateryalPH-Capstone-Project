//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_vehicle.g.dart';

/// VendorVehicle
///
/// Properties:
/// * [id]
/// * [vehicleType]
/// * [vehicleSubtype]
/// * [customVehicleType]
/// * [name]
/// * [numberAvailable]
/// * [capacityKg]
/// * [cargoLengthM]
/// * [cargoWidthM]
/// * [cargoHeightM]
/// * [heavyVehicleClassification]
/// * [baseFeeCentavos]
/// * [perKmCentavos]
/// * [maximumDistanceKm]
@BuiltValue()
abstract class VendorVehicle implements Built<VendorVehicle, VendorVehicleBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'vehicle_type')
  VendorVehicleVehicleTypeEnum get vehicleType;
  // enum vehicleTypeEnum {  MOTORCYCLE,  PICKUP,  VAN,  TRUCK,  CUSTOM,  };

  @BuiltValueField(wireName: r'vehicle_subtype')
  VendorVehicleVehicleSubtypeEnum? get vehicleSubtype;
  // enum vehicleSubtypeEnum {  OPEN_TRUCK,  FLATBED_TRUCK,  WING_VAN,  };

  @BuiltValueField(wireName: r'custom_vehicle_type')
  String? get customVehicleType;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'number_available')
  int get numberAvailable;

  @BuiltValueField(wireName: r'capacity_kg')
  num get capacityKg;

  @BuiltValueField(wireName: r'cargo_length_m')
  num get cargoLengthM;

  @BuiltValueField(wireName: r'cargo_width_m')
  num get cargoWidthM;

  @BuiltValueField(wireName: r'cargo_height_m')
  num get cargoHeightM;

  @BuiltValueField(wireName: r'heavy_vehicle_classification')
  String get heavyVehicleClassification;

  @BuiltValueField(wireName: r'base_fee_centavos')
  int get baseFeeCentavos;

  @BuiltValueField(wireName: r'per_km_centavos')
  int get perKmCentavos;

  @BuiltValueField(wireName: r'maximum_distance_km')
  int get maximumDistanceKm;

  VendorVehicle._();

  factory VendorVehicle([void updates(VendorVehicleBuilder b)]) = _$VendorVehicle;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorVehicleBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorVehicle> get serializer => _$VendorVehicleSerializer();
}

class _$VendorVehicleSerializer implements PrimitiveSerializer<VendorVehicle> {
  @override
  final Iterable<Type> types = const [VendorVehicle, _$VendorVehicle];

  @override
  final String wireName = r'VendorVehicle';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorVehicle object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'vehicle_type';
    yield serializers.serialize(
      object.vehicleType,
      specifiedType: const FullType(VendorVehicleVehicleTypeEnum),
    );
    if (object.vehicleSubtype != null) {
      yield r'vehicle_subtype';
      yield serializers.serialize(
        object.vehicleSubtype,
        specifiedType: const FullType.nullable(VendorVehicleVehicleSubtypeEnum),
      );
    }
    if (object.customVehicleType != null) {
      yield r'custom_vehicle_type';
      yield serializers.serialize(
        object.customVehicleType,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
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
    yield r'cargo_length_m';
    yield serializers.serialize(
      object.cargoLengthM,
      specifiedType: const FullType(num),
    );
    yield r'cargo_width_m';
    yield serializers.serialize(
      object.cargoWidthM,
      specifiedType: const FullType(num),
    );
    yield r'cargo_height_m';
    yield serializers.serialize(
      object.cargoHeightM,
      specifiedType: const FullType(num),
    );
    yield r'heavy_vehicle_classification';
    yield serializers.serialize(
      object.heavyVehicleClassification,
      specifiedType: const FullType(String),
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
    yield r'maximum_distance_km';
    yield serializers.serialize(
      object.maximumDistanceKm,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorVehicle object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorVehicleBuilder result,
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
        case r'vehicle_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorVehicleVehicleTypeEnum),
          ) as VendorVehicleVehicleTypeEnum;
          result.vehicleType = valueDes;
          break;
        case r'vehicle_subtype':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorVehicleVehicleSubtypeEnum),
          ) as VendorVehicleVehicleSubtypeEnum?;
          if (valueDes == null) continue;
          result.vehicleSubtype = valueDes;
          break;
        case r'custom_vehicle_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.customVehicleType = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
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
            specifiedType: const FullType(num),
          ) as num;
          result.cargoLengthM = valueDes;
          break;
        case r'cargo_width_m':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.cargoWidthM = valueDes;
          break;
        case r'cargo_height_m':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.cargoHeightM = valueDes;
          break;
        case r'heavy_vehicle_classification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.heavyVehicleClassification = valueDes;
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
        case r'maximum_distance_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
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
  VendorVehicle deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorVehicleBuilder();
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


class VendorVehicleVehicleTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MOTORCYCLE')
  static const VendorVehicleVehicleTypeEnum MOTORCYCLE = _$vendorVehicleVehicleTypeEnum_MOTORCYCLE;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const VendorVehicleVehicleTypeEnum PICKUP = _$vendorVehicleVehicleTypeEnum_PICKUP;
  @BuiltValueEnumConst(wireName: r'VAN')
  static const VendorVehicleVehicleTypeEnum VAN = _$vendorVehicleVehicleTypeEnum_VAN;
  @BuiltValueEnumConst(wireName: r'TRUCK')
  static const VendorVehicleVehicleTypeEnum TRUCK = _$vendorVehicleVehicleTypeEnum_TRUCK;
  @BuiltValueEnumConst(wireName: r'CUSTOM')
  static const VendorVehicleVehicleTypeEnum CUSTOM = _$vendorVehicleVehicleTypeEnum_CUSTOM;

  static Serializer<VendorVehicleVehicleTypeEnum> get serializer => _$vendorVehicleVehicleTypeEnumSerializer;

  const VendorVehicleVehicleTypeEnum._(String name): super(name);

  static BuiltSet<VendorVehicleVehicleTypeEnum> get values => _$vendorVehicleVehicleTypeEnumValues;
  static VendorVehicleVehicleTypeEnum valueOf(String name) => _$vendorVehicleVehicleTypeEnumValueOf(name);
}

class VendorVehicleVehicleSubtypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN_TRUCK')
  static const VendorVehicleVehicleSubtypeEnum OPEN_TRUCK = _$vendorVehicleVehicleSubtypeEnum_OPEN_TRUCK;
  @BuiltValueEnumConst(wireName: r'FLATBED_TRUCK')
  static const VendorVehicleVehicleSubtypeEnum FLATBED_TRUCK = _$vendorVehicleVehicleSubtypeEnum_FLATBED_TRUCK;
  @BuiltValueEnumConst(wireName: r'WING_VAN')
  static const VendorVehicleVehicleSubtypeEnum WING_VAN = _$vendorVehicleVehicleSubtypeEnum_WING_VAN;

  static Serializer<VendorVehicleVehicleSubtypeEnum> get serializer => _$vendorVehicleVehicleSubtypeEnumSerializer;

  const VendorVehicleVehicleSubtypeEnum._(String name): super(name);

  static BuiltSet<VendorVehicleVehicleSubtypeEnum> get values => _$vendorVehicleVehicleSubtypeEnumValues;
  static VendorVehicleVehicleSubtypeEnum valueOf(String name) => _$vendorVehicleVehicleSubtypeEnumValueOf(name);
}

