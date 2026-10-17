//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/delivery_estimate_option.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_delivery_estimate.g.dart';

/// OrderDeliveryEstimate
///
/// Properties:
/// * [options] - Frozen system recommendation; absent on historical orders.
/// * [feeMinCentavos]
/// * [feeMaxCentavos]
/// * [tripsMin]
/// * [tripsMax]
@BuiltValue()
abstract class OrderDeliveryEstimate implements Built<OrderDeliveryEstimate, OrderDeliveryEstimateBuilder> {
  /// Frozen system recommendation; absent on historical orders.
  @BuiltValueField(wireName: r'options')
  BuiltList<DeliveryEstimateOption>? get options;

  @BuiltValueField(wireName: r'fee_min_centavos')
  int get feeMinCentavos;

  @BuiltValueField(wireName: r'fee_max_centavos')
  int get feeMaxCentavos;

  @BuiltValueField(wireName: r'trips_min')
  int get tripsMin;

  @BuiltValueField(wireName: r'trips_max')
  int get tripsMax;

  OrderDeliveryEstimate._();

  factory OrderDeliveryEstimate([void updates(OrderDeliveryEstimateBuilder b)]) = _$OrderDeliveryEstimate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderDeliveryEstimateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderDeliveryEstimate> get serializer => _$OrderDeliveryEstimateSerializer();
}

class _$OrderDeliveryEstimateSerializer implements PrimitiveSerializer<OrderDeliveryEstimate> {
  @override
  final Iterable<Type> types = const [OrderDeliveryEstimate, _$OrderDeliveryEstimate];

  @override
  final String wireName = r'OrderDeliveryEstimate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderDeliveryEstimate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.options != null) {
      yield r'options';
      yield serializers.serialize(
        object.options,
        specifiedType: const FullType(BuiltList, [FullType(DeliveryEstimateOption)]),
      );
    }
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
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderDeliveryEstimate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderDeliveryEstimateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(DeliveryEstimateOption)]),
          ) as BuiltList<DeliveryEstimateOption>?;
          if (valueDes == null) continue;
          result.options.replace(valueDes);
          break;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderDeliveryEstimate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderDeliveryEstimateBuilder();
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


