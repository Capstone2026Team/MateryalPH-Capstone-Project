//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/order_point.dart';
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/order_delivery_vehicle.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_confirmed_delivery.g.dart';

/// The frozen Owner/Manager-confirmed arrangement. Later vehicle, rate, profile or schedule changes never alter it.
///
/// Properties:
/// * [vehicles]
/// * [distanceMeters]
/// * [routeSource]
/// * [basis]
/// * [endpoint]
/// * [heavyVehicleRestriction]
/// * [intended]
/// * [alternateDropOff]
/// * [finalFeeCentavos]
/// * [fulfillmentDate]
/// * [arrangement]
/// * [calculationVersion]
/// * [confirmedByRole]
/// * [confirmedAt]
@BuiltValue()
abstract class OrderConfirmedDelivery implements Built<OrderConfirmedDelivery, OrderConfirmedDeliveryBuilder> {
  @BuiltValueField(wireName: r'vehicles')
  BuiltList<OrderDeliveryVehicle> get vehicles;

  @BuiltValueField(wireName: r'distance_meters')
  int get distanceMeters;

  @BuiltValueField(wireName: r'route_source')
  String? get routeSource;

  @BuiltValueField(wireName: r'basis')
  OrderConfirmedDeliveryBasisEnum? get basis;
  // enum basisEnum {  ADVISORY_CONFIRMED,  MANUAL_REVIEW,  ,  };

  @BuiltValueField(wireName: r'endpoint')
  OrderConfirmedDeliveryEndpointEnum? get endpoint;
  // enum endpointEnum {  INTENDED_LOCATION,  ALTERNATE_DROP_OFF,  ,  };

  @BuiltValueField(wireName: r'heavy_vehicle_restriction')
  bool get heavyVehicleRestriction;

  @BuiltValueField(wireName: r'intended')
  OrderPoint? get intended;

  @BuiltValueField(wireName: r'alternate_drop_off')
  OrderPoint? get alternateDropOff;

  @BuiltValueField(wireName: r'final_fee_centavos')
  int get finalFeeCentavos;

  @BuiltValueField(wireName: r'fulfillment_date')
  Date? get fulfillmentDate;

  @BuiltValueField(wireName: r'arrangement')
  String? get arrangement;

  @BuiltValueField(wireName: r'calculation_version')
  String? get calculationVersion;

  @BuiltValueField(wireName: r'confirmed_by_role')
  String? get confirmedByRole;

  @BuiltValueField(wireName: r'confirmed_at')
  DateTime? get confirmedAt;

  OrderConfirmedDelivery._();

  factory OrderConfirmedDelivery([void updates(OrderConfirmedDeliveryBuilder b)]) = _$OrderConfirmedDelivery;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderConfirmedDeliveryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderConfirmedDelivery> get serializer => _$OrderConfirmedDeliverySerializer();
}

class _$OrderConfirmedDeliverySerializer implements PrimitiveSerializer<OrderConfirmedDelivery> {
  @override
  final Iterable<Type> types = const [OrderConfirmedDelivery, _$OrderConfirmedDelivery];

