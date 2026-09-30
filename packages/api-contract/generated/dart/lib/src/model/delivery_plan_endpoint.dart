//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/order_point.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_plan_endpoint.g.dart';

/// DeliveryPlanEndpoint
///
/// Properties:
/// * [kind]
/// * [heavyVehicleRestriction]
/// * [intended]
/// * [alternateDropOff]
@BuiltValue()
abstract class DeliveryPlanEndpoint implements Built<DeliveryPlanEndpoint, DeliveryPlanEndpointBuilder> {
  @BuiltValueField(wireName: r'kind')
  DeliveryPlanEndpointKindEnum? get kind;
  // enum kindEnum {  INTENDED_LOCATION,  ALTERNATE_DROP_OFF,  ,  };

  @BuiltValueField(wireName: r'heavy_vehicle_restriction')
  DeliveryPlanEndpointHeavyVehicleRestrictionEnum? get heavyVehicleRestriction;
  // enum heavyVehicleRestrictionEnum {  NO,  YES,  ,  };

  @BuiltValueField(wireName: r'intended')
  OrderPoint? get intended;

  @BuiltValueField(wireName: r'alternate_drop_off')
  OrderPoint? get alternateDropOff;

  DeliveryPlanEndpoint._();

  factory DeliveryPlanEndpoint([void updates(DeliveryPlanEndpointBuilder b)]) = _$DeliveryPlanEndpoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryPlanEndpointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryPlanEndpoint> get serializer => _$DeliveryPlanEndpointSerializer();
}

class _$DeliveryPlanEndpointSerializer implements PrimitiveSerializer<DeliveryPlanEndpoint> {
  @override
  final Iterable<Type> types = const [DeliveryPlanEndpoint, _$DeliveryPlanEndpoint];

  @override
  final String wireName = r'DeliveryPlanEndpoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryPlanEndpoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield object.kind == null ? null : serializers.serialize(
      object.kind,
      specifiedType: const FullType.nullable(DeliveryPlanEndpointKindEnum),
    );
    yield r'heavy_vehicle_restriction';
    yield object.heavyVehicleRestriction == null ? null : serializers.serialize(
      object.heavyVehicleRestriction,
      specifiedType: const FullType.nullable(DeliveryPlanEndpointHeavyVehicleRestrictionEnum),
    );
    yield r'intended';
    yield object.intended == null ? null : serializers.serialize(
      object.intended,
      specifiedType: const FullType.nullable(OrderPoint),
    );
    yield r'alternate_drop_off';
    yield object.alternateDropOff == null ? null : serializers.serialize(
      object.alternateDropOff,
      specifiedType: const FullType.nullable(OrderPoint),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryPlanEndpoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryPlanEndpointBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DeliveryPlanEndpointKindEnum),
          ) as DeliveryPlanEndpointKindEnum?;
          if (valueDes == null) continue;
          result.kind = valueDes;
          break;
        case r'heavy_vehicle_restriction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DeliveryPlanEndpointHeavyVehicleRestrictionEnum),
          ) as DeliveryPlanEndpointHeavyVehicleRestrictionEnum?;
          if (valueDes == null) continue;
          result.heavyVehicleRestriction = valueDes;
          break;
        case r'intended':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderPoint),
          ) as OrderPoint?;
          if (valueDes == null) continue;
          result.intended.replace(valueDes);
          break;
        case r'alternate_drop_off':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderPoint),
          ) as OrderPoint?;
          if (valueDes == null) continue;
          result.alternateDropOff.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryPlanEndpoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryPlanEndpointBuilder();
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


class DeliveryPlanEndpointKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INTENDED_LOCATION')
  static const DeliveryPlanEndpointKindEnum INTENDED_LOCATION = _$deliveryPlanEndpointKindEnum_INTENDED_LOCATION;
  @BuiltValueEnumConst(wireName: r'ALTERNATE_DROP_OFF')
  static const DeliveryPlanEndpointKindEnum ALTERNATE_DROP_OFF = _$deliveryPlanEndpointKindEnum_ALTERNATE_DROP_OFF;

  static Serializer<DeliveryPlanEndpointKindEnum> get serializer => _$deliveryPlanEndpointKindEnumSerializer;

  const DeliveryPlanEndpointKindEnum._(String name): super(name);

  static BuiltSet<DeliveryPlanEndpointKindEnum> get values => _$deliveryPlanEndpointKindEnumValues;
  static DeliveryPlanEndpointKindEnum valueOf(String name) => _$deliveryPlanEndpointKindEnumValueOf(name);
}

class DeliveryPlanEndpointHeavyVehicleRestrictionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NO')
  static const DeliveryPlanEndpointHeavyVehicleRestrictionEnum NO = _$deliveryPlanEndpointHeavyVehicleRestrictionEnum_NO;
  @BuiltValueEnumConst(wireName: r'YES')
  static const DeliveryPlanEndpointHeavyVehicleRestrictionEnum YES = _$deliveryPlanEndpointHeavyVehicleRestrictionEnum_YES;

  static Serializer<DeliveryPlanEndpointHeavyVehicleRestrictionEnum> get serializer => _$deliveryPlanEndpointHeavyVehicleRestrictionEnumSerializer;

  const DeliveryPlanEndpointHeavyVehicleRestrictionEnum._(String name): super(name);

  static BuiltSet<DeliveryPlanEndpointHeavyVehicleRestrictionEnum> get values => _$deliveryPlanEndpointHeavyVehicleRestrictionEnumValues;
  static DeliveryPlanEndpointHeavyVehicleRestrictionEnum valueOf(String name) => _$deliveryPlanEndpointHeavyVehicleRestrictionEnumValueOf(name);
}

