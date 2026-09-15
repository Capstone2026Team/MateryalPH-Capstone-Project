// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_reauthentication.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountReauthentication extends AccountReauthentication {
  @override
  final String? password;
  @override
  final String? code;
  @override
  final String? emailCode;

  factory _$AccountReauthentication(
          [void Function(AccountReauthenticationBuilder)? updates]) =>
      (AccountReauthenticationBuilder()..update(updates))._build();

  _$AccountReauthentication._({this.password, this.code, this.emailCode})
      : super._();
  @override
  AccountReauthentication rebuild(
          void Function(AccountReauthenticationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountReauthenticationBuilder toBuilder() =>
      AccountReauthenticationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountReauthentication &&
        password == other.password &&
        code == other.code &&
        emailCode == other.emailCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, emailCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountReauthentication')
          ..add('password', password)
          ..add('code', code)
          ..add('emailCode', emailCode))
        .toString();
  }
}

class AccountReauthenticationBuilder
    implements
        Builder<AccountReauthentication, AccountReauthenticationBuilder> {
  _$AccountReauthentication? _$v;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _emailCode;
  String? get emailCode => _$this._emailCode;
  set emailCode(String? emailCode) => _$this._emailCode = emailCode;

  AccountReauthenticationBuilder() {
    AccountReauthentication._defaults(this);
  }

  AccountReauthenticationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _password = $v.password;
      _code = $v.code;
      _emailCode = $v.emailCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountReauthentication other) {
    _$v = other as _$AccountReauthentication;
  }

  @override
  void update(void Function(AccountReauthenticationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountReauthentication build() => _build();

  _$AccountReauthentication _build() {
    final _$result = _$v ??
        _$AccountReauthentication._(
          password: password,
          code: code,
          emailCode: emailCode,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
