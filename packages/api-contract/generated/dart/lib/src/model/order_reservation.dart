//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_reservation.g.dart';

/// OrderReservation
///
/// Properties:
/// * [orderLineId]
/// * [quantity]
/// * [state]
/// * [releaseReason]
/// * [reservedAt]
/// * [releasedAt]
@BuiltValue()
abstract class OrderReservation implements Built<OrderReservation, OrderReservationBuilder> {
  @BuiltValueField(wireName: r'order_line_id')
  String get orderLineId;

  @BuiltValueField(wireName: r'quantity')
  String get quantity;

  @BuiltValueField(wireName: r'state')
  OrderReservationStateEnum get state;
  // enum stateEnum {  ACTIVE,  RELEASED,  FULFILLED,  };

  @BuiltValueField(wireName: r'release_reason')
  String? get releaseReason;

  @BuiltValueField(wireName: r'reserved_at')
  DateTime? get reservedAt;

  @BuiltValueField(wireName: r'released_at')
  DateTime? get releasedAt;

  OrderReservation._();

  factory OrderReservation([void updates(OrderReservationBuilder b)]) = _$OrderReservation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderReservationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderReservation> get serializer => _$OrderReservationSerializer();
}

class _$OrderReservationSerializer implements PrimitiveSerializer<OrderReservation> {
  @override
  final Iterable<Type> types = const [OrderReservation, _$OrderReservation];

  @override
  final String wireName = r'OrderReservation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderReservation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order_line_id';
    yield serializers.serialize(
      object.orderLineId,
      specifiedType: const FullType(String),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(OrderReservationStateEnum),
    );
    yield r'release_reason';
    yield object.releaseReason == null ? null : serializers.serialize(
      object.releaseReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'reserved_at';
    yield object.reservedAt == null ? null : serializers.serialize(
      object.reservedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'released_at';
    yield object.releasedAt == null ? null : serializers.serialize(
      object.releasedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderReservation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderReservationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'order_line_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderLineId = valueDes;
          break;
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantity = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderReservationStateEnum),
          ) as OrderReservationStateEnum;
          result.state = valueDes;
          break;
        case r'release_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.releaseReason = valueDes;
          break;
        case r'reserved_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.reservedAt = valueDes;
          break;
        case r'released_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.releasedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderReservation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderReservationBuilder();
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


class OrderReservationStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const OrderReservationStateEnum ACTIVE = _$orderReservationStateEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'RELEASED')
  static const OrderReservationStateEnum RELEASED = _$orderReservationStateEnum_RELEASED;
  @BuiltValueEnumConst(wireName: r'FULFILLED')
  static const OrderReservationStateEnum FULFILLED = _$orderReservationStateEnum_FULFILLED;

  static Serializer<OrderReservationStateEnum> get serializer => _$orderReservationStateEnumSerializer;

  const OrderReservationStateEnum._(String name): super(name);

  static BuiltSet<OrderReservationStateEnum> get values => _$orderReservationStateEnumValues;
  static OrderReservationStateEnum valueOf(String name) => _$orderReservationStateEnumValueOf(name);
}

