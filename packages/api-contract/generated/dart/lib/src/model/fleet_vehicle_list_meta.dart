//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/fleet_vehicle_list_meta_delivery.dart';
import 'package:materyalph_api_client/src/model/fleet_vehicle_list_meta_permissions.dart';
import 'package:materyalph_api_client/src/model/fleet_vehicle_list_meta_limits.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fleet_vehicle_list_meta.g.dart';

/// FleetVehicleListMeta
///
/// Properties:
/// * [scope]
/// * [delivery]
/// * [permissions]
/// * [limits]
@BuiltValue()
abstract class FleetVehicleListMeta implements Built<FleetVehicleListMeta, FleetVehicleListMetaBuilder> {
  @BuiltValueField(wireName: r'scope')
  FleetVehicleListMetaScopeEnum get scope;
  // enum scopeEnum {  ORGANIZATION,  ASSIGNED_ONLY,  };

  @BuiltValueField(wireName: r'delivery')
  FleetVehicleListMetaDelivery? get delivery;

  @BuiltValueField(wireName: r'permissions')
  FleetVehicleListMetaPermissions get permissions;

  @BuiltValueField(wireName: r'limits')
  FleetVehicleListMetaLimits? get limits;

  FleetVehicleListMeta._();

  factory FleetVehicleListMeta([void updates(FleetVehicleListMetaBuilder b)]) = _$FleetVehicleListMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FleetVehicleListMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FleetVehicleListMeta> get serializer => _$FleetVehicleListMetaSerializer();
}

class _$FleetVehicleListMetaSerializer implements PrimitiveSerializer<FleetVehicleListMeta> {
  @override
  final Iterable<Type> types = const [FleetVehicleListMeta, _$FleetVehicleListMeta];

  @override
  final String wireName = r'FleetVehicleListMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FleetVehicleListMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(FleetVehicleListMetaScopeEnum),
    );
    if (object.delivery != null) {
      yield r'delivery';
      yield serializers.serialize(
        object.delivery,
        specifiedType: const FullType.nullable(FleetVehicleListMetaDelivery),
      );
    }
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(FleetVehicleListMetaPermissions),
    );
    if (object.limits != null) {
      yield r'limits';
      yield serializers.serialize(
        object.limits,
        specifiedType: const FullType(FleetVehicleListMetaLimits),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FleetVehicleListMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FleetVehicleListMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FleetVehicleListMetaScopeEnum),
          ) as FleetVehicleListMetaScopeEnum;
          result.scope = valueDes;
          break;
        case r'delivery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FleetVehicleListMetaDelivery),
          ) as FleetVehicleListMetaDelivery?;
          if (valueDes == null) continue;
          result.delivery.replace(valueDes);
          break;
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FleetVehicleListMetaPermissions),
          ) as FleetVehicleListMetaPermissions;
          result.permissions.replace(valueDes);
          break;
        case r'limits':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FleetVehicleListMetaLimits),
          ) as FleetVehicleListMetaLimits?;
          if (valueDes == null) continue;
          result.limits.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FleetVehicleListMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FleetVehicleListMetaBuilder();
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


class FleetVehicleListMetaScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ORGANIZATION')
  static const FleetVehicleListMetaScopeEnum ORGANIZATION = _$fleetVehicleListMetaScopeEnum_ORGANIZATION;
  @BuiltValueEnumConst(wireName: r'ASSIGNED_ONLY')
  static const FleetVehicleListMetaScopeEnum ASSIGNED_ONLY = _$fleetVehicleListMetaScopeEnum_ASSIGNED_ONLY;

  static Serializer<FleetVehicleListMetaScopeEnum> get serializer => _$fleetVehicleListMetaScopeEnumSerializer;

  const FleetVehicleListMetaScopeEnum._(String name): super(name);

  static BuiltSet<FleetVehicleListMetaScopeEnum> get values => _$fleetVehicleListMetaScopeEnumValues;
  static FleetVehicleListMetaScopeEnum valueOf(String name) => _$fleetVehicleListMetaScopeEnumValueOf(name);
}

