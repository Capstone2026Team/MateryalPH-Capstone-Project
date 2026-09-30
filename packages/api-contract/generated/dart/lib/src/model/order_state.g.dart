// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderState _$AWAITING_VENDOR_CONFIRMATION =
    const OrderState._('AWAITING_VENDOR_CONFIRMATION');
const OrderState _$AWAITING_BUYER_APPROVAL =
    const OrderState._('AWAITING_BUYER_APPROVAL');
const OrderState _$AWAITING_NRPC_ACCEPTANCE =
    const OrderState._('AWAITING_NRPC_ACCEPTANCE');
const OrderState _$AWAITING_PAYMENT = const OrderState._('AWAITING_PAYMENT');
const OrderState _$CONFIRMED = const OrderState._('CONFIRMED');
const OrderState _$PROCESSING = const OrderState._('PROCESSING');
const OrderState _$READY_FOR_PICKUP = const OrderState._('READY_FOR_PICKUP');
const OrderState _$OUT_FOR_DELIVERY = const OrderState._('OUT_FOR_DELIVERY');
const OrderState _$DELIVERED = const OrderState._('DELIVERED');
const OrderState _$PICKED_UP = const OrderState._('PICKED_UP');
const OrderState _$COMPLETED = const OrderState._('COMPLETED');
const OrderState _$CANCELLATION_REQUESTED =
    const OrderState._('CANCELLATION_REQUESTED');
const OrderState _$DECLINED = const OrderState._('DECLINED');
const OrderState _$EXPIRED = const OrderState._('EXPIRED');
const OrderState _$CANCELLED = const OrderState._('CANCELLED');
const OrderState _$DISPUTED = const OrderState._('DISPUTED');

