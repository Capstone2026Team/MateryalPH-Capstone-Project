// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountProfile extends AccountProfile {
  @override
  final String id;
  @override
  final String fullName;
  @override
  final String email;
  @override
  final String accountType;
  @override
  final String accountStatus;
  @override
  final int lockVersion;
  @override
  final String? createdAt;
  @override
  final String? buyerType;
  @override
  final String? companyName;
  @override
  final String? organizationName;
  @override
  final String role;
  @override
  final String? organizationId;
  @override
  final String? membershipId;
  @override
  final bool canManageStaff;
  @override
  final BuiltList<String> permissions;

  factory _$AccountProfile([void Function(AccountProfileBuilder)? updates]) =>
      (AccountProfileBuilder()..update(updates))._build();

  _$AccountProfile._(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.accountType,
      required this.accountStatus,
      required this.lockVersion,
      this.createdAt,
      this.buyerType,
      this.companyName,
      this.organizationName,
      required this.role,
      this.organizationId,
      this.membershipId,
      required this.canManageStaff,
      required this.permissions})
      : super._();
  @override
  AccountProfile rebuild(void Function(AccountProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountProfileBuilder toBuilder() => AccountProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountProfile &&
        id == other.id &&
        fullName == other.fullName &&
        email == other.email &&
        accountType == other.accountType &&
        accountStatus == other.accountStatus &&
        lockVersion == other.lockVersion &&
        createdAt == other.createdAt &&
        buyerType == other.buyerType &&
        companyName == other.companyName &&
        organizationName == other.organizationName &&
        role == other.role &&
        organizationId == other.organizationId &&
        membershipId == other.membershipId &&
        canManageStaff == other.canManageStaff &&
        permissions == other.permissions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, accountType.hashCode);
    _$hash = $jc(_$hash, accountStatus.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, buyerType.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, organizationName.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, organizationId.hashCode);
    _$hash = $jc(_$hash, membershipId.hashCode);
    _$hash = $jc(_$hash, canManageStaff.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountProfile')
          ..add('id', id)
          ..add('fullName', fullName)
          ..add('email', email)
          ..add('accountType', accountType)
          ..add('accountStatus', accountStatus)
          ..add('lockVersion', lockVersion)
          ..add('createdAt', createdAt)
          ..add('buyerType', buyerType)
          ..add('companyName', companyName)
          ..add('organizationName', organizationName)
          ..add('role', role)
          ..add('organizationId', organizationId)
          ..add('membershipId', membershipId)
          ..add('canManageStaff', canManageStaff)
          ..add('permissions', permissions))
        .toString();
  }
}

class AccountProfileBuilder
    implements Builder<AccountProfile, AccountProfileBuilder> {
  _$AccountProfile? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _accountType;
  String? get accountType => _$this._accountType;
  set accountType(String? accountType) => _$this._accountType = accountType;

  String? _accountStatus;
  String? get accountStatus => _$this._accountStatus;
  set accountStatus(String? accountStatus) =>
      _$this._accountStatus = accountStatus;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _buyerType;
  String? get buyerType => _$this._buyerType;
  set buyerType(String? buyerType) => _$this._buyerType = buyerType;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  String? _organizationName;
  String? get organizationName => _$this._organizationName;
  set organizationName(String? organizationName) =>
      _$this._organizationName = organizationName;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  String? _organizationId;
  String? get organizationId => _$this._organizationId;
  set organizationId(String? organizationId) =>
      _$this._organizationId = organizationId;

  String? _membershipId;
  String? get membershipId => _$this._membershipId;
  set membershipId(String? membershipId) => _$this._membershipId = membershipId;

  bool? _canManageStaff;
  bool? get canManageStaff => _$this._canManageStaff;
  set canManageStaff(bool? canManageStaff) =>
      _$this._canManageStaff = canManageStaff;

  ListBuilder<String>? _permissions;
  ListBuilder<String> get permissions =>
      _$this._permissions ??= ListBuilder<String>();
  set permissions(ListBuilder<String>? permissions) =>
      _$this._permissions = permissions;

  AccountProfileBuilder() {
    AccountProfile._defaults(this);
  }

  AccountProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _fullName = $v.fullName;
      _email = $v.email;
      _accountType = $v.accountType;
      _accountStatus = $v.accountStatus;
      _lockVersion = $v.lockVersion;
      _createdAt = $v.createdAt;
      _buyerType = $v.buyerType;
      _companyName = $v.companyName;
      _organizationName = $v.organizationName;
      _role = $v.role;
      _organizationId = $v.organizationId;
      _membershipId = $v.membershipId;
      _canManageStaff = $v.canManageStaff;
      _permissions = $v.permissions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountProfile other) {
    _$v = other as _$AccountProfile;
  }

  @override
  void update(void Function(AccountProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountProfile build() => _build();

  _$AccountProfile _build() {
    _$AccountProfile _$result;
    try {
      _$result = _$v ??
          _$AccountProfile._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AccountProfile', 'id'),
            fullName: BuiltValueNullFieldError.checkNotNull(
                fullName, r'AccountProfile', 'fullName'),
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'AccountProfile', 'email'),
            accountType: BuiltValueNullFieldError.checkNotNull(
                accountType, r'AccountProfile', 'accountType'),
            accountStatus: BuiltValueNullFieldError.checkNotNull(
                accountStatus, r'AccountProfile', 'accountStatus'),
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'AccountProfile', 'lockVersion'),
            createdAt: createdAt,
            buyerType: buyerType,
            companyName: companyName,
            organizationName: organizationName,
            role: BuiltValueNullFieldError.checkNotNull(
                role, r'AccountProfile', 'role'),
            organizationId: organizationId,
            membershipId: membershipId,
            canManageStaff: BuiltValueNullFieldError.checkNotNull(
                canManageStaff, r'AccountProfile', 'canManageStaff'),
            permissions: permissions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'permissions';
        permissions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AccountProfile', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
