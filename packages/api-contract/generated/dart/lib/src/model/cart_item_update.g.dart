// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CartItemUpdate extends CartItemUpdate {
  @override
  final int lockVersion;
  @override
  final String? quantity;
  @override
  final bool? savedForLater;
  @override
  final bool? acceptCurrentPrice;

  factory _$CartItemUpdate([void Function(CartItemUpdateBuilder)? updates]) =>
      (CartItemUpdateBuilder()..update(updates))._build();

  _$CartItemUpdate._(
      {required this.lockVersion,
      this.quantity,
      this.savedForLater,
      this.acceptCurrentPrice})
      : super._();
  @override
  CartItemUpdate rebuild(void Function(CartItemUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartItemUpdateBuilder toBuilder() => CartItemUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartItemUpdate &&
        lockVersion == other.lockVersion &&
        quantity == other.quantity &&
        savedForLater == other.savedForLater &&
        acceptCurrentPrice == other.acceptCurrentPrice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, savedForLater.hashCode);
    _$hash = $jc(_$hash, acceptCurrentPrice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CartItemUpdate')
          ..add('lockVersion', lockVersion)
          ..add('quantity', quantity)
          ..add('savedForLater', savedForLater)
          ..add('acceptCurrentPrice', acceptCurrentPrice))
        .toString();
  }
}

class CartItemUpdateBuilder
    implements Builder<CartItemUpdate, CartItemUpdateBuilder> {
  _$CartItemUpdate? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _quantity;
  String? get quantity => _$this._quantity;
  set quantity(String? quantity) => _$this._quantity = quantity;

  bool? _savedForLater;
  bool? get savedForLater => _$this._savedForLater;
  set savedForLater(bool? savedForLater) =>
      _$this._savedForLater = savedForLater;

  bool? _acceptCurrentPrice;
  bool? get acceptCurrentPrice => _$this._acceptCurrentPrice;
  set acceptCurrentPrice(bool? acceptCurrentPrice) =>
      _$this._acceptCurrentPrice = acceptCurrentPrice;

  CartItemUpdateBuilder() {
    CartItemUpdate._defaults(this);
  }

  CartItemUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _quantity = $v.quantity;
      _savedForLater = $v.savedForLater;
      _acceptCurrentPrice = $v.acceptCurrentPrice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CartItemUpdate other) {
    _$v = other as _$CartItemUpdate;
  }

  @override
  void update(void Function(CartItemUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CartItemUpdate build() => _build();

  _$CartItemUpdate _build() {
    final _$result = _$v ??
        _$CartItemUpdate._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'CartItemUpdate', 'lockVersion'),
          quantity: quantity,
          savedForLater: savedForLater,
          acceptCurrentPrice: acceptCurrentPrice,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
