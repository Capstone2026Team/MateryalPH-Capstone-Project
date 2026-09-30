// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_payment_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderPaymentState _$NOT_REQUIRED =
    const OrderPaymentState._('NOT_REQUIRED');
const OrderPaymentState _$PENDING = const OrderPaymentState._('PENDING');
const OrderPaymentState _$PAID = const OrderPaymentState._('PAID');
const OrderPaymentState _$FAILED = const OrderPaymentState._('FAILED');
const OrderPaymentState _$EXPIRED = const OrderPaymentState._('EXPIRED');

OrderPaymentState _$valueOf(String name) {
  switch (name) {
    case 'NOT_REQUIRED':
      return _$NOT_REQUIRED;
    case 'PENDING':
      return _$PENDING;
    case 'PAID':
      return _$PAID;
    case 'FAILED':
      return _$FAILED;
    case 'EXPIRED':
      return _$EXPIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderPaymentState> _$values =
    BuiltSet<OrderPaymentState>(const <OrderPaymentState>[
  _$NOT_REQUIRED,
  _$PENDING,
  _$PAID,
  _$FAILED,
  _$EXPIRED,
]);

class _$OrderPaymentStateMeta {
  const _$OrderPaymentStateMeta();
  OrderPaymentState get NOT_REQUIRED => _$NOT_REQUIRED;
  OrderPaymentState get PENDING => _$PENDING;
  OrderPaymentState get PAID => _$PAID;
  OrderPaymentState get FAILED => _$FAILED;
  OrderPaymentState get EXPIRED => _$EXPIRED;
  OrderPaymentState valueOf(String name) => _$valueOf(name);
  BuiltSet<OrderPaymentState> get values => _$values;
}

abstract class _$OrderPaymentStateMixin {
  // ignore: non_constant_identifier_names
  _$OrderPaymentStateMeta get OrderPaymentState =>
      const _$OrderPaymentStateMeta();
}

Serializer<OrderPaymentState> _$orderPaymentStateSerializer =
    _$OrderPaymentStateSerializer();

class _$OrderPaymentStateSerializer
    implements PrimitiveSerializer<OrderPaymentState> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_REQUIRED': 'NOT_REQUIRED',
    'PENDING': 'PENDING',
    'PAID': 'PAID',
    'FAILED': 'FAILED',
    'EXPIRED': 'EXPIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_REQUIRED': 'NOT_REQUIRED',
    'PENDING': 'PENDING',
    'PAID': 'PAID',
    'FAILED': 'FAILED',
    'EXPIRED': 'EXPIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderPaymentState];
  @override
  final String wireName = 'OrderPaymentState';

  @override
  Object serialize(Serializers serializers, OrderPaymentState object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderPaymentState deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderPaymentState.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