OrderState _$valueOf(String name) {
  switch (name) {
    case 'AWAITING_VENDOR_CONFIRMATION':
      return _$AWAITING_VENDOR_CONFIRMATION;
    case 'AWAITING_BUYER_APPROVAL':
      return _$AWAITING_BUYER_APPROVAL;
    case 'AWAITING_NRPC_ACCEPTANCE':
      return _$AWAITING_NRPC_ACCEPTANCE;
    case 'AWAITING_PAYMENT':
      return _$AWAITING_PAYMENT;
    case 'CONFIRMED':
      return _$CONFIRMED;
    case 'PROCESSING':
      return _$PROCESSING;
    case 'READY_FOR_PICKUP':
      return _$READY_FOR_PICKUP;
    case 'OUT_FOR_DELIVERY':
      return _$OUT_FOR_DELIVERY;
    case 'DELIVERED':
      return _$DELIVERED;
    case 'PICKED_UP':
      return _$PICKED_UP;
    case 'COMPLETED':
      return _$COMPLETED;
    case 'CANCELLATION_REQUESTED':
      return _$CANCELLATION_REQUESTED;
    case 'DECLINED':
      return _$DECLINED;
    case 'EXPIRED':
      return _$EXPIRED;
    case 'CANCELLED':
      return _$CANCELLED;
    case 'DISPUTED':
      return _$DISPUTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderState> _$values = BuiltSet<OrderState>(const <OrderState>[
  _$AWAITING_VENDOR_CONFIRMATION,
  _$AWAITING_BUYER_APPROVAL,
  _$AWAITING_NRPC_ACCEPTANCE,
  _$AWAITING_PAYMENT,
  _$CONFIRMED,
  _$PROCESSING,
  _$READY_FOR_PICKUP,
  _$OUT_FOR_DELIVERY,
  _$DELIVERED,
  _$PICKED_UP,
  _$COMPLETED,
  _$CANCELLATION_REQUESTED,
  _$DECLINED,
  _$EXPIRED,
  _$CANCELLED,
  _$DISPUTED,
]);

class _$OrderStateMeta {
  const _$OrderStateMeta();
  OrderState get AWAITING_VENDOR_CONFIRMATION => _$AWAITING_VENDOR_CONFIRMATION;
  OrderState get AWAITING_BUYER_APPROVAL => _$AWAITING_BUYER_APPROVAL;
  OrderState get AWAITING_NRPC_ACCEPTANCE => _$AWAITING_NRPC_ACCEPTANCE;
  OrderState get AWAITING_PAYMENT => _$AWAITING_PAYMENT;
  OrderState get CONFIRMED => _$CONFIRMED;
  OrderState get PROCESSING => _$PROCESSING;
  OrderState get READY_FOR_PICKUP => _$READY_FOR_PICKUP;
  OrderState get OUT_FOR_DELIVERY => _$OUT_FOR_DELIVERY;
  OrderState get DELIVERED => _$DELIVERED;
  OrderState get PICKED_UP => _$PICKED_UP;
  OrderState get COMPLETED => _$COMPLETED;
  OrderState get CANCELLATION_REQUESTED => _$CANCELLATION_REQUESTED;
  OrderState get DECLINED => _$DECLINED;
  OrderState get EXPIRED => _$EXPIRED;
  OrderState get CANCELLED => _$CANCELLED;
  OrderState get DISPUTED => _$DISPUTED;
  OrderState valueOf(String name) => _$valueOf(name);
  BuiltSet<OrderState> get values => _$values;
}

abstract class _$OrderStateMixin {
  // ignore: non_constant_identifier_names
  _$OrderStateMeta get OrderState => const _$OrderStateMeta();
}

Serializer<OrderState> _$orderStateSerializer = _$OrderStateSerializer();

class _$OrderStateSerializer implements PrimitiveSerializer<OrderState> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AWAITING_VENDOR_CONFIRMATION': 'AWAITING_VENDOR_CONFIRMATION',
    'AWAITING_BUYER_APPROVAL': 'AWAITING_BUYER_APPROVAL',
    'AWAITING_NRPC_ACCEPTANCE': 'AWAITING_NRPC_ACCEPTANCE',
    'AWAITING_PAYMENT': 'AWAITING_PAYMENT',
    'CONFIRMED': 'CONFIRMED',
    'PROCESSING': 'PROCESSING',
    'READY_FOR_PICKUP': 'READY_FOR_PICKUP',
    'OUT_FOR_DELIVERY': 'OUT_FOR_DELIVERY',
    'DELIVERED': 'DELIVERED',
    'PICKED_UP': 'PICKED_UP',
    'COMPLETED': 'COMPLETED',
    'CANCELLATION_REQUESTED': 'CANCELLATION_REQUESTED',
    'DECLINED': 'DECLINED',
    'EXPIRED': 'EXPIRED',
    'CANCELLED': 'CANCELLED',
    'DISPUTED': 'DISPUTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AWAITING_VENDOR_CONFIRMATION': 'AWAITING_VENDOR_CONFIRMATION',
    'AWAITING_BUYER_APPROVAL': 'AWAITING_BUYER_APPROVAL',
    'AWAITING_NRPC_ACCEPTANCE': 'AWAITING_NRPC_ACCEPTANCE',
    'AWAITING_PAYMENT': 'AWAITING_PAYMENT',
    'CONFIRMED': 'CONFIRMED',
    'PROCESSING': 'PROCESSING',
    'READY_FOR_PICKUP': 'READY_FOR_PICKUP',
    'OUT_FOR_DELIVERY': 'OUT_FOR_DELIVERY',
    'DELIVERED': 'DELIVERED',
    'PICKED_UP': 'PICKED_UP',
    'COMPLETED': 'COMPLETED',
    'CANCELLATION_REQUESTED': 'CANCELLATION_REQUESTED',
    'DECLINED': 'DECLINED',
    'EXPIRED': 'EXPIRED',
    'CANCELLED': 'CANCELLED',
    'DISPUTED': 'DISPUTED',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderState];
  @override
  final String wireName = 'OrderState';

  @override
  Object serialize(Serializers serializers, OrderState object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderState deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderState.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
