// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_state_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderStateRowFamilyEnum _$orderStateRowFamilyEnum_ORDER =
    const OrderStateRowFamilyEnum._('ORDER');
const OrderStateRowFamilyEnum _$orderStateRowFamilyEnum_PAYMENT =
    const OrderStateRowFamilyEnum._('PAYMENT');
const OrderStateRowFamilyEnum _$orderStateRowFamilyEnum_FULFILLMENT =
    const OrderStateRowFamilyEnum._('FULFILLMENT');
const OrderStateRowFamilyEnum _$orderStateRowFamilyEnum_REFUND =
    const OrderStateRowFamilyEnum._('REFUND');
const OrderStateRowFamilyEnum _$orderStateRowFamilyEnum_DISPUTE =
    const OrderStateRowFamilyEnum._('DISPUTE');

OrderStateRowFamilyEnum _$orderStateRowFamilyEnumValueOf(String name) {
  switch (name) {
    case 'ORDER':
      return _$orderStateRowFamilyEnum_ORDER;
    case 'PAYMENT':
      return _$orderStateRowFamilyEnum_PAYMENT;
    case 'FULFILLMENT':
      return _$orderStateRowFamilyEnum_FULFILLMENT;
    case 'REFUND':
      return _$orderStateRowFamilyEnum_REFUND;
    case 'DISPUTE':
      return _$orderStateRowFamilyEnum_DISPUTE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderStateRowFamilyEnum> _$orderStateRowFamilyEnumValues =
    BuiltSet<OrderStateRowFamilyEnum>(const <OrderStateRowFamilyEnum>[
  _$orderStateRowFamilyEnum_ORDER,
  _$orderStateRowFamilyEnum_PAYMENT,
  _$orderStateRowFamilyEnum_FULFILLMENT,
  _$orderStateRowFamilyEnum_REFUND,
  _$orderStateRowFamilyEnum_DISPUTE,
]);

Serializer<OrderStateRowFamilyEnum> _$orderStateRowFamilyEnumSerializer =
    _$OrderStateRowFamilyEnumSerializer();

class _$OrderStateRowFamilyEnumSerializer
    implements PrimitiveSerializer<OrderStateRowFamilyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ORDER': 'ORDER',
    'PAYMENT': 'PAYMENT',
    'FULFILLMENT': 'FULFILLMENT',
    'REFUND': 'REFUND',
    'DISPUTE': 'DISPUTE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ORDER': 'ORDER',
    'PAYMENT': 'PAYMENT',
    'FULFILLMENT': 'FULFILLMENT',
    'REFUND': 'REFUND',
    'DISPUTE': 'DISPUTE',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderStateRowFamilyEnum];
  @override
  final String wireName = 'OrderStateRowFamilyEnum';

  @override
  Object serialize(Serializers serializers, OrderStateRowFamilyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderStateRowFamilyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderStateRowFamilyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderStateRow extends OrderStateRow {
  @override
  final OrderStateRowFamilyEnum family;
  @override
  final String state;

  factory _$OrderStateRow([void Function(OrderStateRowBuilder)? updates]) =>
      (OrderStateRowBuilder()..update(updates))._build();

  _$OrderStateRow._({required this.family, required this.state}) : super._();
  @override
  OrderStateRow rebuild(void Function(OrderStateRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderStateRowBuilder toBuilder() => OrderStateRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderStateRow &&
        family == other.family &&
        state == other.state;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, family.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderStateRow')
          ..add('family', family)
          ..add('state', state))
        .toString();
  }
}

class OrderStateRowBuilder
    implements Builder<OrderStateRow, OrderStateRowBuilder> {
  _$OrderStateRow? _$v;

  OrderStateRowFamilyEnum? _family;
  OrderStateRowFamilyEnum? get family => _$this._family;
  set family(OrderStateRowFamilyEnum? family) => _$this._family = family;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

  OrderStateRowBuilder() {
    OrderStateRow._defaults(this);
  }

  OrderStateRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _family = $v.family;
      _state = $v.state;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderStateRow other) {
    _$v = other as _$OrderStateRow;
  }

  @override
  void update(void Function(OrderStateRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderStateRow build() => _build();

  _$OrderStateRow _build() {
    final _$result = _$v ??
        _$OrderStateRow._(
          family: BuiltValueNullFieldError.checkNotNull(
              family, r'OrderStateRow', 'family'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'OrderStateRow', 'state'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
