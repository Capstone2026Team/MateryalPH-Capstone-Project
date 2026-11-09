//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/delivery_navigation_route_point.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_location_map.g.dart';

/// Vendor order-detail-only map points. The destination is the saved intended site or alternate drop-off selected by the heavy-vehicle declaration, never device GPS. Pickup has no Buyer destination.
///
/// Properties:
/// * [store]
/// * [destination]
@BuiltValue()
abstract class OrderLocationMap implements Built<OrderLocationMap, OrderLocationMapBuilder> {
  @BuiltValueField(wireName: r'store')
  DeliveryNavigationRoutePoint? get store;

  @BuiltValueField(wireName: r'destination')
  DeliveryNavigationRoutePoint? get destination;

  OrderLocationMap._();

  factory OrderLocationMap([void updates(OrderLocationMapBuilder b)]) = _$OrderLocationMap;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderLocationMapBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderLocationMap> get serializer => _$OrderLocationMapSerializer();
}

class _$OrderLocationMapSerializer implements PrimitiveSerializer<OrderLocationMap> {
  @override
  final Iterable<Type> types = const [OrderLocationMap, _$OrderLocationMap];

  @override
  final String wireName = r'OrderLocationMap';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderLocationMap object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'store';
    yield object.store == null ? null : serializers.serialize(
      object.store,
      specifiedType: const FullType.nullable(DeliveryNavigationRoutePoint),
    );
    yield r'destination';
    yield object.destination == null ? null : serializers.serialize(
      object.destination,
      specifiedType: const FullType.nullable(DeliveryNavigationRoutePoint),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderLocationMap object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderLocationMapBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'store':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DeliveryNavigationRoutePoint),
          ) as DeliveryNavigationRoutePoint?;
          if (valueDes == null) continue;
          result.store.replace(valueDes);
          break;
        case r'destination':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DeliveryNavigationRoutePoint),
          ) as DeliveryNavigationRoutePoint?;
          if (valueDes == null) continue;
          result.destination.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderLocationMap deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderLocationMapBuilder();
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


