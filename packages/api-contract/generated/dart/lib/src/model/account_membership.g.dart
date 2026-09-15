// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_membership.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountMembership extends AccountMembership {
  @override
  final String id;
  @override
  final String name;
  @override
  final String role;
  @override
  final String status;
  @override
  final bool canManageStaff;

  factory _$AccountMembership(
          [void Function(AccountMembershipBuilder)? updates]) =>
      (AccountMembershipBuilder()..update(updates))._build();

  _$AccountMembership._(
      {required this.id,
      required this.name,
      required this.role,
      required this.status,
      required this.canManageStaff})
      : super._();
  @override
  AccountMembership rebuild(void Function(AccountMembershipBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountMembershipBuilder toBuilder() =>
      AccountMembershipBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountMembership &&
        id == other.id &&
        name == other.name &&
        role == other.role &&
        status == other.status &&
        canManageStaff == other.canManageStaff;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, canManageStaff.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountMembership')
          ..add('id', id)
          ..add('name', name)
          ..add('role', role)
          ..add('status', status)
          ..add('canManageStaff', canManageStaff))
        .toString();
  }
}

class AccountMembershipBuilder
    implements Builder<AccountMembership, AccountMembershipBuilder> {
  _$AccountMembership? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  bool? _canManageStaff;
  bool? get canManageStaff => _$this._canManageStaff;
  set canManageStaff(bool? canManageStaff) =>
      _$this._canManageStaff = canManageStaff;

  AccountMembershipBuilder() {
    AccountMembership._defaults(this);
  }

  AccountMembershipBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _role = $v.role;
      _status = $v.status;
      _canManageStaff = $v.canManageStaff;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountMembership other) {
    _$v = other as _$AccountMembership;
  }

  @override
  void update(void Function(AccountMembershipBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountMembership build() => _build();

  _$AccountMembership _build() {
    final _$result = _$v ??
        _$AccountMembership._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AccountMembership', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AccountMembership', 'name'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'AccountMembership', 'role'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AccountMembership', 'status'),
          canManageStaff: BuiltValueNullFieldError.checkNotNull(
              canManageStaff, r'AccountMembership', 'canManageStaff'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
