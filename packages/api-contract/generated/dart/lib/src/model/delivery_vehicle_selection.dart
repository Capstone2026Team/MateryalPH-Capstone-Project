//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_vehicle_selection.g.dart';

/// DeliveryVehicleSelection
///
/// Properties:
/// * [vehicleId]
/// * [numberOfVehicles]
/// * [totalVehicleTrips]
/// * [groupKey]
@BuiltValue()
abstract class DeliveryVehicleSelection implements Built<DeliveryVehicleSelection, DeliveryVehicleSelectionBuilder> {
  @BuiltValueField(wireName: r'vehicle_id')
  String get vehicleId;

  @BuiltValueField(wireName: r'number_of_vehicles')
  int get numberOfVehicles;

  @BuiltValueField(wireName: r'total_vehicle_trips')
  int get totalVehicleTrips;

  @BuiltValueField(wireName: r'group_key')
  String? get groupKey;

  DeliveryVehicleSelection._();

  factory DeliveryVehicleSelection([void updates(DeliveryVehicleSelectionBuilder b)]) = _$DeliveryVehicleSelection;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryVehicleSelectionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryVehicleSelection> get serializer => _$DeliveryVehicleSelectionSerializer();
}

class _$DeliveryVehicleSelectionSerializer implements PrimitiveSerializer<DeliveryVehicleSelection> {
  @override
  final Iterable<Type> types = const [DeliveryVehicleSelection, _$DeliveryVehicleSelection];

  @override
  final String wireName = r'DeliveryVehicleSelection';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryVehicleSelection object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vehicle_id';
    yield serializers.serialize(
      object.vehicleId,
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
    if (object.groupKey != null) {
      yield r'group_key';
      yield serializers.serialize(
        object.groupKey,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryVehicleSelection object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryVehicleSelectionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vehicle_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vehicleId = valueDes;
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
        case r'group_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.groupKey = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryVehicleSelection deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryVehicleSelectionBuilder();
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


