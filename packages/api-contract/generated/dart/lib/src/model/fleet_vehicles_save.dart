//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/fleet_vehicle_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fleet_vehicles_save.g.dart';

/// FleetVehiclesSave
///
/// Properties:
/// * [vehicles]
@BuiltValue()
abstract class FleetVehiclesSave implements Built<FleetVehiclesSave, FleetVehiclesSaveBuilder> {
  @BuiltValueField(wireName: r'vehicles')
  BuiltList<FleetVehicleInput> get vehicles;

  FleetVehiclesSave._();

  factory FleetVehiclesSave([void updates(FleetVehiclesSaveBuilder b)]) = _$FleetVehiclesSave;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FleetVehiclesSaveBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FleetVehiclesSave> get serializer => _$FleetVehiclesSaveSerializer();
}

class _$FleetVehiclesSaveSerializer implements PrimitiveSerializer<FleetVehiclesSave> {
  @override
  final Iterable<Type> types = const [FleetVehiclesSave, _$FleetVehiclesSave];

  @override
  final String wireName = r'FleetVehiclesSave';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FleetVehiclesSave object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vehicles';
    yield serializers.serialize(
      object.vehicles,
      specifiedType: const FullType(BuiltList, [FullType(FleetVehicleInput)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FleetVehiclesSave object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FleetVehiclesSaveBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vehicles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FleetVehicleInput)]),
          ) as BuiltList<FleetVehicleInput>;
          result.vehicles.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FleetVehiclesSave deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FleetVehiclesSaveBuilder();
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


