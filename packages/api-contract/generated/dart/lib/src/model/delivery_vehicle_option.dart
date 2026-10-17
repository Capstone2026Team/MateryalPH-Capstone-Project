//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_vehicle_option.g.dart';

/// DeliveryVehicleOption
///
/// Properties:
/// * [vehicleIndex]
/// * [vehicleId]
/// * [name]
/// * [vehicleType]
/// * [numberOfVehicles]
/// * [totalVehicleTrips]
/// * [available]
/// * [unavailableReason]
@BuiltValue()
abstract class DeliveryVehicleOption implements Built<DeliveryVehicleOption, DeliveryVehicleOptionBuilder> {
  @BuiltValueField(wireName: r'vehicle_index')
  int get vehicleIndex;

  @BuiltValueField(wireName: r'vehicle_id')
  String get vehicleId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'vehicle_type')
  String get vehicleType;

  @BuiltValueField(wireName: r'number_of_vehicles')
  int get numberOfVehicles;

  @BuiltValueField(wireName: r'total_vehicle_trips')
  int get totalVehicleTrips;

  @BuiltValueField(wireName: r'available')
  bool get available;

  @BuiltValueField(wireName: r'unavailable_reason')
  String get unavailableReason;

  DeliveryVehicleOption._();

  factory DeliveryVehicleOption([void updates(DeliveryVehicleOptionBuilder b)]) = _$DeliveryVehicleOption;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryVehicleOptionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryVehicleOption> get serializer => _$DeliveryVehicleOptionSerializer();
}

class _$DeliveryVehicleOptionSerializer implements PrimitiveSerializer<DeliveryVehicleOption> {
  @override
  final Iterable<Type> types = const [DeliveryVehicleOption, _$DeliveryVehicleOption];

  @override
  final String wireName = r'DeliveryVehicleOption';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryVehicleOption object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vehicle_index';
    yield serializers.serialize(
      object.vehicleIndex,
      specifiedType: const FullType(int),
    );
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
    yield r'vehicle_type';
    yield serializers.serialize(
      object.vehicleType,
      specifiedType: const FullType(String),
    );
    yield r'number_of_vehicles';
    yield serializers.serialize(
      object.numberOfVehicles,
      specifiedType: const FullType(int),
    );
    yield r'total_vehicle_trips';
    yield serializers.serialize(
      object.totalVehicleTrips,
      specifiedType: const FullType(int),
    );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    yield r'unavailable_reason';
    yield serializers.serialize(
      object.unavailableReason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryVehicleOption object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryVehicleOptionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vehicle_index':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vehicleIndex = valueDes;
          break;
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
        case r'vehicle_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vehicleType = valueDes;
          break;
        case r'number_of_vehicles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.numberOfVehicles = valueDes;
          break;
        case r'total_vehicle_trips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalVehicleTrips = valueDes;
          break;
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        case r'unavailable_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unavailableReason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryVehicleOption deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryVehicleOptionBuilder();
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


