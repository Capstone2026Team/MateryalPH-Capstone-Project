//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fleet_vehicle_list_meta_delivery.g.dart';

/// FleetVehicleListMetaDelivery
///
/// Properties:
/// * [fulfillmentMethod]
/// * [deliveryEnabled]
/// * [serviceRadiusKm]
@BuiltValue()
abstract class FleetVehicleListMetaDelivery implements Built<FleetVehicleListMetaDelivery, FleetVehicleListMetaDeliveryBuilder> {
  @BuiltValueField(wireName: r'fulfillment_method')
  String? get fulfillmentMethod;

  @BuiltValueField(wireName: r'delivery_enabled')
  bool get deliveryEnabled;

  @BuiltValueField(wireName: r'service_radius_km')
  int? get serviceRadiusKm;

  FleetVehicleListMetaDelivery._();

  factory FleetVehicleListMetaDelivery([void updates(FleetVehicleListMetaDeliveryBuilder b)]) = _$FleetVehicleListMetaDelivery;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FleetVehicleListMetaDeliveryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FleetVehicleListMetaDelivery> get serializer => _$FleetVehicleListMetaDeliverySerializer();
}

class _$FleetVehicleListMetaDeliverySerializer implements PrimitiveSerializer<FleetVehicleListMetaDelivery> {
  @override
  final Iterable<Type> types = const [FleetVehicleListMetaDelivery, _$FleetVehicleListMetaDelivery];

  @override
  final String wireName = r'FleetVehicleListMetaDelivery';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FleetVehicleListMetaDelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fulfillment_method';
    yield object.fulfillmentMethod == null ? null : serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType.nullable(String),
    );
    yield r'delivery_enabled';
    yield serializers.serialize(
      object.deliveryEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'service_radius_km';
    yield object.serviceRadiusKm == null ? null : serializers.serialize(
      object.serviceRadiusKm,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FleetVehicleListMetaDelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FleetVehicleListMetaDeliveryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fulfillmentMethod = valueDes;
          break;
        case r'delivery_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.deliveryEnabled = valueDes;
          break;
        case r'service_radius_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.serviceRadiusKm = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FleetVehicleListMetaDelivery deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FleetVehicleListMetaDeliveryBuilder();
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


