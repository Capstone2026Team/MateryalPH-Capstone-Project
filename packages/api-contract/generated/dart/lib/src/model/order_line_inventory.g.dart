// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_line_inventory.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderLineInventory extends OrderLineInventory {
  @override
  final String quantityOnHand;
  @override
  final String hardReservedQuantity;
  @override
  final String availableToSell;

  factory _$OrderLineInventory(
          [void Function(OrderLineInventoryBuilder)? updates]) =>
      (OrderLineInventoryBuilder()..update(updates))._build();

  _$OrderLineInventory._(
      {required this.quantityOnHand,
      required this.hardReservedQuantity,
      required this.availableToSell})
      : super._();
  @override
  OrderLineInventory rebuild(
          void Function(OrderLineInventoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderLineInventoryBuilder toBuilder() =>
      OrderLineInventoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderLineInventory &&
        quantityOnHand == other.quantityOnHand &&
        hardReservedQuantity == other.hardReservedQuantity &&
        availableToSell == other.availableToSell;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, quantityOnHand.hashCode);
    _$hash = $jc(_$hash, hardReservedQuantity.hashCode);
    _$hash = $jc(_$hash, availableToSell.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderLineInventory')
          ..add('quantityOnHand', quantityOnHand)
          ..add('hardReservedQuantity', hardReservedQuantity)
          ..add('availableToSell', availableToSell))
        .toString();
  }
}

class OrderLineInventoryBuilder
    implements Builder<OrderLineInventory, OrderLineInventoryBuilder> {
  _$OrderLineInventory? _$v;

  String? _quantityOnHand;
  String? get quantityOnHand => _$this._quantityOnHand;
  set quantityOnHand(String? quantityOnHand) =>
      _$this._quantityOnHand = quantityOnHand;

  String? _hardReservedQuantity;
  String? get hardReservedQuantity => _$this._hardReservedQuantity;
  set hardReservedQuantity(String? hardReservedQuantity) =>
      _$this._hardReservedQuantity = hardReservedQuantity;

  String? _availableToSell;
  String? get availableToSell => _$this._availableToSell;
  set availableToSell(String? availableToSell) =>
      _$this._availableToSell = availableToSell;

  OrderLineInventoryBuilder() {
    OrderLineInventory._defaults(this);
  }

  OrderLineInventoryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _quantityOnHand = $v.quantityOnHand;
      _hardReservedQuantity = $v.hardReservedQuantity;
      _availableToSell = $v.availableToSell;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderLineInventory other) {
    _$v = other as _$OrderLineInventory;
  }

  @override
  void update(void Function(OrderLineInventoryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderLineInventory build() => _build();

  _$OrderLineInventory _build() {
    final _$result = _$v ??
        _$OrderLineInventory._(
          quantityOnHand: BuiltValueNullFieldError.checkNotNull(
              quantityOnHand, r'OrderLineInventory', 'quantityOnHand'),
          hardReservedQuantity: BuiltValueNullFieldError.checkNotNull(
              hardReservedQuantity,
              r'OrderLineInventory',
              'hardReservedQuantity'),
          availableToSell: BuiltValueNullFieldError.checkNotNull(
              availableToSell, r'OrderLineInventory', 'availableToSell'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
