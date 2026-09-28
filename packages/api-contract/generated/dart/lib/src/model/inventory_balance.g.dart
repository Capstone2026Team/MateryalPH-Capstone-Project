// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_balance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventoryBalance extends InventoryBalance {
  @override
  final String quantityOnHand;
  @override
  final String hardReservedQuantity;
  @override
  final String softHeldQuantity;
  @override
  final String availableToSell;
  @override
  final String? reorderLevel;
  @override
  final DateTime? confirmedAt;
  @override
  final String? updatedAt;

  factory _$InventoryBalance(
          [void Function(InventoryBalanceBuilder)? updates]) =>
      (InventoryBalanceBuilder()..update(updates))._build();

  _$InventoryBalance._(
      {required this.quantityOnHand,
      required this.hardReservedQuantity,
      required this.softHeldQuantity,
      required this.availableToSell,
      this.reorderLevel,
      this.confirmedAt,
      this.updatedAt})
      : super._();
  @override
  InventoryBalance rebuild(void Function(InventoryBalanceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryBalanceBuilder toBuilder() =>
      InventoryBalanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryBalance &&
        quantityOnHand == other.quantityOnHand &&
        hardReservedQuantity == other.hardReservedQuantity &&
        softHeldQuantity == other.softHeldQuantity &&
        availableToSell == other.availableToSell &&
        reorderLevel == other.reorderLevel &&
        confirmedAt == other.confirmedAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, quantityOnHand.hashCode);
    _$hash = $jc(_$hash, hardReservedQuantity.hashCode);
    _$hash = $jc(_$hash, softHeldQuantity.hashCode);
    _$hash = $jc(_$hash, availableToSell.hashCode);
    _$hash = $jc(_$hash, reorderLevel.hashCode);
    _$hash = $jc(_$hash, confirmedAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryBalance')
          ..add('quantityOnHand', quantityOnHand)
          ..add('hardReservedQuantity', hardReservedQuantity)
          ..add('softHeldQuantity', softHeldQuantity)
          ..add('availableToSell', availableToSell)
          ..add('reorderLevel', reorderLevel)
          ..add('confirmedAt', confirmedAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class InventoryBalanceBuilder
    implements Builder<InventoryBalance, InventoryBalanceBuilder> {
  _$InventoryBalance? _$v;

  String? _quantityOnHand;
  String? get quantityOnHand => _$this._quantityOnHand;
  set quantityOnHand(String? quantityOnHand) =>
      _$this._quantityOnHand = quantityOnHand;

  String? _hardReservedQuantity;
  String? get hardReservedQuantity => _$this._hardReservedQuantity;
  set hardReservedQuantity(String? hardReservedQuantity) =>
      _$this._hardReservedQuantity = hardReservedQuantity;

  String? _softHeldQuantity;
  String? get softHeldQuantity => _$this._softHeldQuantity;
  set softHeldQuantity(String? softHeldQuantity) =>
      _$this._softHeldQuantity = softHeldQuantity;

  String? _availableToSell;
  String? get availableToSell => _$this._availableToSell;
  set availableToSell(String? availableToSell) =>
      _$this._availableToSell = availableToSell;

  String? _reorderLevel;
  String? get reorderLevel => _$this._reorderLevel;
  set reorderLevel(String? reorderLevel) => _$this._reorderLevel = reorderLevel;

  DateTime? _confirmedAt;
  DateTime? get confirmedAt => _$this._confirmedAt;
  set confirmedAt(DateTime? confirmedAt) => _$this._confirmedAt = confirmedAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  InventoryBalanceBuilder() {
    InventoryBalance._defaults(this);
  }

  InventoryBalanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _quantityOnHand = $v.quantityOnHand;
      _hardReservedQuantity = $v.hardReservedQuantity;
      _softHeldQuantity = $v.softHeldQuantity;
      _availableToSell = $v.availableToSell;
      _reorderLevel = $v.reorderLevel;
      _confirmedAt = $v.confirmedAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryBalance other) {
    _$v = other as _$InventoryBalance;
  }

  @override
  void update(void Function(InventoryBalanceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryBalance build() => _build();

  _$InventoryBalance _build() {
    final _$result = _$v ??
        _$InventoryBalance._(
          quantityOnHand: BuiltValueNullFieldError.checkNotNull(
              quantityOnHand, r'InventoryBalance', 'quantityOnHand'),
          hardReservedQuantity: BuiltValueNullFieldError.checkNotNull(
              hardReservedQuantity,
              r'InventoryBalance',
              'hardReservedQuantity'),
          softHeldQuantity: BuiltValueNullFieldError.checkNotNull(
              softHeldQuantity, r'InventoryBalance', 'softHeldQuantity'),
          availableToSell: BuiltValueNullFieldError.checkNotNull(
              availableToSell, r'InventoryBalance', 'availableToSell'),
          reorderLevel: reorderLevel,
          confirmedAt: confirmedAt,
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
