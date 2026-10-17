// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buy_again_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyAgainResult extends BuyAgainResult {
  @override
  final Cart cart;
  @override
  final BuiltList<BuyAgainAddedLine> added;
  @override
  final BuiltList<BuyAgainSkippedLine> skipped;

  factory _$BuyAgainResult([void Function(BuyAgainResultBuilder)? updates]) =>
      (BuyAgainResultBuilder()..update(updates))._build();

  _$BuyAgainResult._(
      {required this.cart, required this.added, required this.skipped})
      : super._();
  @override
  BuyAgainResult rebuild(void Function(BuyAgainResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyAgainResultBuilder toBuilder() => BuyAgainResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyAgainResult &&
        cart == other.cart &&
        added == other.added &&
        skipped == other.skipped;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cart.hashCode);
    _$hash = $jc(_$hash, added.hashCode);
    _$hash = $jc(_$hash, skipped.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyAgainResult')
          ..add('cart', cart)
          ..add('added', added)
          ..add('skipped', skipped))
        .toString();
  }
}

class BuyAgainResultBuilder
    implements Builder<BuyAgainResult, BuyAgainResultBuilder> {
  _$BuyAgainResult? _$v;

  CartBuilder? _cart;
  CartBuilder get cart => _$this._cart ??= CartBuilder();
  set cart(CartBuilder? cart) => _$this._cart = cart;

  ListBuilder<BuyAgainAddedLine>? _added;
  ListBuilder<BuyAgainAddedLine> get added =>
      _$this._added ??= ListBuilder<BuyAgainAddedLine>();
  set added(ListBuilder<BuyAgainAddedLine>? added) => _$this._added = added;

  ListBuilder<BuyAgainSkippedLine>? _skipped;
  ListBuilder<BuyAgainSkippedLine> get skipped =>
      _$this._skipped ??= ListBuilder<BuyAgainSkippedLine>();
  set skipped(ListBuilder<BuyAgainSkippedLine>? skipped) =>
      _$this._skipped = skipped;

  BuyAgainResultBuilder() {
    BuyAgainResult._defaults(this);
  }

  BuyAgainResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cart = $v.cart.toBuilder();
      _added = $v.added.toBuilder();
      _skipped = $v.skipped.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyAgainResult other) {
    _$v = other as _$BuyAgainResult;
  }

  @override
  void update(void Function(BuyAgainResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyAgainResult build() => _build();

  _$BuyAgainResult _build() {
    _$BuyAgainResult _$result;
    try {
      _$result = _$v ??
          _$BuyAgainResult._(
            cart: cart.build(),
            added: added.build(),
            skipped: skipped.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'cart';
        cart.build();
        _$failedField = 'added';
        added.build();
        _$failedField = 'skipped';
        skipped.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyAgainResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
