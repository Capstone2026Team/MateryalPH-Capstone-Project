// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_accept_policy_detail_stock.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AutoAcceptPolicyDetailStock extends AutoAcceptPolicyDetailStock {
  @override
  final String quantityOnHand;
  @override
  final String hardReservedQuantity;
  @override
  final String softHeldQuantity;
  @override
  final String availableToSell;

  factory _$AutoAcceptPolicyDetailStock(
          [void Function(AutoAcceptPolicyDetailStockBuilder)? updates]) =>
      (AutoAcceptPolicyDetailStockBuilder()..update(updates))._build();

  _$AutoAcceptPolicyDetailStock._(
      {required this.quantityOnHand,
      required this.hardReservedQuantity,
      required this.softHeldQuantity,
      required this.availableToSell})
      : super._();
  @override
  AutoAcceptPolicyDetailStock rebuild(
          void Function(AutoAcceptPolicyDetailStockBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutoAcceptPolicyDetailStockBuilder toBuilder() =>
      AutoAcceptPolicyDetailStockBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutoAcceptPolicyDetailStock &&
        quantityOnHand == other.quantityOnHand &&
        hardReservedQuantity == other.hardReservedQuantity &&
        softHeldQuantity == other.softHeldQuantity &&
        availableToSell == other.availableToSell;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, quantityOnHand.hashCode);
    _$hash = $jc(_$hash, hardReservedQuantity.hashCode);
    _$hash = $jc(_$hash, softHeldQuantity.hashCode);
    _$hash = $jc(_$hash, availableToSell.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutoAcceptPolicyDetailStock')
          ..add('quantityOnHand', quantityOnHand)
          ..add('hardReservedQuantity', hardReservedQuantity)
          ..add('softHeldQuantity', softHeldQuantity)
          ..add('availableToSell', availableToSell))
        .toString();
  }
}

class AutoAcceptPolicyDetailStockBuilder
    implements
        Builder<AutoAcceptPolicyDetailStock,
            AutoAcceptPolicyDetailStockBuilder> {
  _$AutoAcceptPolicyDetailStock? _$v;

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

  AutoAcceptPolicyDetailStockBuilder() {
    AutoAcceptPolicyDetailStock._defaults(this);
  }

  AutoAcceptPolicyDetailStockBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _quantityOnHand = $v.quantityOnHand;
      _hardReservedQuantity = $v.hardReservedQuantity;
      _softHeldQuantity = $v.softHeldQuantity;
      _availableToSell = $v.availableToSell;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutoAcceptPolicyDetailStock other) {
    _$v = other as _$AutoAcceptPolicyDetailStock;
  }

  @override
  void update(void Function(AutoAcceptPolicyDetailStockBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutoAcceptPolicyDetailStock build() => _build();

  _$AutoAcceptPolicyDetailStock _build() {
    final _$result = _$v ??
        _$AutoAcceptPolicyDetailStock._(
          quantityOnHand: BuiltValueNullFieldError.checkNotNull(
              quantityOnHand, r'AutoAcceptPolicyDetailStock', 'quantityOnHand'),
          hardReservedQuantity: BuiltValueNullFieldError.checkNotNull(
              hardReservedQuantity,
              r'AutoAcceptPolicyDetailStock',
              'hardReservedQuantity'),
          softHeldQuantity: BuiltValueNullFieldError.checkNotNull(
              softHeldQuantity,
              r'AutoAcceptPolicyDetailStock',
              'softHeldQuantity'),
          availableToSell: BuiltValueNullFieldError.checkNotNull(
              availableToSell,
              r'AutoAcceptPolicyDetailStock',
              'availableToSell'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
