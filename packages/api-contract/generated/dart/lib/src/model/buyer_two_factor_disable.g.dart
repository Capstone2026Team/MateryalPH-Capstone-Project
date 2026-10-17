// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_two_factor_disable.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerTwoFactorDisable extends BuyerTwoFactorDisable {
  @override
  final String? code;
  @override
  final String? recoveryCode;

  factory _$BuyerTwoFactorDisable(
          [void Function(BuyerTwoFactorDisableBuilder)? updates]) =>
      (BuyerTwoFactorDisableBuilder()..update(updates))._build();

  _$BuyerTwoFactorDisable._({this.code, this.recoveryCode}) : super._();
  @override
  BuyerTwoFactorDisable rebuild(
          void Function(BuyerTwoFactorDisableBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerTwoFactorDisableBuilder toBuilder() =>
      BuyerTwoFactorDisableBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerTwoFactorDisable &&
        code == other.code &&
        recoveryCode == other.recoveryCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, recoveryCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerTwoFactorDisable')
          ..add('code', code)
          ..add('recoveryCode', recoveryCode))
        .toString();
  }
}

class BuyerTwoFactorDisableBuilder
    implements Builder<BuyerTwoFactorDisable, BuyerTwoFactorDisableBuilder> {
  _$BuyerTwoFactorDisable? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _recoveryCode;
  String? get recoveryCode => _$this._recoveryCode;
  set recoveryCode(String? recoveryCode) => _$this._recoveryCode = recoveryCode;

  BuyerTwoFactorDisableBuilder() {
    BuyerTwoFactorDisable._defaults(this);
  }

  BuyerTwoFactorDisableBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _recoveryCode = $v.recoveryCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerTwoFactorDisable other) {
    _$v = other as _$BuyerTwoFactorDisable;
  }

  @override
  void update(void Function(BuyerTwoFactorDisableBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerTwoFactorDisable build() => _build();

  _$BuyerTwoFactorDisable _build() {
    final _$result = _$v ??
        _$BuyerTwoFactorDisable._(
          code: code,
          recoveryCode: recoveryCode,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
