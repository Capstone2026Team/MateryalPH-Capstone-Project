//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_vehicle_profile.g.dart';

/// Vehicle display details without private fleet availability counts. Order details preserve the accepted configuration; recommendations are advisory.
///
/// Properties:
/// * [name]
/// * [vehicleCategory]
/// * [vehicleType]
/// * [customTypeName]
/// * [brand]
/// * [imageFileId]
/// * [capacityKg]
/// * [mixerCapacityM3]
/// * [cargoLengthM]
/// * [cargoWidthM]
/// * [cargoHeightM]
/// * [heavyClassification]
@BuiltValue()
abstract class DeliveryVehicleProfile implements Built<DeliveryVehicleProfile, DeliveryVehicleProfileBuilder> {
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'vehicle_category')
  String? get vehicleCategory;

  @BuiltValueField(wireName: r'vehicle_type')
  String? get vehicleType;

  @BuiltValueField(wireName: r'custom_type_name')
  String? get customTypeName;

  @BuiltValueField(wireName: r'brand')
  String? get brand;

  @BuiltValueField(wireName: r'image_file_id')
  String? get imageFileId;

  @BuiltValueField(wireName: r'capacity_kg')
  String? get capacityKg;

  @BuiltValueField(wireName: r'mixer_capacity_m3')
  String? get mixerCapacityM3;

  @BuiltValueField(wireName: r'cargo_length_m')
  String? get cargoLengthM;

  @BuiltValueField(wireName: r'cargo_width_m')
  String? get cargoWidthM;

  @BuiltValueField(wireName: r'cargo_height_m')
  String? get cargoHeightM;

  @BuiltValueField(wireName: r'heavy_classification')
  String? get heavyClassification;

  DeliveryVehicleProfile._();

  factory DeliveryVehicleProfile([void updates(DeliveryVehicleProfileBuilder b)]) = _$DeliveryVehicleProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryVehicleProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryVehicleProfile> get serializer => _$DeliveryVehicleProfileSerializer();
}

class _$DeliveryVehicleProfileSerializer implements PrimitiveSerializer<DeliveryVehicleProfile> {
  @override
  final Iterable<Type> types = const [DeliveryVehicleProfile, _$DeliveryVehicleProfile];

  @override
  final String wireName = r'DeliveryVehicleProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryVehicleProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.vehicleCategory != null) {
      yield r'vehicle_category';
      yield serializers.serialize(
        object.vehicleCategory,
        specifiedType: const FullType.nullable(String),
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
    if (object.capacityKg != null) {
      yield r'capacity_kg';
      yield serializers.serialize(
        object.capacityKg,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.mixerCapacityM3 != null) {
      yield r'mixer_capacity_m3';
      yield serializers.serialize(
        object.mixerCapacityM3,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.cargoLengthM != null) {
      yield r'cargo_length_m';
      yield serializers.serialize(
        object.cargoLengthM,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.cargoWidthM != null) {
      yield r'cargo_width_m';
      yield serializers.serialize(
        object.cargoWidthM,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.cargoHeightM != null) {
      yield r'cargo_height_m';
      yield serializers.serialize(
        object.cargoHeightM,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.heavyClassification != null) {
      yield r'heavy_classification';
      yield serializers.serialize(
        object.heavyClassification,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryVehicleProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryVehicleProfileBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
        case r'image_file_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.imageFileId = valueDes;
          break;
        case r'capacity_kg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
        case r'cargo_length_m':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cargoLengthM = valueDes;
          break;
        case r'cargo_width_m':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cargoWidthM = valueDes;
          break;
        case r'cargo_height_m':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryVehicleProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryVehicleProfileBuilder();
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


