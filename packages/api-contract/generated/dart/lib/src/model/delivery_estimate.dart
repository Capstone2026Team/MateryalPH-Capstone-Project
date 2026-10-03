//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/delivery_estimate_option.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_estimate.g.dart';

/// Advisory range across the Vendor's eligible vehicles. Not an offer; the Vendor confirms vehicles, trips and the final fee.
///
/// Properties:
/// * [feeMinCentavos]
/// * [feeMaxCentavos]
/// * [tripsMin]
/// * [tripsMax]
/// * [vehiclesMin]
/// * [vehiclesMax]
/// * [options]
@BuiltValue()
abstract class DeliveryEstimate implements Built<DeliveryEstimate, DeliveryEstimateBuilder> {
  @BuiltValueField(wireName: r'fee_min_centavos')
  int get feeMinCentavos;

  @BuiltValueField(wireName: r'fee_max_centavos')
  int get feeMaxCentavos;

  @BuiltValueField(wireName: r'trips_min')
  int get tripsMin;

  @BuiltValueField(wireName: r'trips_max')
  int get tripsMax;

  @BuiltValueField(wireName: r'vehicles_min')
  int get vehiclesMin;

  @BuiltValueField(wireName: r'vehicles_max')
  int get vehiclesMax;

  @BuiltValueField(wireName: r'options')
  BuiltList<DeliveryEstimateOption> get options;

  DeliveryEstimate._();

  factory DeliveryEstimate([void updates(DeliveryEstimateBuilder b)]) = _$DeliveryEstimate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryEstimateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryEstimate> get serializer => _$DeliveryEstimateSerializer();
}

class _$DeliveryEstimateSerializer implements PrimitiveSerializer<DeliveryEstimate> {
  @override
  final Iterable<Type> types = const [DeliveryEstimate, _$DeliveryEstimate];

  @override
  final String wireName = r'DeliveryEstimate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryEstimate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fee_min_centavos';
    yield serializers.serialize(
      object.feeMinCentavos,
      specifiedType: const FullType(int),
    );
    yield r'fee_max_centavos';
    yield serializers.serialize(
      object.feeMaxCentavos,
      specifiedType: const FullType(int),
    );
    yield r'trips_min';
    yield serializers.serialize(
      object.tripsMin,
      specifiedType: const FullType(int),
    );
    yield r'trips_max';
    yield serializers.serialize(
      object.tripsMax,
      specifiedType: const FullType(int),
    );
    yield r'vehicles_min';
    yield serializers.serialize(
      object.vehiclesMin,
      specifiedType: const FullType(int),
    );
    yield r'vehicles_max';
    yield serializers.serialize(
      object.vehiclesMax,
      specifiedType: const FullType(int),
    );
    yield r'options';
    yield serializers.serialize(
      object.options,
      specifiedType: const FullType(BuiltList, [FullType(DeliveryEstimateOption)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryEstimate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryEstimateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fee_min_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.feeMinCentavos = valueDes;
          break;
        case r'fee_max_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.feeMaxCentavos = valueDes;
          break;
        case r'trips_min':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.tripsMin = valueDes;
          break;
        case r'trips_max':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.tripsMax = valueDes;
          break;
        case r'vehicles_min':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vehiclesMin = valueDes;
          break;
        case r'vehicles_max':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vehiclesMax = valueDes;
          break;
        case r'options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DeliveryEstimateOption)]),
          ) as BuiltList<DeliveryEstimateOption>;
          result.options.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryEstimate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryEstimateBuilder();
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


