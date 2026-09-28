//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fleet_vehicle_list_meta_limits.g.dart';

/// FleetVehicleListMetaLimits
///
/// Properties:
/// * [maxVehicles]
@BuiltValue()
abstract class FleetVehicleListMetaLimits implements Built<FleetVehicleListMetaLimits, FleetVehicleListMetaLimitsBuilder> {
  @BuiltValueField(wireName: r'max_vehicles')
  int? get maxVehicles;

  FleetVehicleListMetaLimits._();

  factory FleetVehicleListMetaLimits([void updates(FleetVehicleListMetaLimitsBuilder b)]) = _$FleetVehicleListMetaLimits;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FleetVehicleListMetaLimitsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FleetVehicleListMetaLimits> get serializer => _$FleetVehicleListMetaLimitsSerializer();
}

class _$FleetVehicleListMetaLimitsSerializer implements PrimitiveSerializer<FleetVehicleListMetaLimits> {
  @override
  final Iterable<Type> types = const [FleetVehicleListMetaLimits, _$FleetVehicleListMetaLimits];

  @override
  final String wireName = r'FleetVehicleListMetaLimits';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FleetVehicleListMetaLimits object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.maxVehicles != null) {
      yield r'max_vehicles';
      yield serializers.serialize(
        object.maxVehicles,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FleetVehicleListMetaLimits object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FleetVehicleListMetaLimitsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'max_vehicles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxVehicles = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FleetVehicleListMetaLimits deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FleetVehicleListMetaLimitsBuilder();
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


