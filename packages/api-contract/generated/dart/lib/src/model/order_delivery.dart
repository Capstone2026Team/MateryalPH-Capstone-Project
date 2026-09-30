//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/order_confirmed_delivery.dart';
import 'package:materyalph_api_client/src/model/order_delivery_estimate.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_delivery.g.dart';

/// OrderDelivery
///
/// Properties:
/// * [status]
/// * [estimate]
/// * [confirmed]
@BuiltValue()
abstract class OrderDelivery implements Built<OrderDelivery, OrderDeliveryBuilder> {
  @BuiltValueField(wireName: r'status')
  OrderDeliveryStatusEnum get status;
  // enum statusEnum {  NOT_APPLICABLE,  ADVISORY_ESTIMATE,  PENDING_VENDOR_REVIEW,  CONFIRMED,  };

  @BuiltValueField(wireName: r'estimate')
  OrderDeliveryEstimate? get estimate;

  @BuiltValueField(wireName: r'confirmed')
  OrderConfirmedDelivery? get confirmed;

  OrderDelivery._();

  factory OrderDelivery([void updates(OrderDeliveryBuilder b)]) = _$OrderDelivery;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderDeliveryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderDelivery> get serializer => _$OrderDeliverySerializer();
}

class _$OrderDeliverySerializer implements PrimitiveSerializer<OrderDelivery> {
  @override
  final Iterable<Type> types = const [OrderDelivery, _$OrderDelivery];

  @override
  final String wireName = r'OrderDelivery';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderDelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(OrderDeliveryStatusEnum),
    );
    yield r'estimate';
    yield object.estimate == null ? null : serializers.serialize(
      object.estimate,
      specifiedType: const FullType.nullable(OrderDeliveryEstimate),
    );
    yield r'confirmed';
    yield object.confirmed == null ? null : serializers.serialize(
      object.confirmed,
      specifiedType: const FullType.nullable(OrderConfirmedDelivery),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderDelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderDeliveryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderDeliveryStatusEnum),
          ) as OrderDeliveryStatusEnum;
          result.status = valueDes;
          break;
        case r'estimate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderDeliveryEstimate),
          ) as OrderDeliveryEstimate?;
          if (valueDes == null) continue;
          result.estimate.replace(valueDes);
          break;
        case r'confirmed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderConfirmedDelivery),
          ) as OrderConfirmedDelivery?;
          if (valueDes == null) continue;
          result.confirmed.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderDelivery deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderDeliveryBuilder();
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


class OrderDeliveryStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_APPLICABLE')
  static const OrderDeliveryStatusEnum NOT_APPLICABLE = _$orderDeliveryStatusEnum_NOT_APPLICABLE;
  @BuiltValueEnumConst(wireName: r'ADVISORY_ESTIMATE')
  static const OrderDeliveryStatusEnum ADVISORY_ESTIMATE = _$orderDeliveryStatusEnum_ADVISORY_ESTIMATE;
  @BuiltValueEnumConst(wireName: r'PENDING_VENDOR_REVIEW')
  static const OrderDeliveryStatusEnum PENDING_VENDOR_REVIEW = _$orderDeliveryStatusEnum_PENDING_VENDOR_REVIEW;
  @BuiltValueEnumConst(wireName: r'CONFIRMED')
  static const OrderDeliveryStatusEnum CONFIRMED = _$orderDeliveryStatusEnum_CONFIRMED;

  static Serializer<OrderDeliveryStatusEnum> get serializer => _$orderDeliveryStatusEnumSerializer;

  const OrderDeliveryStatusEnum._(String name): super(name);

  static BuiltSet<OrderDeliveryStatusEnum> get values => _$orderDeliveryStatusEnumValues;
  static OrderDeliveryStatusEnum valueOf(String name) => _$orderDeliveryStatusEnumValueOf(name);
}

