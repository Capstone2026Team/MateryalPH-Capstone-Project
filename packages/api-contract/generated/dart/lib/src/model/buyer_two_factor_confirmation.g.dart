// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_two_factor_confirmation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerTwoFactorConfirmation extends BuyerTwoFactorConfirmation {
  @override
  final String code;

  factory _$BuyerTwoFactorConfirmation(
          [void Function(BuyerTwoFactorConfirmationBuilder)? updates]) =>
      (BuyerTwoFactorConfirmationBuilder()..update(updates))._build();

  _$BuyerTwoFactorConfirmation._({required this.code}) : super._();
  @override
  BuyerTwoFactorConfirmation rebuild(
          void Function(BuyerTwoFactorConfirmationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerTwoFactorConfirmationBuilder toBuilder() =>
      BuyerTwoFactorConfirmationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerTwoFactorConfirmation && code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerTwoFactorConfirmation')
          ..add('code', code))
        .toString();
  }
}

class BuyerTwoFactorConfirmationBuilder
    implements
        Builder<BuyerTwoFactorConfirmation, BuyerTwoFactorConfirmationBuilder> {
  _$BuyerTwoFactorConfirmation? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  BuyerTwoFactorConfirmationBuilder() {
    BuyerTwoFactorConfirmation._defaults(this);
  }

  BuyerTwoFactorConfirmationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerTwoFactorConfirmation other) {
    _$v = other as _$BuyerTwoFactorConfirmation;
  }

  @override
  void update(void Function(BuyerTwoFactorConfirmationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerTwoFactorConfirmation build() => _build();

  _$BuyerTwoFactorConfirmation _build() {
    final _$result = _$v ??
        _$BuyerTwoFactorConfirmation._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'BuyerTwoFactorConfirmation', 'code'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
