//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_route.g.dart';

/// DeliveryRoute
///
/// Properties:
/// * [distanceMeters]
/// * [durationSeconds]
/// * [basis]
/// * [source_]
/// * [computedAt]
/// * [cached]
@BuiltValue()
abstract class DeliveryRoute implements Built<DeliveryRoute, DeliveryRouteBuilder> {
  @BuiltValueField(wireName: r'distance_meters')
  int get distanceMeters;

  @BuiltValueField(wireName: r'duration_seconds')
  int get durationSeconds;

  @BuiltValueField(wireName: r'basis')
  DeliveryRouteBasisEnum get basis;
  // enum basisEnum {  ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF,  };

  @BuiltValueField(wireName: r'source')
  DeliveryRouteSource_Enum get source_;
  // enum source_Enum {  GOOGLE_ROUTES,  };

  @BuiltValueField(wireName: r'computed_at')
  DateTime get computedAt;

  @BuiltValueField(wireName: r'cached')
  bool get cached;

  DeliveryRoute._();

  factory DeliveryRoute([void updates(DeliveryRouteBuilder b)]) = _$DeliveryRoute;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryRouteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryRoute> get serializer => _$DeliveryRouteSerializer();
}

class _$DeliveryRouteSerializer implements PrimitiveSerializer<DeliveryRoute> {
  @override
  final Iterable<Type> types = const [DeliveryRoute, _$DeliveryRoute];

  @override
  final String wireName = r'DeliveryRoute';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryRoute object, {
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
      specifiedType: const FullType(DeliveryRouteBasisEnum),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(DeliveryRouteSource_Enum),
    );
    yield r'computed_at';
    yield serializers.serialize(
      object.computedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'cached';
    yield serializers.serialize(
      object.cached,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryRoute object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryRouteBuilder result,
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
            specifiedType: const FullType(DeliveryRouteBasisEnum),
          ) as DeliveryRouteBasisEnum;
          result.basis = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeliveryRouteSource_Enum),
          ) as DeliveryRouteSource_Enum;
          result.source_ = valueDes;
          break;
        case r'computed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.computedAt = valueDes;
          break;
        case r'cached':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.cached = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryRoute deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryRouteBuilder();
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


class DeliveryRouteBasisEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF')
  static const DeliveryRouteBasisEnum ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF = _$deliveryRouteBasisEnum_ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF;

  static Serializer<DeliveryRouteBasisEnum> get serializer => _$deliveryRouteBasisEnumSerializer;

  const DeliveryRouteBasisEnum._(String name): super(name);

  static BuiltSet<DeliveryRouteBasisEnum> get values => _$deliveryRouteBasisEnumValues;
  static DeliveryRouteBasisEnum valueOf(String name) => _$deliveryRouteBasisEnumValueOf(name);
}

class DeliveryRouteSource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'GOOGLE_ROUTES')
  static const DeliveryRouteSource_Enum GOOGLE_ROUTES = _$deliveryRouteSourceEnum_GOOGLE_ROUTES;

  static Serializer<DeliveryRouteSource_Enum> get serializer => _$deliveryRouteSourceEnumSerializer;

  const DeliveryRouteSource_Enum._(String name): super(name);

  static BuiltSet<DeliveryRouteSource_Enum> get values => _$deliveryRouteSourceEnumValues;
  static DeliveryRouteSource_Enum valueOf(String name) => _$deliveryRouteSourceEnumValueOf(name);
}

