//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_navigation_route_point.g.dart';

/// DeliveryNavigationRoutePoint
///
/// Properties:
/// * [latitude]
/// * [longitude]
/// * [label]
@BuiltValue()
abstract class DeliveryNavigationRoutePoint implements Built<DeliveryNavigationRoutePoint, DeliveryNavigationRoutePointBuilder> {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  @BuiltValueField(wireName: r'label')
  String get label;

  DeliveryNavigationRoutePoint._();

  factory DeliveryNavigationRoutePoint([void updates(DeliveryNavigationRoutePointBuilder b)]) = _$DeliveryNavigationRoutePoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryNavigationRoutePointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryNavigationRoutePoint> get serializer => _$DeliveryNavigationRoutePointSerializer();
}

class _$DeliveryNavigationRoutePointSerializer implements PrimitiveSerializer<DeliveryNavigationRoutePoint> {
  @override
  final Iterable<Type> types = const [DeliveryNavigationRoutePoint, _$DeliveryNavigationRoutePoint];

  @override
  final String wireName = r'DeliveryNavigationRoutePoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryNavigationRoutePoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryNavigationRoutePoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryNavigationRoutePointBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.longitude = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryNavigationRoutePoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryNavigationRoutePointBuilder();
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


