// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_password_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountPasswordChange extends AccountPasswordChange {
  @override
  final String password;
  @override
  final String passwordConfirmation;

  factory _$AccountPasswordChange(
          [void Function(AccountPasswordChangeBuilder)? updates]) =>
      (AccountPasswordChangeBuilder()..update(updates))._build();

  _$AccountPasswordChange._(
      {required this.password, required this.passwordConfirmation})
      : super._();
  @override
  AccountPasswordChange rebuild(
          void Function(AccountPasswordChangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountPasswordChangeBuilder toBuilder() =>
      AccountPasswordChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountPasswordChange &&
        password == other.password &&
        passwordConfirmation == other.passwordConfirmation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, passwordConfirmation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountPasswordChange')
          ..add('password', password)
          ..add('passwordConfirmation', passwordConfirmation))
        .toString();
  }
}

class AccountPasswordChangeBuilder
    implements Builder<AccountPasswordChange, AccountPasswordChangeBuilder> {
  _$AccountPasswordChange? _$v;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _passwordConfirmation;
  String? get passwordConfirmation => _$this._passwordConfirmation;
  set passwordConfirmation(String? passwordConfirmation) =>
      _$this._passwordConfirmation = passwordConfirmation;

  AccountPasswordChangeBuilder() {
    AccountPasswordChange._defaults(this);
  }

  AccountPasswordChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _password = $v.password;
      _passwordConfirmation = $v.passwordConfirmation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountPasswordChange other) {
    _$v = other as _$AccountPasswordChange;
  }

  @override
  void update(void Function(AccountPasswordChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountPasswordChange build() => _build();

  _$AccountPasswordChange _build() {
    final _$result = _$v ??
        _$AccountPasswordChange._(
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'AccountPasswordChange', 'password'),
          passwordConfirmation: BuiltValueNullFieldError.checkNotNull(
              passwordConfirmation,
              r'AccountPasswordChange',
              'passwordConfirmation'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
