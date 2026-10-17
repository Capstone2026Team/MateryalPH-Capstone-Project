// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buy_again_added_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyAgainAddedLine extends BuyAgainAddedLine {
  @override
  final String displayName;
  @override
  final String quantity;

  factory _$BuyAgainAddedLine(
          [void Function(BuyAgainAddedLineBuilder)? updates]) =>
      (BuyAgainAddedLineBuilder()..update(updates))._build();

  _$BuyAgainAddedLine._({required this.displayName, required this.quantity})
      : super._();
  @override
  BuyAgainAddedLine rebuild(void Function(BuyAgainAddedLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyAgainAddedLineBuilder toBuilder() =>
      BuyAgainAddedLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyAgainAddedLine &&
        displayName == other.displayName &&
        quantity == other.quantity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyAgainAddedLine')
          ..add('displayName', displayName)
          ..add('quantity', quantity))
        .toString();
  }
}

class BuyAgainAddedLineBuilder
    implements Builder<BuyAgainAddedLine, BuyAgainAddedLineBuilder> {
  _$BuyAgainAddedLine? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _quantity;
  String? get quantity => _$this._quantity;
  set quantity(String? quantity) => _$this._quantity = quantity;

  BuyAgainAddedLineBuilder() {
    BuyAgainAddedLine._defaults(this);
  }

  BuyAgainAddedLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _quantity = $v.quantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyAgainAddedLine other) {
    _$v = other as _$BuyAgainAddedLine;
  }

  @override
  void update(void Function(BuyAgainAddedLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyAgainAddedLine build() => _build();

  _$BuyAgainAddedLine _build() {
    final _$result = _$v ??
        _$BuyAgainAddedLine._(
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'BuyAgainAddedLine', 'displayName'),
          quantity: BuiltValueNullFieldError.checkNotNull(
              quantity, r'BuyAgainAddedLine', 'quantity'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
