// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_member.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamMember extends VendorTeamMember {
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
  @override
  final int lockVersion;
  @override
  final String createdAt;

  factory _$VendorTeamMember(
          [void Function(VendorTeamMemberBuilder)? updates]) =>
      (VendorTeamMemberBuilder()..update(updates))._build();

  _$VendorTeamMember._(
      {required this.id,
      required this.name,
      required this.role,
      required this.status,
      required this.canManageStaff,
      required this.lockVersion,
      required this.createdAt})
      : super._();
  @override
  VendorTeamMember rebuild(void Function(VendorTeamMemberBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamMemberBuilder toBuilder() =>
      VendorTeamMemberBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamMember &&
        id == other.id &&
        name == other.name &&
        role == other.role &&
        status == other.status &&
        canManageStaff == other.canManageStaff &&
        lockVersion == other.lockVersion &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, canManageStaff.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeamMember')
          ..add('id', id)
          ..add('name', name)
          ..add('role', role)
          ..add('status', status)
          ..add('canManageStaff', canManageStaff)
          ..add('lockVersion', lockVersion)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class VendorTeamMemberBuilder
    implements Builder<VendorTeamMember, VendorTeamMemberBuilder> {
  _$VendorTeamMember? _$v;

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

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  VendorTeamMemberBuilder() {
    VendorTeamMember._defaults(this);
  }

  VendorTeamMemberBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _role = $v.role;
      _status = $v.status;
      _canManageStaff = $v.canManageStaff;
      _lockVersion = $v.lockVersion;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamMember other) {
    _$v = other as _$VendorTeamMember;
  }

  @override
  void update(void Function(VendorTeamMemberBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamMember build() => _build();

  _$VendorTeamMember _build() {
    final _$result = _$v ??
        _$VendorTeamMember._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'VendorTeamMember', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'VendorTeamMember', 'name'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'VendorTeamMember', 'role'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'VendorTeamMember', 'status'),
          canManageStaff: BuiltValueNullFieldError.checkNotNull(
              canManageStaff, r'VendorTeamMember', 'canManageStaff'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'VendorTeamMember', 'lockVersion'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'VendorTeamMember', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
