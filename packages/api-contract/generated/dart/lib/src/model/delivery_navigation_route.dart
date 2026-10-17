//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/delivery_navigation_route_point.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_navigation_route.g.dart';

/// DeliveryNavigationRoute
///
/// Properties:
/// * [origin]
/// * [destination]
/// * [distanceMeters]
/// * [durationSeconds]
/// * [encodedPolyline]
/// * [durationBasis]
/// * [computedAt]
@BuiltValue()
abstract class DeliveryNavigationRoute implements Built<DeliveryNavigationRoute, DeliveryNavigationRouteBuilder> {
  @BuiltValueField(wireName: r'origin')
  DeliveryNavigationRoutePoint get origin;

  @BuiltValueField(wireName: r'destination')
  DeliveryNavigationRoutePoint get destination;

  @BuiltValueField(wireName: r'distance_meters')
  int get distanceMeters;

  @BuiltValueField(wireName: r'duration_seconds')
  int get durationSeconds;

  @BuiltValueField(wireName: r'encoded_polyline')
  String get encodedPolyline;

  @BuiltValueField(wireName: r'duration_basis')
  String get durationBasis;

  @BuiltValueField(wireName: r'computed_at')
  DateTime get computedAt;

  DeliveryNavigationRoute._();

  factory DeliveryNavigationRoute([void updates(DeliveryNavigationRouteBuilder b)]) = _$DeliveryNavigationRoute;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryNavigationRouteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryNavigationRoute> get serializer => _$DeliveryNavigationRouteSerializer();
}

class _$DeliveryNavigationRouteSerializer implements PrimitiveSerializer<DeliveryNavigationRoute> {
  @override
  final Iterable<Type> types = const [DeliveryNavigationRoute, _$DeliveryNavigationRoute];

  @override
  final String wireName = r'DeliveryNavigationRoute';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryNavigationRoute object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'origin';
    yield serializers.serialize(
      object.origin,
      specifiedType: const FullType(DeliveryNavigationRoutePoint),
    );
    yield r'destination';
    yield serializers.serialize(
      object.destination,
      specifiedType: const FullType(DeliveryNavigationRoutePoint),
    );
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
    yield r'encoded_polyline';
    yield serializers.serialize(
      object.encodedPolyline,
      specifiedType: const FullType(String),
    );
    yield r'duration_basis';
    yield serializers.serialize(
      object.durationBasis,
      specifiedType: const FullType(String),
    );
    yield r'computed_at';
    yield serializers.serialize(
      object.computedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryNavigationRoute object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryNavigationRouteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeliveryNavigationRoutePoint),
          ) as DeliveryNavigationRoutePoint;
          result.origin.replace(valueDes);
          break;
        case r'destination':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeliveryNavigationRoutePoint),
          ) as DeliveryNavigationRoutePoint;
          result.destination.replace(valueDes);
          break;
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
        case r'encoded_polyline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.encodedPolyline = valueDes;
          break;
        case r'duration_basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.durationBasis = valueDes;
          break;
        case r'computed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.computedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryNavigationRoute deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryNavigationRouteBuilder();
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


