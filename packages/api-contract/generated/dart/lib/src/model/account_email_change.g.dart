// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_email_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountEmailChange extends AccountEmailChange {
  @override
  final String email;

  factory _$AccountEmailChange(
          [void Function(AccountEmailChangeBuilder)? updates]) =>
      (AccountEmailChangeBuilder()..update(updates))._build();

  _$AccountEmailChange._({required this.email}) : super._();
  @override
  AccountEmailChange rebuild(
          void Function(AccountEmailChangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountEmailChangeBuilder toBuilder() =>
      AccountEmailChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountEmailChange && email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountEmailChange')
          ..add('email', email))
        .toString();
  }
}

class AccountEmailChangeBuilder
    implements Builder<AccountEmailChange, AccountEmailChangeBuilder> {
  _$AccountEmailChange? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  AccountEmailChangeBuilder() {
    AccountEmailChange._defaults(this);
  }

  AccountEmailChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountEmailChange other) {
    _$v = other as _$AccountEmailChange;
  }

  @override
  void update(void Function(AccountEmailChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountEmailChange build() => _build();

  _$AccountEmailChange _build() {
    final _$result = _$v ??
        _$AccountEmailChange._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'AccountEmailChange', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
