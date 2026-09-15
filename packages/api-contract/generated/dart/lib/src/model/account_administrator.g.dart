// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_administrator.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountAdministrator extends AccountAdministrator {
  @override
  final String id;
  @override
  final String name;
  @override
  final String role;
  @override
  final String roleId;
  @override
  final String status;
  @override
  final int lockVersion;

  factory _$AccountAdministrator(
          [void Function(AccountAdministratorBuilder)? updates]) =>
      (AccountAdministratorBuilder()..update(updates))._build();

  _$AccountAdministrator._(
      {required this.id,
      required this.name,
      required this.role,
      required this.roleId,
      required this.status,
      required this.lockVersion})
      : super._();
  @override
  AccountAdministrator rebuild(
          void Function(AccountAdministratorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountAdministratorBuilder toBuilder() =>
      AccountAdministratorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountAdministrator &&
        id == other.id &&
        name == other.name &&
        role == other.role &&
        roleId == other.roleId &&
        status == other.status &&
        lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, roleId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountAdministrator')
          ..add('id', id)
          ..add('name', name)
          ..add('role', role)
          ..add('roleId', roleId)
          ..add('status', status)
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class AccountAdministratorBuilder
    implements Builder<AccountAdministrator, AccountAdministratorBuilder> {
  _$AccountAdministrator? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  String? _roleId;
  String? get roleId => _$this._roleId;
  set roleId(String? roleId) => _$this._roleId = roleId;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  AccountAdministratorBuilder() {
    AccountAdministrator._defaults(this);
  }

  AccountAdministratorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _role = $v.role;
      _roleId = $v.roleId;
      _status = $v.status;
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountAdministrator other) {
    _$v = other as _$AccountAdministrator;
  }

  @override
  void update(void Function(AccountAdministratorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountAdministrator build() => _build();

  _$AccountAdministrator _build() {
    final _$result = _$v ??
        _$AccountAdministrator._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AccountAdministrator', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AccountAdministrator', 'name'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'AccountAdministrator', 'role'),
          roleId: BuiltValueNullFieldError.checkNotNull(
              roleId, r'AccountAdministrator', 'roleId'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AccountAdministrator', 'status'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'AccountAdministrator', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
