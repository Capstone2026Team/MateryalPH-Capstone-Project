// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_inventory.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogInventory extends CatalogInventory {
  @override
  final String quantityOnHand;
  @override
  final String hardReservedQuantity;
  @override
  final String availableToSell;
  @override
  final String? confirmedAt;

  factory _$CatalogInventory(
          [void Function(CatalogInventoryBuilder)? updates]) =>
      (CatalogInventoryBuilder()..update(updates))._build();

  _$CatalogInventory._(
      {required this.quantityOnHand,
      required this.hardReservedQuantity,
      required this.availableToSell,
      this.confirmedAt})
      : super._();
  @override
  CatalogInventory rebuild(void Function(CatalogInventoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogInventoryBuilder toBuilder() =>
      CatalogInventoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogInventory &&
        quantityOnHand == other.quantityOnHand &&
        hardReservedQuantity == other.hardReservedQuantity &&
        availableToSell == other.availableToSell &&
        confirmedAt == other.confirmedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, quantityOnHand.hashCode);
    _$hash = $jc(_$hash, hardReservedQuantity.hashCode);
    _$hash = $jc(_$hash, availableToSell.hashCode);
    _$hash = $jc(_$hash, confirmedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogInventory')
          ..add('quantityOnHand', quantityOnHand)
          ..add('hardReservedQuantity', hardReservedQuantity)
          ..add('availableToSell', availableToSell)
          ..add('confirmedAt', confirmedAt))
        .toString();
  }
}

class CatalogInventoryBuilder
    implements Builder<CatalogInventory, CatalogInventoryBuilder> {
  _$CatalogInventory? _$v;

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

  String? _confirmedAt;
  String? get confirmedAt => _$this._confirmedAt;
  set confirmedAt(String? confirmedAt) => _$this._confirmedAt = confirmedAt;

  CatalogInventoryBuilder() {
    CatalogInventory._defaults(this);
  }

  CatalogInventoryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _quantityOnHand = $v.quantityOnHand;
      _hardReservedQuantity = $v.hardReservedQuantity;
      _availableToSell = $v.availableToSell;
      _confirmedAt = $v.confirmedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogInventory other) {
    _$v = other as _$CatalogInventory;
  }

  @override
  void update(void Function(CatalogInventoryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogInventory build() => _build();

  _$CatalogInventory _build() {
    final _$result = _$v ??
        _$CatalogInventory._(
          quantityOnHand: BuiltValueNullFieldError.checkNotNull(
              quantityOnHand, r'CatalogInventory', 'quantityOnHand'),
          hardReservedQuantity: BuiltValueNullFieldError.checkNotNull(
              hardReservedQuantity,
              r'CatalogInventory',
              'hardReservedQuantity'),
          availableToSell: BuiltValueNullFieldError.checkNotNull(
              availableToSell, r'CatalogInventory', 'availableToSell'),
          confirmedAt: confirmedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
