//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fulfillment_arrangement_vehicle.g.dart';

/// FulfillmentArrangementVehicle
///
/// Properties:
/// * [vehicleIndex]
/// * [name]
/// * [vehicleType]
/// * [numberOfVehicles]
/// * [totalVehicleTrips]
@BuiltValue()
abstract class FulfillmentArrangementVehicle implements Built<FulfillmentArrangementVehicle, FulfillmentArrangementVehicleBuilder> {
  @BuiltValueField(wireName: r'vehicle_index')
  int get vehicleIndex;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'vehicle_type')
  String? get vehicleType;

  @BuiltValueField(wireName: r'number_of_vehicles')
  int get numberOfVehicles;

  @BuiltValueField(wireName: r'total_vehicle_trips')
  int get totalVehicleTrips;

  FulfillmentArrangementVehicle._();

  factory FulfillmentArrangementVehicle([void updates(FulfillmentArrangementVehicleBuilder b)]) = _$FulfillmentArrangementVehicle;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FulfillmentArrangementVehicleBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FulfillmentArrangementVehicle> get serializer => _$FulfillmentArrangementVehicleSerializer();
}

class _$FulfillmentArrangementVehicleSerializer implements PrimitiveSerializer<FulfillmentArrangementVehicle> {
  @override
  final Iterable<Type> types = const [FulfillmentArrangementVehicle, _$FulfillmentArrangementVehicle];

  @override
  final String wireName = r'FulfillmentArrangementVehicle';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FulfillmentArrangementVehicle object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vehicle_index';
    yield serializers.serialize(
      object.vehicleIndex,
      specifiedType: const FullType(int),
    );
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.vehicleType != null) {
      yield r'vehicle_type';
      yield serializers.serialize(
        object.vehicleType,
        specifiedType: const FullType(String),
      );
    }
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
  }

  @override
  Object serialize(
    Serializers serializers,
    FulfillmentArrangementVehicle object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FulfillmentArrangementVehicleBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'vehicle_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FulfillmentArrangementVehicle deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FulfillmentArrangementVehicleBuilder();
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


