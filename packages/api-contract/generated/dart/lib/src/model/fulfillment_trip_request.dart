//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fulfillment_trip_request.g.dart';

/// FulfillmentTripRequest
///
/// Properties:
/// * [vehicleIndex]
/// * [tripNumber]
@BuiltValue()
abstract class FulfillmentTripRequest implements Built<FulfillmentTripRequest, FulfillmentTripRequestBuilder> {
  @BuiltValueField(wireName: r'vehicle_index')
  int get vehicleIndex;

  @BuiltValueField(wireName: r'trip_number')
  int get tripNumber;

  FulfillmentTripRequest._();

  factory FulfillmentTripRequest([void updates(FulfillmentTripRequestBuilder b)]) = _$FulfillmentTripRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FulfillmentTripRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FulfillmentTripRequest> get serializer => _$FulfillmentTripRequestSerializer();
}

class _$FulfillmentTripRequestSerializer implements PrimitiveSerializer<FulfillmentTripRequest> {
  @override
  final Iterable<Type> types = const [FulfillmentTripRequest, _$FulfillmentTripRequest];

  @override
  final String wireName = r'FulfillmentTripRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FulfillmentTripRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vehicle_index';
    yield serializers.serialize(
      object.vehicleIndex,
      specifiedType: const FullType(int),
    );
    yield r'trip_number';
    yield serializers.serialize(
      object.tripNumber,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FulfillmentTripRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FulfillmentTripRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vehicle_index':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vehicleIndex = valueDes;
          break;
        case r'trip_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.tripNumber = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FulfillmentTripRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FulfillmentTripRequestBuilder();
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


