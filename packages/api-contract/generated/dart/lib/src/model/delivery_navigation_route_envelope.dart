//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/delivery_navigation_route.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_navigation_route_envelope.g.dart';

/// DeliveryNavigationRouteEnvelope
///
/// Properties:
/// * [data]
@BuiltValue()
abstract class DeliveryNavigationRouteEnvelope implements Built<DeliveryNavigationRouteEnvelope, DeliveryNavigationRouteEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  DeliveryNavigationRoute get data;

  DeliveryNavigationRouteEnvelope._();

  factory DeliveryNavigationRouteEnvelope([void updates(DeliveryNavigationRouteEnvelopeBuilder b)]) = _$DeliveryNavigationRouteEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryNavigationRouteEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryNavigationRouteEnvelope> get serializer => _$DeliveryNavigationRouteEnvelopeSerializer();
}

class _$DeliveryNavigationRouteEnvelopeSerializer implements PrimitiveSerializer<DeliveryNavigationRouteEnvelope> {
  @override
  final Iterable<Type> types = const [DeliveryNavigationRouteEnvelope, _$DeliveryNavigationRouteEnvelope];

  @override
  final String wireName = r'DeliveryNavigationRouteEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryNavigationRouteEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(DeliveryNavigationRoute),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryNavigationRouteEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryNavigationRouteEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeliveryNavigationRoute),
          ) as DeliveryNavigationRoute;
          result.data.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryNavigationRouteEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryNavigationRouteEnvelopeBuilder();
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


