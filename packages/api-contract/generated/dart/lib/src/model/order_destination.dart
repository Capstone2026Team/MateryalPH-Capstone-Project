//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/order_point.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_destination.g.dart';

/// The intended destination/Project site and the heavy-vehicle alternate drop-off stay separate; vehicle_endpoint names the actual drop-off.
///
/// Properties:
/// * [type]
/// * [storeAddress]
/// * [intended]
/// * [heavyVehicleRestriction]
/// * [alternateDropOff]
/// * [vehicleEndpoint]
/// * [accessInstructions]
@BuiltValue()
abstract class OrderDestination implements Built<OrderDestination, OrderDestinationBuilder> {
  @BuiltValueField(wireName: r'type')
  OrderDestinationTypeEnum get type;
  // enum typeEnum {  DELIVERY,  PICKUP,  };

  @BuiltValueField(wireName: r'store_address')
  String? get storeAddress;

  @BuiltValueField(wireName: r'intended')
  OrderPoint? get intended;

  @BuiltValueField(wireName: r'heavy_vehicle_restriction')
  OrderDestinationHeavyVehicleRestrictionEnum? get heavyVehicleRestriction;
  // enum heavyVehicleRestrictionEnum {  NO,  YES,  ,  };

  @BuiltValueField(wireName: r'alternate_drop_off')
  OrderPoint? get alternateDropOff;

  @BuiltValueField(wireName: r'vehicle_endpoint')
  OrderDestinationVehicleEndpointEnum? get vehicleEndpoint;
  // enum vehicleEndpointEnum {  INTENDED_LOCATION,  ALTERNATE_DROP_OFF,  ,  };

  @BuiltValueField(wireName: r'access_instructions')
  String? get accessInstructions;

  OrderDestination._();

  factory OrderDestination([void updates(OrderDestinationBuilder b)]) = _$OrderDestination;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderDestinationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderDestination> get serializer => _$OrderDestinationSerializer();
}

class _$OrderDestinationSerializer implements PrimitiveSerializer<OrderDestination> {
  @override
  final Iterable<Type> types = const [OrderDestination, _$OrderDestination];

  @override
  final String wireName = r'OrderDestination';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderDestination object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(OrderDestinationTypeEnum),
    );
    if (object.storeAddress != null) {
      yield r'store_address';
      yield serializers.serialize(
        object.storeAddress,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.intended != null) {
      yield r'intended';
      yield serializers.serialize(
        object.intended,
        specifiedType: const FullType.nullable(OrderPoint),
      );
    }
    if (object.heavyVehicleRestriction != null) {
      yield r'heavy_vehicle_restriction';
      yield serializers.serialize(
        object.heavyVehicleRestriction,
        specifiedType: const FullType.nullable(OrderDestinationHeavyVehicleRestrictionEnum),
      );
    }
    if (object.alternateDropOff != null) {
      yield r'alternate_drop_off';
      yield serializers.serialize(
        object.alternateDropOff,
        specifiedType: const FullType.nullable(OrderPoint),
      );
    }
    if (object.vehicleEndpoint != null) {
      yield r'vehicle_endpoint';
      yield serializers.serialize(
        object.vehicleEndpoint,
        specifiedType: const FullType.nullable(OrderDestinationVehicleEndpointEnum),
      );
    }
    if (object.accessInstructions != null) {
      yield r'access_instructions';
      yield serializers.serialize(
        object.accessInstructions,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderDestination object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderDestinationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderDestinationTypeEnum),
          ) as OrderDestinationTypeEnum;
          result.type = valueDes;
          break;
        case r'store_address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.storeAddress = valueDes;
          break;
        case r'intended':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderPoint),
          ) as OrderPoint?;
          if (valueDes == null) continue;
          result.intended.replace(valueDes);
          break;
        case r'heavy_vehicle_restriction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderDestinationHeavyVehicleRestrictionEnum),
          ) as OrderDestinationHeavyVehicleRestrictionEnum?;
          if (valueDes == null) continue;
          result.heavyVehicleRestriction = valueDes;
          break;
        case r'alternate_drop_off':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderPoint),
          ) as OrderPoint?;
          if (valueDes == null) continue;
          result.alternateDropOff.replace(valueDes);
          break;
        case r'vehicle_endpoint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderDestinationVehicleEndpointEnum),
          ) as OrderDestinationVehicleEndpointEnum?;
          if (valueDes == null) continue;
          result.vehicleEndpoint = valueDes;
          break;
        case r'access_instructions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.accessInstructions = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderDestination deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderDestinationBuilder();
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


class OrderDestinationTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const OrderDestinationTypeEnum DELIVERY = _$orderDestinationTypeEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const OrderDestinationTypeEnum PICKUP = _$orderDestinationTypeEnum_PICKUP;

  static Serializer<OrderDestinationTypeEnum> get serializer => _$orderDestinationTypeEnumSerializer;

  const OrderDestinationTypeEnum._(String name): super(name);

  static BuiltSet<OrderDestinationTypeEnum> get values => _$orderDestinationTypeEnumValues;
  static OrderDestinationTypeEnum valueOf(String name) => _$orderDestinationTypeEnumValueOf(name);
}

class OrderDestinationHeavyVehicleRestrictionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NO')
  static const OrderDestinationHeavyVehicleRestrictionEnum NO = _$orderDestinationHeavyVehicleRestrictionEnum_NO;
  @BuiltValueEnumConst(wireName: r'YES')
  static const OrderDestinationHeavyVehicleRestrictionEnum YES = _$orderDestinationHeavyVehicleRestrictionEnum_YES;

  static Serializer<OrderDestinationHeavyVehicleRestrictionEnum> get serializer => _$orderDestinationHeavyVehicleRestrictionEnumSerializer;

  const OrderDestinationHeavyVehicleRestrictionEnum._(String name): super(name);

  static BuiltSet<OrderDestinationHeavyVehicleRestrictionEnum> get values => _$orderDestinationHeavyVehicleRestrictionEnumValues;
  static OrderDestinationHeavyVehicleRestrictionEnum valueOf(String name) => _$orderDestinationHeavyVehicleRestrictionEnumValueOf(name);
}

class OrderDestinationVehicleEndpointEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INTENDED_LOCATION')
  static const OrderDestinationVehicleEndpointEnum INTENDED_LOCATION = _$orderDestinationVehicleEndpointEnum_INTENDED_LOCATION;
  @BuiltValueEnumConst(wireName: r'ALTERNATE_DROP_OFF')
  static const OrderDestinationVehicleEndpointEnum ALTERNATE_DROP_OFF = _$orderDestinationVehicleEndpointEnum_ALTERNATE_DROP_OFF;

  static Serializer<OrderDestinationVehicleEndpointEnum> get serializer => _$orderDestinationVehicleEndpointEnumSerializer;

  const OrderDestinationVehicleEndpointEnum._(String name): super(name);

  static BuiltSet<OrderDestinationVehicleEndpointEnum> get values => _$orderDestinationVehicleEndpointEnumValues;
  static OrderDestinationVehicleEndpointEnum valueOf(String name) => _$orderDestinationVehicleEndpointEnumValueOf(name);
}

