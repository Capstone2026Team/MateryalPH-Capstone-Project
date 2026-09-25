//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_setup_draft_vehicles_inner.g.dart';

/// VendorSetupDraftVehiclesInner
///
/// Properties:
/// * [id]
/// * [vehicleCategory] - Separate category and type. Categorized configurations require applicable cargo dimensions or mixer capacity and heavy classification.
/// * [vehicleType]
/// * [customTypeName]
/// * [brand]
/// * [mixerCapacityM3]
/// * [imageFileId] - Clean VEHICLE_IMAGE file owned by this Vendor.
/// * [active] - Disabled configurations are retained for history and excluded from recommendations.
/// * [name]
/// * [capacityKg]
/// * [numberAvailable]
/// * [cargoLengthM]
/// * [cargoWidthM]
/// * [cargoHeightM]
/// * [heavyClassification]
/// * [baseFeeCentavos]
/// * [perKmCentavos]
/// * [maximumDistanceKm] - Omission retains the saved limit; new coverage defaults to the approved 50 km procurement limit. New vehicle rates inherit coverage.
@BuiltValue()
abstract class VendorSetupDraftVehiclesInner implements Built<VendorSetupDraftVehiclesInner, VendorSetupDraftVehiclesInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  /// Separate category and type. Categorized configurations require applicable cargo dimensions or mixer capacity and heavy classification.
  @BuiltValueField(wireName: r'vehicle_category')
  VendorSetupDraftVehiclesInnerVehicleCategoryEnum? get vehicleCategory;
  // enum vehicleCategoryEnum {  MOTORCYCLE,  PICKUP,  VAN,  TRUCK,  };

  @BuiltValueField(wireName: r'vehicle_type')
  String? get vehicleType;

  @BuiltValueField(wireName: r'custom_type_name')
  String? get customTypeName;

  @BuiltValueField(wireName: r'brand')
  String? get brand;

  @BuiltValueField(wireName: r'mixer_capacity_m3')
  num? get mixerCapacityM3;

  /// Clean VEHICLE_IMAGE file owned by this Vendor.
  @BuiltValueField(wireName: r'image_file_id')
  String? get imageFileId;

  /// Disabled configurations are retained for history and excluded from recommendations.
  @BuiltValueField(wireName: r'active')
  bool? get active;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'capacity_kg')
  num? get capacityKg;

  @BuiltValueField(wireName: r'number_available')
  int? get numberAvailable;

  @BuiltValueField(wireName: r'cargo_length_m')
  num? get cargoLengthM;

  @BuiltValueField(wireName: r'cargo_width_m')
  num? get cargoWidthM;

  @BuiltValueField(wireName: r'cargo_height_m')
  num? get cargoHeightM;

  @BuiltValueField(wireName: r'heavy_classification')
  String? get heavyClassification;

  @BuiltValueField(wireName: r'base_fee_centavos')
  int? get baseFeeCentavos;

  @BuiltValueField(wireName: r'per_km_centavos')
  int? get perKmCentavos;

  /// Omission retains the saved limit; new coverage defaults to the approved 50 km procurement limit. New vehicle rates inherit coverage.
  @BuiltValueField(wireName: r'maximum_distance_km')
  int? get maximumDistanceKm;

  VendorSetupDraftVehiclesInner._();

  factory VendorSetupDraftVehiclesInner([void updates(VendorSetupDraftVehiclesInnerBuilder b)]) = _$VendorSetupDraftVehiclesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorSetupDraftVehiclesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorSetupDraftVehiclesInner> get serializer => _$VendorSetupDraftVehiclesInnerSerializer();
}

class _$VendorSetupDraftVehiclesInnerSerializer implements PrimitiveSerializer<VendorSetupDraftVehiclesInner> {
  @override
  final Iterable<Type> types = const [VendorSetupDraftVehiclesInner, _$VendorSetupDraftVehiclesInner];

