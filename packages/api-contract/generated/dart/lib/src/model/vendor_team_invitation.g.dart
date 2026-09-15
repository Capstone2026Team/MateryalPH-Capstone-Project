// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_invitation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamInvitation extends VendorTeamInvitation {
  @override
  final String id;
  @override
  final String? fullName;
  @override
  final String normalizedEmail;
  @override
  final String role;
  @override
  final bool canManageStaff;
  @override
  final String expiresAt;
  @override
  final String? acceptedAt;
  @override
  final String? revokedAt;
  @override
  final int lockVersion;

  factory _$VendorTeamInvitation(
          [void Function(VendorTeamInvitationBuilder)? updates]) =>
      (VendorTeamInvitationBuilder()..update(updates))._build();

  _$VendorTeamInvitation._(
      {required this.id,
      this.fullName,
      required this.normalizedEmail,
      required this.role,
      required this.canManageStaff,
      required this.expiresAt,
      this.acceptedAt,
      this.revokedAt,
      required this.lockVersion})
      : super._();
  @override
  VendorTeamInvitation rebuild(
          void Function(VendorTeamInvitationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamInvitationBuilder toBuilder() =>
      VendorTeamInvitationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamInvitation &&
        id == other.id &&
        fullName == other.fullName &&
        normalizedEmail == other.normalizedEmail &&
        role == other.role &&
        canManageStaff == other.canManageStaff &&
        expiresAt == other.expiresAt &&
        acceptedAt == other.acceptedAt &&
        revokedAt == other.revokedAt &&
        lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, normalizedEmail.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, canManageStaff.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, acceptedAt.hashCode);
    _$hash = $jc(_$hash, revokedAt.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeamInvitation')
          ..add('id', id)
          ..add('fullName', fullName)
          ..add('normalizedEmail', normalizedEmail)
          ..add('role', role)
          ..add('canManageStaff', canManageStaff)
          ..add('expiresAt', expiresAt)
          ..add('acceptedAt', acceptedAt)
          ..add('revokedAt', revokedAt)
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class VendorTeamInvitationBuilder
    implements Builder<VendorTeamInvitation, VendorTeamInvitationBuilder> {
  _$VendorTeamInvitation? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _normalizedEmail;
  String? get normalizedEmail => _$this._normalizedEmail;
  set normalizedEmail(String? normalizedEmail) =>
      _$this._normalizedEmail = normalizedEmail;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  bool? _canManageStaff;
  bool? get canManageStaff => _$this._canManageStaff;
  set canManageStaff(bool? canManageStaff) =>
      _$this._canManageStaff = canManageStaff;

  String? _expiresAt;
  String? get expiresAt => _$this._expiresAt;
  set expiresAt(String? expiresAt) => _$this._expiresAt = expiresAt;

  String? _acceptedAt;
  String? get acceptedAt => _$this._acceptedAt;
  set acceptedAt(String? acceptedAt) => _$this._acceptedAt = acceptedAt;

  String? _revokedAt;
  String? get revokedAt => _$this._revokedAt;
  set revokedAt(String? revokedAt) => _$this._revokedAt = revokedAt;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  VendorTeamInvitationBuilder() {
    VendorTeamInvitation._defaults(this);
  }

  VendorTeamInvitationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _fullName = $v.fullName;
      _normalizedEmail = $v.normalizedEmail;
      _role = $v.role;
      _canManageStaff = $v.canManageStaff;
      _expiresAt = $v.expiresAt;
      _acceptedAt = $v.acceptedAt;
      _revokedAt = $v.revokedAt;
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamInvitation other) {
    _$v = other as _$VendorTeamInvitation;
  }

  @override
  void update(void Function(VendorTeamInvitationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamInvitation build() => _build();

  _$VendorTeamInvitation _build() {
    final _$result = _$v ??
        _$VendorTeamInvitation._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'VendorTeamInvitation', 'id'),
          fullName: fullName,
          normalizedEmail: BuiltValueNullFieldError.checkNotNull(
              normalizedEmail, r'VendorTeamInvitation', 'normalizedEmail'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'VendorTeamInvitation', 'role'),
          canManageStaff: BuiltValueNullFieldError.checkNotNull(
              canManageStaff, r'VendorTeamInvitation', 'canManageStaff'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'VendorTeamInvitation', 'expiresAt'),
          acceptedAt: acceptedAt,
          revokedAt: revokedAt,
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'VendorTeamInvitation', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
