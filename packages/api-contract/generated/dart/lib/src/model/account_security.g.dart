// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_security.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountSecurity extends AccountSecurity {
  @override
  final bool totpEnrolled;
  @override
  final String? recentAuthenticationExpiresAt;

  factory _$AccountSecurity([void Function(AccountSecurityBuilder)? updates]) =>
      (AccountSecurityBuilder()..update(updates))._build();

  _$AccountSecurity._(
      {required this.totpEnrolled, this.recentAuthenticationExpiresAt})
      : super._();
  @override
  AccountSecurity rebuild(void Function(AccountSecurityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountSecurityBuilder toBuilder() => AccountSecurityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountSecurity &&
        totpEnrolled == other.totpEnrolled &&
        recentAuthenticationExpiresAt == other.recentAuthenticationExpiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, totpEnrolled.hashCode);
    _$hash = $jc(_$hash, recentAuthenticationExpiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountSecurity')
          ..add('totpEnrolled', totpEnrolled)
          ..add('recentAuthenticationExpiresAt', recentAuthenticationExpiresAt))
        .toString();
  }
}

class AccountSecurityBuilder
    implements Builder<AccountSecurity, AccountSecurityBuilder> {
  _$AccountSecurity? _$v;

  bool? _totpEnrolled;
  bool? get totpEnrolled => _$this._totpEnrolled;
  set totpEnrolled(bool? totpEnrolled) => _$this._totpEnrolled = totpEnrolled;

  String? _recentAuthenticationExpiresAt;
  String? get recentAuthenticationExpiresAt =>
      _$this._recentAuthenticationExpiresAt;
  set recentAuthenticationExpiresAt(String? recentAuthenticationExpiresAt) =>
      _$this._recentAuthenticationExpiresAt = recentAuthenticationExpiresAt;

  AccountSecurityBuilder() {
    AccountSecurity._defaults(this);
  }

  AccountSecurityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _totpEnrolled = $v.totpEnrolled;
      _recentAuthenticationExpiresAt = $v.recentAuthenticationExpiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountSecurity other) {
    _$v = other as _$AccountSecurity;
  }

  @override
  void update(void Function(AccountSecurityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountSecurity build() => _build();

  _$AccountSecurity _build() {
    final _$result = _$v ??
        _$AccountSecurity._(
          totpEnrolled: BuiltValueNullFieldError.checkNotNull(
              totpEnrolled, r'AccountSecurity', 'totpEnrolled'),
          recentAuthenticationExpiresAt: recentAuthenticationExpiresAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