  @override
  final String wireName = r'VendorSetupDraftVehiclesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorSetupDraftVehiclesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.vehicleCategory != null) {
      yield r'vehicle_category';
      yield serializers.serialize(
        object.vehicleCategory,
        specifiedType: const FullType(VendorSetupDraftVehiclesInnerVehicleCategoryEnum),
      );
    }
    if (object.vehicleType != null) {
      yield r'vehicle_type';
      yield serializers.serialize(
        object.vehicleType,
        specifiedType: const FullType(String),
      );
    }
    if (object.customTypeName != null) {
      yield r'custom_type_name';
      yield serializers.serialize(
        object.customTypeName,
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
    if (object.mixerCapacityM3 != null) {
      yield r'mixer_capacity_m3';
      yield serializers.serialize(
        object.mixerCapacityM3,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.imageFileId != null) {
      yield r'image_file_id';
      yield serializers.serialize(
        object.imageFileId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.active != null) {
      yield r'active';
      yield serializers.serialize(
        object.active,
        specifiedType: const FullType(bool),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.capacityKg != null) {
      yield r'capacity_kg';
      yield serializers.serialize(
        object.capacityKg,
        specifiedType: const FullType(num),
      );
    }
    if (object.numberAvailable != null) {
      yield r'number_available';
      yield serializers.serialize(
        object.numberAvailable,
        specifiedType: const FullType(int),
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
    if (object.heavyClassification != null) {
      yield r'heavy_classification';
      yield serializers.serialize(
        object.heavyClassification,
        specifiedType: const FullType.nullable(String),
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
    VendorSetupDraftVehiclesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorSetupDraftVehiclesInnerBuilder result,
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
        case r'vehicle_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorSetupDraftVehiclesInnerVehicleCategoryEnum),
          ) as VendorSetupDraftVehiclesInnerVehicleCategoryEnum?;
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
        case r'brand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.brand = valueDes;
          break;
        case r'mixer_capacity_m3':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.mixerCapacityM3 = valueDes;
          break;
        case r'image_file_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.imageFileId = valueDes;
          break;
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.active = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'capacity_kg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.capacityKg = valueDes;
          break;
        case r'number_available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.numberAvailable = valueDes;
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
        case r'heavy_classification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.heavyClassification = valueDes;
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
  VendorSetupDraftVehiclesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorSetupDraftVehiclesInnerBuilder();
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


/// Separate category and type. Categorized configurations require applicable cargo dimensions or mixer capacity and heavy classification.
class VendorSetupDraftVehiclesInnerVehicleCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MOTORCYCLE')
  static const VendorSetupDraftVehiclesInnerVehicleCategoryEnum MOTORCYCLE = _$vendorSetupDraftVehiclesInnerVehicleCategoryEnum_MOTORCYCLE;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const VendorSetupDraftVehiclesInnerVehicleCategoryEnum PICKUP = _$vendorSetupDraftVehiclesInnerVehicleCategoryEnum_PICKUP;
  @BuiltValueEnumConst(wireName: r'VAN')
  static const VendorSetupDraftVehiclesInnerVehicleCategoryEnum VAN = _$vendorSetupDraftVehiclesInnerVehicleCategoryEnum_VAN;
  @BuiltValueEnumConst(wireName: r'TRUCK')
  static const VendorSetupDraftVehiclesInnerVehicleCategoryEnum TRUCK = _$vendorSetupDraftVehiclesInnerVehicleCategoryEnum_TRUCK;

  static Serializer<VendorSetupDraftVehiclesInnerVehicleCategoryEnum> get serializer => _$vendorSetupDraftVehiclesInnerVehicleCategoryEnumSerializer;

  const VendorSetupDraftVehiclesInnerVehicleCategoryEnum._(String name): super(name);

  static BuiltSet<VendorSetupDraftVehiclesInnerVehicleCategoryEnum> get values => _$vendorSetupDraftVehiclesInnerVehicleCategoryEnumValues;
  static VendorSetupDraftVehiclesInnerVehicleCategoryEnum valueOf(String name) => _$vendorSetupDraftVehiclesInnerVehicleCategoryEnumValueOf(name);
}

