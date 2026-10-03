// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_reservation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderReservationStateEnum _$orderReservationStateEnum_ACTIVE =
    const OrderReservationStateEnum._('ACTIVE');
const OrderReservationStateEnum _$orderReservationStateEnum_RELEASED =
    const OrderReservationStateEnum._('RELEASED');
const OrderReservationStateEnum _$orderReservationStateEnum_FULFILLED =
    const OrderReservationStateEnum._('FULFILLED');

OrderReservationStateEnum _$orderReservationStateEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$orderReservationStateEnum_ACTIVE;
    case 'RELEASED':
      return _$orderReservationStateEnum_RELEASED;
    case 'FULFILLED':
      return _$orderReservationStateEnum_FULFILLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderReservationStateEnum> _$orderReservationStateEnumValues =
    BuiltSet<OrderReservationStateEnum>(const <OrderReservationStateEnum>[
  _$orderReservationStateEnum_ACTIVE,
  _$orderReservationStateEnum_RELEASED,
  _$orderReservationStateEnum_FULFILLED,
]);

Serializer<OrderReservationStateEnum> _$orderReservationStateEnumSerializer =
    _$OrderReservationStateEnumSerializer();

class _$OrderReservationStateEnumSerializer
    implements PrimitiveSerializer<OrderReservationStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'RELEASED': 'RELEASED',
    'FULFILLED': 'FULFILLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'RELEASED': 'RELEASED',
    'FULFILLED': 'FULFILLED',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderReservationStateEnum];
  @override
  final String wireName = 'OrderReservationStateEnum';

  @override
  Object serialize(Serializers serializers, OrderReservationStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderReservationStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderReservationStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderReservation extends OrderReservation {
  @override
  final String orderLineId;
  @override
  final String quantity;
  @override
  final OrderReservationStateEnum state;
  @override
  final String? releaseReason;
  @override
  final DateTime? reservedAt;
  @override
  final DateTime? releasedAt;

  factory _$OrderReservation(
          [void Function(OrderReservationBuilder)? updates]) =>
      (OrderReservationBuilder()..update(updates))._build();

  _$OrderReservation._(
      {required this.orderLineId,
      required this.quantity,
      required this.state,
      this.releaseReason,
      this.reservedAt,
      this.releasedAt})
      : super._();
  @override
  OrderReservation rebuild(void Function(OrderReservationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderReservationBuilder toBuilder() =>
      OrderReservationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderReservation &&
        orderLineId == other.orderLineId &&
        quantity == other.quantity &&
        state == other.state &&
        releaseReason == other.releaseReason &&
        reservedAt == other.reservedAt &&
        releasedAt == other.releasedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderLineId.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, releaseReason.hashCode);
    _$hash = $jc(_$hash, reservedAt.hashCode);
    _$hash = $jc(_$hash, releasedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderReservation')
          ..add('orderLineId', orderLineId)
          ..add('quantity', quantity)
          ..add('state', state)
          ..add('releaseReason', releaseReason)
          ..add('reservedAt', reservedAt)
          ..add('releasedAt', releasedAt))
        .toString();
  }
}

class OrderReservationBuilder
    implements Builder<OrderReservation, OrderReservationBuilder> {
  _$OrderReservation? _$v;

  String? _orderLineId;
  String? get orderLineId => _$this._orderLineId;
  set orderLineId(String? orderLineId) => _$this._orderLineId = orderLineId;

  String? _quantity;
  String? get quantity => _$this._quantity;
  set quantity(String? quantity) => _$this._quantity = quantity;

  OrderReservationStateEnum? _state;
  OrderReservationStateEnum? get state => _$this._state;
  set state(OrderReservationStateEnum? state) => _$this._state = state;

  String? _releaseReason;
  String? get releaseReason => _$this._releaseReason;
  set releaseReason(String? releaseReason) =>
      _$this._releaseReason = releaseReason;

  DateTime? _reservedAt;
  DateTime? get reservedAt => _$this._reservedAt;
  set reservedAt(DateTime? reservedAt) => _$this._reservedAt = reservedAt;

  DateTime? _releasedAt;
  DateTime? get releasedAt => _$this._releasedAt;
  set releasedAt(DateTime? releasedAt) => _$this._releasedAt = releasedAt;

  OrderReservationBuilder() {
    OrderReservation._defaults(this);
  }

  OrderReservationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderLineId = $v.orderLineId;
      _quantity = $v.quantity;
      _state = $v.state;
      _releaseReason = $v.releaseReason;
      _reservedAt = $v.reservedAt;
      _releasedAt = $v.releasedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderReservation other) {
    _$v = other as _$OrderReservation;
  }

  @override
  void update(void Function(OrderReservationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderReservation build() => _build();

  _$OrderReservation _build() {
    final _$result = _$v ??
        _$OrderReservation._(
          orderLineId: BuiltValueNullFieldError.checkNotNull(
              orderLineId, r'OrderReservation', 'orderLineId'),
          quantity: BuiltValueNullFieldError.checkNotNull(
              quantity, r'OrderReservation', 'quantity'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'OrderReservation', 'state'),
          releaseReason: releaseReason,
          reservedAt: reservedAt,
          releasedAt: releasedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
