//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/mixer_volume_plan.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_estimate_option.g.dart';

/// DeliveryEstimateOption
///
/// Properties:
/// * [vehicleId] - Recommended registered vehicle; absent in historical estimates.
/// * [loadKey]
/// * [vehicleName]
/// * [vehicleType]
/// * [vehicles]
/// * [trips]
/// * [feeCentavos] - Trip fees plus any mixer mobilization.
/// * [feePerTripCentavos]
/// * [mobilizationBasis] - The Vendor's chosen mixer mobilization basis.
/// * [mobilizationFeeCentavos]
/// * [mobilizationTotalCentavos]
/// * [volumePlan]
@BuiltValue()
abstract class DeliveryEstimateOption implements Built<DeliveryEstimateOption, DeliveryEstimateOptionBuilder> {
  /// Recommended registered vehicle; absent in historical estimates.
  @BuiltValueField(wireName: r'vehicle_id')
  String? get vehicleId;

  @BuiltValueField(wireName: r'load_key')
  String get loadKey;

  @BuiltValueField(wireName: r'vehicle_name')
  String get vehicleName;

  @BuiltValueField(wireName: r'vehicle_type')
  String get vehicleType;

  @BuiltValueField(wireName: r'vehicles')
  int get vehicles;

  @BuiltValueField(wireName: r'trips')
  int get trips;

  /// Trip fees plus any mixer mobilization.
  @BuiltValueField(wireName: r'fee_centavos')
  int get feeCentavos;

  @BuiltValueField(wireName: r'fee_per_trip_centavos')
  int get feePerTripCentavos;

  /// The Vendor's chosen mixer mobilization basis.
  @BuiltValueField(wireName: r'mobilization_basis')
  DeliveryEstimateOptionMobilizationBasisEnum? get mobilizationBasis;
  // enum mobilizationBasisEnum {  PER_TRUCK,  PER_TRIP,  ,  };

  @BuiltValueField(wireName: r'mobilization_fee_centavos')
  int? get mobilizationFeeCentavos;

  @BuiltValueField(wireName: r'mobilization_total_centavos')
  int? get mobilizationTotalCentavos;

  @BuiltValueField(wireName: r'volume_plan')
  MixerVolumePlan? get volumePlan;

  DeliveryEstimateOption._();

  factory DeliveryEstimateOption([void updates(DeliveryEstimateOptionBuilder b)]) = _$DeliveryEstimateOption;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryEstimateOptionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryEstimateOption> get serializer => _$DeliveryEstimateOptionSerializer();
}

class _$DeliveryEstimateOptionSerializer implements PrimitiveSerializer<DeliveryEstimateOption> {
  @override
  final Iterable<Type> types = const [DeliveryEstimateOption, _$DeliveryEstimateOption];

  @override
  final String wireName = r'DeliveryEstimateOption';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryEstimateOption object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.vehicleId != null) {
      yield r'vehicle_id';
      yield serializers.serialize(
        object.vehicleId,
        specifiedType: const FullType(String),
      );
    }
    yield r'load_key';
    yield serializers.serialize(
      object.loadKey,
      specifiedType: const FullType(String),
    );
    yield r'vehicle_name';
    yield serializers.serialize(
      object.vehicleName,
      specifiedType: const FullType(String),
    );
    yield r'vehicle_type';
    yield serializers.serialize(
      object.vehicleType,
      specifiedType: const FullType(String),
    );
    yield r'vehicles';
    yield serializers.serialize(
      object.vehicles,
      specifiedType: const FullType(int),
    );
    yield r'trips';
    yield serializers.serialize(
      object.trips,
      specifiedType: const FullType(int),
    );
    yield r'fee_centavos';
    yield serializers.serialize(
      object.feeCentavos,
      specifiedType: const FullType(int),
    );
    yield r'fee_per_trip_centavos';
    yield serializers.serialize(
      object.feePerTripCentavos,
      specifiedType: const FullType(int),
    );
    if (object.mobilizationBasis != null) {
      yield r'mobilization_basis';
      yield serializers.serialize(
        object.mobilizationBasis,
        specifiedType: const FullType.nullable(DeliveryEstimateOptionMobilizationBasisEnum),
      );
    }
    if (object.mobilizationFeeCentavos != null) {
      yield r'mobilization_fee_centavos';
      yield serializers.serialize(
        object.mobilizationFeeCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.mobilizationTotalCentavos != null) {
      yield r'mobilization_total_centavos';
      yield serializers.serialize(
        object.mobilizationTotalCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.volumePlan != null) {
      yield r'volume_plan';
      yield serializers.serialize(
        object.volumePlan,
        specifiedType: const FullType.nullable(MixerVolumePlan),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryEstimateOption object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryEstimateOptionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vehicle_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehicleId = valueDes;
          break;
        case r'load_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.loadKey = valueDes;
          break;
        case r'vehicle_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vehicleName = valueDes;
          break;
        case r'vehicle_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vehicleType = valueDes;
          break;
        case r'vehicles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vehicles = valueDes;
          break;
        case r'trips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.trips = valueDes;
          break;
        case r'fee_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.feeCentavos = valueDes;
          break;
        case r'fee_per_trip_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.feePerTripCentavos = valueDes;
          break;
        case r'mobilization_basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DeliveryEstimateOptionMobilizationBasisEnum),
          ) as DeliveryEstimateOptionMobilizationBasisEnum?;
          if (valueDes == null) continue;
          result.mobilizationBasis = valueDes;
          break;
        case r'mobilization_fee_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.mobilizationFeeCentavos = valueDes;
          break;
        case r'mobilization_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.mobilizationTotalCentavos = valueDes;
          break;
        case r'volume_plan':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MixerVolumePlan),
          ) as MixerVolumePlan?;
          if (valueDes == null) continue;
          result.volumePlan.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryEstimateOption deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryEstimateOptionBuilder();
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


/// The Vendor's chosen mixer mobilization basis.
class DeliveryEstimateOptionMobilizationBasisEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PER_TRUCK')
  static const DeliveryEstimateOptionMobilizationBasisEnum PER_TRUCK = _$deliveryEstimateOptionMobilizationBasisEnum_PER_TRUCK;
  @BuiltValueEnumConst(wireName: r'PER_TRIP')
  static const DeliveryEstimateOptionMobilizationBasisEnum PER_TRIP = _$deliveryEstimateOptionMobilizationBasisEnum_PER_TRIP;

  static Serializer<DeliveryEstimateOptionMobilizationBasisEnum> get serializer => _$deliveryEstimateOptionMobilizationBasisEnumSerializer;

  const DeliveryEstimateOptionMobilizationBasisEnum._(String name): super(name);

  static BuiltSet<DeliveryEstimateOptionMobilizationBasisEnum> get values => _$deliveryEstimateOptionMobilizationBasisEnumValues;
  static DeliveryEstimateOptionMobilizationBasisEnum valueOf(String name) => _$deliveryEstimateOptionMobilizationBasisEnumValueOf(name);
}

