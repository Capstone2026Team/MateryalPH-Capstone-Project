//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_estimate_option.g.dart';

/// DeliveryEstimateOption
///
/// Properties:
/// * [loadKey]
/// * [vehicleName]
/// * [vehicleType]
/// * [vehicles]
/// * [trips]
/// * [feeCentavos]
/// * [feePerTripCentavos]
@BuiltValue()
abstract class DeliveryEstimateOption implements Built<DeliveryEstimateOption, DeliveryEstimateOptionBuilder> {
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

  @BuiltValueField(wireName: r'fee_centavos')
  int get feeCentavos;

  @BuiltValueField(wireName: r'fee_per_trip_centavos')
  int get feePerTripCentavos;

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


