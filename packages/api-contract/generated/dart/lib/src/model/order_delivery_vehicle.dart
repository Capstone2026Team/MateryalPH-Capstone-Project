//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_delivery_vehicle.g.dart';

/// OrderDeliveryVehicle
///
/// Properties:
/// * [name]
/// * [vehicleCategory]
/// * [vehicleType]
/// * [customTypeName]
/// * [brand]
/// * [capacityKg]
/// * [heavyClassification]
/// * [configurationVersion]
/// * [rateVersion]
/// * [numberOfVehicles]
/// * [totalVehicleTrips]
/// * [perTripCentavos]
/// * [tripTotalCentavos]
@BuiltValue()
abstract class OrderDeliveryVehicle implements Built<OrderDeliveryVehicle, OrderDeliveryVehicleBuilder> {
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'vehicle_category')
  String? get vehicleCategory;

  @BuiltValueField(wireName: r'vehicle_type')
  String? get vehicleType;

  @BuiltValueField(wireName: r'custom_type_name')
  String? get customTypeName;

  @BuiltValueField(wireName: r'brand')
  String? get brand;

  @BuiltValueField(wireName: r'capacity_kg')
  String? get capacityKg;

  @BuiltValueField(wireName: r'heavy_classification')
  String? get heavyClassification;

  @BuiltValueField(wireName: r'configuration_version')
  int? get configurationVersion;

  @BuiltValueField(wireName: r'rate_version')
  int? get rateVersion;

  @BuiltValueField(wireName: r'number_of_vehicles')
  int get numberOfVehicles;

  @BuiltValueField(wireName: r'total_vehicle_trips')
  int get totalVehicleTrips;

  @BuiltValueField(wireName: r'per_trip_centavos')
  int get perTripCentavos;

  @BuiltValueField(wireName: r'trip_total_centavos')
  int get tripTotalCentavos;

  OrderDeliveryVehicle._();

  factory OrderDeliveryVehicle([void updates(OrderDeliveryVehicleBuilder b)]) = _$OrderDeliveryVehicle;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderDeliveryVehicleBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderDeliveryVehicle> get serializer => _$OrderDeliveryVehicleSerializer();
}

class _$OrderDeliveryVehicleSerializer implements PrimitiveSerializer<OrderDeliveryVehicle> {
  @override
  final Iterable<Type> types = const [OrderDeliveryVehicle, _$OrderDeliveryVehicle];

  @override
  final String wireName = r'OrderDeliveryVehicle';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderDeliveryVehicle object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield object.name == null ? null : serializers.serialize(
      object.name,
      specifiedType: const FullType.nullable(String),
    );
    yield r'vehicle_category';
    yield object.vehicleCategory == null ? null : serializers.serialize(
      object.vehicleCategory,
      specifiedType: const FullType.nullable(String),
    );
    yield r'vehicle_type';
    yield object.vehicleType == null ? null : serializers.serialize(
      object.vehicleType,
      specifiedType: const FullType.nullable(String),
    );
    yield r'custom_type_name';
    yield object.customTypeName == null ? null : serializers.serialize(
      object.customTypeName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'brand';
    yield object.brand == null ? null : serializers.serialize(
      object.brand,
      specifiedType: const FullType.nullable(String),
    );
    yield r'capacity_kg';
    yield object.capacityKg == null ? null : serializers.serialize(
      object.capacityKg,
      specifiedType: const FullType.nullable(String),
    );
    yield r'heavy_classification';
    yield object.heavyClassification == null ? null : serializers.serialize(
      object.heavyClassification,
      specifiedType: const FullType.nullable(String),
    );
    yield r'configuration_version';
    yield object.configurationVersion == null ? null : serializers.serialize(
      object.configurationVersion,
      specifiedType: const FullType.nullable(int),
    );
    yield r'rate_version';
    yield object.rateVersion == null ? null : serializers.serialize(
      object.rateVersion,
      specifiedType: const FullType.nullable(int),
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
    yield r'per_trip_centavos';
    yield serializers.serialize(
      object.perTripCentavos,
      specifiedType: const FullType(int),
    );
    yield r'trip_total_centavos';
    yield serializers.serialize(
      object.tripTotalCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderDeliveryVehicle object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderDeliveryVehicleBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'vehicle_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehicleCategory = valueDes;
          break;
        case r'vehicle_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehicleType = valueDes;
          break;
        case r'custom_type_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.customTypeName = valueDes;
          break;
        case r'brand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.brand = valueDes;
          break;
        case r'capacity_kg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.capacityKg = valueDes;
          break;
        case r'heavy_classification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.heavyClassification = valueDes;
          break;
        case r'configuration_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.configurationVersion = valueDes;
          break;
        case r'rate_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.rateVersion = valueDes;
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
        case r'per_trip_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.perTripCentavos = valueDes;
          break;
        case r'trip_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.tripTotalCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderDeliveryVehicle deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderDeliveryVehicleBuilder();
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


