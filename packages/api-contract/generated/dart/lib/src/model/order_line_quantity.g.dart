// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_line_quantity.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderLineQuantity extends OrderLineQuantity {
  @override
  final String orderLineId;
  @override
  final String confirmedQuantity;

  factory _$OrderLineQuantity(
          [void Function(OrderLineQuantityBuilder)? updates]) =>
      (OrderLineQuantityBuilder()..update(updates))._build();

  _$OrderLineQuantity._(
      {required this.orderLineId, required this.confirmedQuantity})
      : super._();
  @override
  OrderLineQuantity rebuild(void Function(OrderLineQuantityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderLineQuantityBuilder toBuilder() =>
      OrderLineQuantityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderLineQuantity &&
        orderLineId == other.orderLineId &&
        confirmedQuantity == other.confirmedQuantity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderLineId.hashCode);
    _$hash = $jc(_$hash, confirmedQuantity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderLineQuantity')
          ..add('orderLineId', orderLineId)
          ..add('confirmedQuantity', confirmedQuantity))
        .toString();
  }
}

class OrderLineQuantityBuilder
    implements Builder<OrderLineQuantity, OrderLineQuantityBuilder> {
  _$OrderLineQuantity? _$v;

  String? _orderLineId;
  String? get orderLineId => _$this._orderLineId;
  set orderLineId(String? orderLineId) => _$this._orderLineId = orderLineId;

  String? _confirmedQuantity;
  String? get confirmedQuantity => _$this._confirmedQuantity;
  set confirmedQuantity(String? confirmedQuantity) =>
      _$this._confirmedQuantity = confirmedQuantity;

  OrderLineQuantityBuilder() {
    OrderLineQuantity._defaults(this);
  }

  OrderLineQuantityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderLineId = $v.orderLineId;
      _confirmedQuantity = $v.confirmedQuantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderLineQuantity other) {
    _$v = other as _$OrderLineQuantity;
  }

  @override
  void update(void Function(OrderLineQuantityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderLineQuantity build() => _build();

  _$OrderLineQuantity _build() {
    final _$result = _$v ??
        _$OrderLineQuantity._(
          orderLineId: BuiltValueNullFieldError.checkNotNull(
              orderLineId, r'OrderLineQuantity', 'orderLineId'),
          confirmedQuantity: BuiltValueNullFieldError.checkNotNull(
              confirmedQuantity, r'OrderLineQuantity', 'confirmedQuantity'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
