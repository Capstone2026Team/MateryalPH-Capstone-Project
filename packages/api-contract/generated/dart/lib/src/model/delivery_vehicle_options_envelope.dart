//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/delivery_vehicle_option.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_vehicle_options_envelope.g.dart';

/// DeliveryVehicleOptionsEnvelope
///
/// Properties:
/// * [data]
@BuiltValue()
abstract class DeliveryVehicleOptionsEnvelope implements Built<DeliveryVehicleOptionsEnvelope, DeliveryVehicleOptionsEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<DeliveryVehicleOption> get data;

  DeliveryVehicleOptionsEnvelope._();

  factory DeliveryVehicleOptionsEnvelope([void updates(DeliveryVehicleOptionsEnvelopeBuilder b)]) = _$DeliveryVehicleOptionsEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryVehicleOptionsEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryVehicleOptionsEnvelope> get serializer => _$DeliveryVehicleOptionsEnvelopeSerializer();
}

class _$DeliveryVehicleOptionsEnvelopeSerializer implements PrimitiveSerializer<DeliveryVehicleOptionsEnvelope> {
  @override
  final Iterable<Type> types = const [DeliveryVehicleOptionsEnvelope, _$DeliveryVehicleOptionsEnvelope];

  @override
  final String wireName = r'DeliveryVehicleOptionsEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryVehicleOptionsEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(DeliveryVehicleOption)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryVehicleOptionsEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryVehicleOptionsEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DeliveryVehicleOption)]),
          ) as BuiltList<DeliveryVehicleOption>;
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
  DeliveryVehicleOptionsEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryVehicleOptionsEnvelopeBuilder();
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


