//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fleet_vehicle_list_meta_permissions.g.dart';

/// FleetVehicleListMetaPermissions
///
/// Properties:
/// * [canManage]
@BuiltValue()
abstract class FleetVehicleListMetaPermissions implements Built<FleetVehicleListMetaPermissions, FleetVehicleListMetaPermissionsBuilder> {
  @BuiltValueField(wireName: r'can_manage')
  bool get canManage;

  FleetVehicleListMetaPermissions._();

  factory FleetVehicleListMetaPermissions([void updates(FleetVehicleListMetaPermissionsBuilder b)]) = _$FleetVehicleListMetaPermissions;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FleetVehicleListMetaPermissionsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FleetVehicleListMetaPermissions> get serializer => _$FleetVehicleListMetaPermissionsSerializer();
}

class _$FleetVehicleListMetaPermissionsSerializer implements PrimitiveSerializer<FleetVehicleListMetaPermissions> {
  @override
  final Iterable<Type> types = const [FleetVehicleListMetaPermissions, _$FleetVehicleListMetaPermissions];

  @override
  final String wireName = r'FleetVehicleListMetaPermissions';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FleetVehicleListMetaPermissions object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'can_manage';
    yield serializers.serialize(
      object.canManage,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FleetVehicleListMetaPermissions object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FleetVehicleListMetaPermissionsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'can_manage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canManage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FleetVehicleListMetaPermissions deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FleetVehicleListMetaPermissionsBuilder();
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


