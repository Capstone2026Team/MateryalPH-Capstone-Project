// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_recovery_codes.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountRecoveryCodes extends AccountRecoveryCodes {
  @override
  final BuiltList<String> recoveryCodes;
  @override
  final bool? signInRequired;

  factory _$AccountRecoveryCodes(
          [void Function(AccountRecoveryCodesBuilder)? updates]) =>
      (AccountRecoveryCodesBuilder()..update(updates))._build();

  _$AccountRecoveryCodes._({required this.recoveryCodes, this.signInRequired})
      : super._();
  @override
  AccountRecoveryCodes rebuild(
          void Function(AccountRecoveryCodesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountRecoveryCodesBuilder toBuilder() =>
      AccountRecoveryCodesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountRecoveryCodes &&
        recoveryCodes == other.recoveryCodes &&
        signInRequired == other.signInRequired;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, recoveryCodes.hashCode);
    _$hash = $jc(_$hash, signInRequired.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountRecoveryCodes')
          ..add('recoveryCodes', recoveryCodes)
          ..add('signInRequired', signInRequired))
        .toString();
  }
}

class AccountRecoveryCodesBuilder
    implements Builder<AccountRecoveryCodes, AccountRecoveryCodesBuilder> {
  _$AccountRecoveryCodes? _$v;

  ListBuilder<String>? _recoveryCodes;
  ListBuilder<String> get recoveryCodes =>
      _$this._recoveryCodes ??= ListBuilder<String>();
  set recoveryCodes(ListBuilder<String>? recoveryCodes) =>
      _$this._recoveryCodes = recoveryCodes;

  bool? _signInRequired;
  bool? get signInRequired => _$this._signInRequired;
  set signInRequired(bool? signInRequired) =>
      _$this._signInRequired = signInRequired;

  AccountRecoveryCodesBuilder() {
    AccountRecoveryCodes._defaults(this);
  }

  AccountRecoveryCodesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recoveryCodes = $v.recoveryCodes.toBuilder();
      _signInRequired = $v.signInRequired;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountRecoveryCodes other) {
    _$v = other as _$AccountRecoveryCodes;
  }

  @override
  void update(void Function(AccountRecoveryCodesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountRecoveryCodes build() => _build();

  _$AccountRecoveryCodes _build() {
    _$AccountRecoveryCodes _$result;
    try {
      _$result = _$v ??
          _$AccountRecoveryCodes._(
            recoveryCodes: recoveryCodes.build(),
            signInRequired: signInRequired,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'recoveryCodes';
        recoveryCodes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AccountRecoveryCodes', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