  @override
  final String wireName = r'OrderConfirmedDelivery';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderConfirmedDelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vehicles';
    yield serializers.serialize(
      object.vehicles,
      specifiedType: const FullType(BuiltList, [FullType(OrderDeliveryVehicle)]),
    );
    yield r'distance_meters';
    yield serializers.serialize(
      object.distanceMeters,
      specifiedType: const FullType(int),
    );
    yield r'route_source';
    yield object.routeSource == null ? null : serializers.serialize(
      object.routeSource,
      specifiedType: const FullType.nullable(String),
    );
    yield r'basis';
    yield object.basis == null ? null : serializers.serialize(
      object.basis,
      specifiedType: const FullType.nullable(OrderConfirmedDeliveryBasisEnum),
    );
    yield r'endpoint';
    yield object.endpoint == null ? null : serializers.serialize(
      object.endpoint,
      specifiedType: const FullType.nullable(OrderConfirmedDeliveryEndpointEnum),
    );
    yield r'heavy_vehicle_restriction';
    yield serializers.serialize(
      object.heavyVehicleRestriction,
      specifiedType: const FullType(bool),
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
    yield r'final_fee_centavos';
    yield serializers.serialize(
      object.finalFeeCentavos,
      specifiedType: const FullType(int),
    );
    yield r'fulfillment_date';
    yield object.fulfillmentDate == null ? null : serializers.serialize(
      object.fulfillmentDate,
      specifiedType: const FullType.nullable(Date),
    );
    yield r'arrangement';
    yield object.arrangement == null ? null : serializers.serialize(
      object.arrangement,
      specifiedType: const FullType.nullable(String),
    );
    yield r'calculation_version';
    yield object.calculationVersion == null ? null : serializers.serialize(
      object.calculationVersion,
      specifiedType: const FullType.nullable(String),
    );
    yield r'confirmed_by_role';
    yield object.confirmedByRole == null ? null : serializers.serialize(
      object.confirmedByRole,
      specifiedType: const FullType.nullable(String),
    );
    yield r'confirmed_at';
    yield object.confirmedAt == null ? null : serializers.serialize(
      object.confirmedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderConfirmedDelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderConfirmedDeliveryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vehicles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OrderDeliveryVehicle)]),
          ) as BuiltList<OrderDeliveryVehicle>;
          result.vehicles.replace(valueDes);
          break;
        case r'distance_meters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.distanceMeters = valueDes;
          break;
        case r'route_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.routeSource = valueDes;
          break;
        case r'basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderConfirmedDeliveryBasisEnum),
          ) as OrderConfirmedDeliveryBasisEnum?;
          if (valueDes == null) continue;
          result.basis = valueDes;
          break;
        case r'endpoint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderConfirmedDeliveryEndpointEnum),
          ) as OrderConfirmedDeliveryEndpointEnum?;
          if (valueDes == null) continue;
          result.endpoint = valueDes;
          break;
        case r'heavy_vehicle_restriction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
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
        case r'final_fee_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.finalFeeCentavos = valueDes;
          break;
        case r'fulfillment_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.fulfillmentDate = valueDes;
          break;
        case r'arrangement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.arrangement = valueDes;
          break;
        case r'calculation_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.calculationVersion = valueDes;
          break;
        case r'confirmed_by_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.confirmedByRole = valueDes;
          break;
        case r'confirmed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.confirmedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderConfirmedDelivery deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderConfirmedDeliveryBuilder();
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


class OrderConfirmedDeliveryBasisEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ADVISORY_CONFIRMED')
  static const OrderConfirmedDeliveryBasisEnum ADVISORY_CONFIRMED = _$orderConfirmedDeliveryBasisEnum_ADVISORY_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'MANUAL_REVIEW')
  static const OrderConfirmedDeliveryBasisEnum MANUAL_REVIEW = _$orderConfirmedDeliveryBasisEnum_MANUAL_REVIEW;

  static Serializer<OrderConfirmedDeliveryBasisEnum> get serializer => _$orderConfirmedDeliveryBasisEnumSerializer;

  const OrderConfirmedDeliveryBasisEnum._(String name): super(name);

  static BuiltSet<OrderConfirmedDeliveryBasisEnum> get values => _$orderConfirmedDeliveryBasisEnumValues;
  static OrderConfirmedDeliveryBasisEnum valueOf(String name) => _$orderConfirmedDeliveryBasisEnumValueOf(name);
}

class OrderConfirmedDeliveryEndpointEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INTENDED_LOCATION')
  static const OrderConfirmedDeliveryEndpointEnum INTENDED_LOCATION = _$orderConfirmedDeliveryEndpointEnum_INTENDED_LOCATION;
  @BuiltValueEnumConst(wireName: r'ALTERNATE_DROP_OFF')
  static const OrderConfirmedDeliveryEndpointEnum ALTERNATE_DROP_OFF = _$orderConfirmedDeliveryEndpointEnum_ALTERNATE_DROP_OFF;

  static Serializer<OrderConfirmedDeliveryEndpointEnum> get serializer => _$orderConfirmedDeliveryEndpointEnumSerializer;

  const OrderConfirmedDeliveryEndpointEnum._(String name): super(name);

  static BuiltSet<OrderConfirmedDeliveryEndpointEnum> get values => _$orderConfirmedDeliveryEndpointEnumValues;
  static OrderConfirmedDeliveryEndpointEnum valueOf(String name) => _$orderConfirmedDeliveryEndpointEnumValueOf(name);
}

