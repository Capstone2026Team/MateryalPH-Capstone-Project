//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_plan_route.g.dart';

/// DeliveryPlanRoute
///
/// Properties:
/// * [distanceMeters]
/// * [durationSeconds]
/// * [basis]
/// * [source_]
@BuiltValue()
abstract class DeliveryPlanRoute implements Built<DeliveryPlanRoute, DeliveryPlanRouteBuilder> {
  @BuiltValueField(wireName: r'distance_meters')
  int get distanceMeters;

  @BuiltValueField(wireName: r'duration_seconds')
  int get durationSeconds;

  @BuiltValueField(wireName: r'basis')
  DeliveryPlanRouteBasisEnum get basis;
  // enum basisEnum {  ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF,  };

  @BuiltValueField(wireName: r'source')
  String get source_;

  DeliveryPlanRoute._();

  factory DeliveryPlanRoute([void updates(DeliveryPlanRouteBuilder b)]) = _$DeliveryPlanRoute;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryPlanRouteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryPlanRoute> get serializer => _$DeliveryPlanRouteSerializer();
}

class _$DeliveryPlanRouteSerializer implements PrimitiveSerializer<DeliveryPlanRoute> {
  @override
  final Iterable<Type> types = const [DeliveryPlanRoute, _$DeliveryPlanRoute];

  @override
  final String wireName = r'DeliveryPlanRoute';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryPlanRoute object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'distance_meters';
    yield serializers.serialize(
      object.distanceMeters,
      specifiedType: const FullType(int),
    );
    yield r'duration_seconds';
    yield serializers.serialize(
      object.durationSeconds,
      specifiedType: const FullType(int),
    );
    yield r'basis';
    yield serializers.serialize(
      object.basis,
      specifiedType: const FullType(DeliveryPlanRouteBasisEnum),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryPlanRoute object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryPlanRouteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'distance_meters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.distanceMeters = valueDes;
          break;
        case r'duration_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.durationSeconds = valueDes;
          break;
        case r'basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeliveryPlanRouteBasisEnum),
          ) as DeliveryPlanRouteBasisEnum;
          result.basis = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.source_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryPlanRoute deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryPlanRouteBuilder();
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


class DeliveryPlanRouteBasisEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF')
  static const DeliveryPlanRouteBasisEnum ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF = _$deliveryPlanRouteBasisEnum_ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF;

  static Serializer<DeliveryPlanRouteBasisEnum> get serializer => _$deliveryPlanRouteBasisEnumSerializer;

  const DeliveryPlanRouteBasisEnum._(String name): super(name);

  static BuiltSet<DeliveryPlanRouteBasisEnum> get values => _$deliveryPlanRouteBasisEnumValues;
  static DeliveryPlanRouteBasisEnum valueOf(String name) => _$deliveryPlanRouteBasisEnumValueOf(name);
}

