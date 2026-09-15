// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_admin_invitation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountAdminInvitation extends AccountAdminInvitation {
  @override
  final String email;
  @override
  final String roleId;

  factory _$AccountAdminInvitation(
          [void Function(AccountAdminInvitationBuilder)? updates]) =>
      (AccountAdminInvitationBuilder()..update(updates))._build();

  _$AccountAdminInvitation._({required this.email, required this.roleId})
      : super._();
  @override
  AccountAdminInvitation rebuild(
          void Function(AccountAdminInvitationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountAdminInvitationBuilder toBuilder() =>
      AccountAdminInvitationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountAdminInvitation &&
        email == other.email &&
        roleId == other.roleId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, roleId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountAdminInvitation')
          ..add('email', email)
          ..add('roleId', roleId))
        .toString();
  }
}

class AccountAdminInvitationBuilder
    implements Builder<AccountAdminInvitation, AccountAdminInvitationBuilder> {
  _$AccountAdminInvitation? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _roleId;
  String? get roleId => _$this._roleId;
  set roleId(String? roleId) => _$this._roleId = roleId;

  AccountAdminInvitationBuilder() {
    AccountAdminInvitation._defaults(this);
  }

  AccountAdminInvitationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _roleId = $v.roleId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountAdminInvitation other) {
    _$v = other as _$AccountAdminInvitation;
  }

  @override
  void update(void Function(AccountAdminInvitationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountAdminInvitation build() => _build();

  _$AccountAdminInvitation _build() {
    final _$result = _$v ??
        _$AccountAdminInvitation._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'AccountAdminInvitation', 'email'),
          roleId: BuiltValueNullFieldError.checkNotNull(
              roleId, r'AccountAdminInvitation', 'roleId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
