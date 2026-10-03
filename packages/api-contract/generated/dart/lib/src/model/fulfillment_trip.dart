//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fulfillment_trip.g.dart';

/// FulfillmentTrip
///
/// Properties:
/// * [vehicleIndex]
/// * [tripNumber]
/// * [name]
/// * [totalVehicleTrips]
/// * [dispatchedAt]
@BuiltValue()
abstract class FulfillmentTrip implements Built<FulfillmentTrip, FulfillmentTripBuilder> {
  @BuiltValueField(wireName: r'vehicle_index')
  int get vehicleIndex;

  @BuiltValueField(wireName: r'trip_number')
  int get tripNumber;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'total_vehicle_trips')
  int get totalVehicleTrips;

  @BuiltValueField(wireName: r'dispatched_at')
  DateTime? get dispatchedAt;

  FulfillmentTrip._();

  factory FulfillmentTrip([void updates(FulfillmentTripBuilder b)]) = _$FulfillmentTrip;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FulfillmentTripBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FulfillmentTrip> get serializer => _$FulfillmentTripSerializer();
}

class _$FulfillmentTripSerializer implements PrimitiveSerializer<FulfillmentTrip> {
  @override
  final Iterable<Type> types = const [FulfillmentTrip, _$FulfillmentTrip];

  @override
  final String wireName = r'FulfillmentTrip';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FulfillmentTrip object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vehicle_index';
    yield serializers.serialize(
      object.vehicleIndex,
      specifiedType: const FullType(int),
    );
    yield r'trip_number';
    yield serializers.serialize(
      object.tripNumber,
      specifiedType: const FullType(int),
    );
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    yield r'total_vehicle_trips';
    yield serializers.serialize(
      object.totalVehicleTrips,
      specifiedType: const FullType(int),
    );
    if (object.dispatchedAt != null) {
      yield r'dispatched_at';
      yield serializers.serialize(
        object.dispatchedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FulfillmentTrip object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FulfillmentTripBuilder result,
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
        case r'trip_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.tripNumber = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'total_vehicle_trips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalVehicleTrips = valueDes;
          break;
        case r'dispatched_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.dispatchedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FulfillmentTrip deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FulfillmentTripBuilder();
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


