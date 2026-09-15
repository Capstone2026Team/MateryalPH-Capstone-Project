// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_vendor_team_member.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChangeVendorTeamMemberRoleEnum
    _$changeVendorTeamMemberRoleEnum_STORE_MANAGER =
    const ChangeVendorTeamMemberRoleEnum._('STORE_MANAGER');
const ChangeVendorTeamMemberRoleEnum
    _$changeVendorTeamMemberRoleEnum_STORE_STAFF =
    const ChangeVendorTeamMemberRoleEnum._('STORE_STAFF');
const ChangeVendorTeamMemberRoleEnum
    _$changeVendorTeamMemberRoleEnum_CUSTOMER_SERVICE =
    const ChangeVendorTeamMemberRoleEnum._('CUSTOMER_SERVICE');
const ChangeVendorTeamMemberRoleEnum
    _$changeVendorTeamMemberRoleEnum_INVENTORY =
    const ChangeVendorTeamMemberRoleEnum._('INVENTORY');
const ChangeVendorTeamMemberRoleEnum
    _$changeVendorTeamMemberRoleEnum_FULFILLMENT =
    const ChangeVendorTeamMemberRoleEnum._('FULFILLMENT');

ChangeVendorTeamMemberRoleEnum _$changeVendorTeamMemberRoleEnumValueOf(
    String name) {
  switch (name) {
    case 'STORE_MANAGER':
      return _$changeVendorTeamMemberRoleEnum_STORE_MANAGER;
    case 'STORE_STAFF':
      return _$changeVendorTeamMemberRoleEnum_STORE_STAFF;
    case 'CUSTOMER_SERVICE':
      return _$changeVendorTeamMemberRoleEnum_CUSTOMER_SERVICE;
    case 'INVENTORY':
      return _$changeVendorTeamMemberRoleEnum_INVENTORY;
    case 'FULFILLMENT':
      return _$changeVendorTeamMemberRoleEnum_FULFILLMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChangeVendorTeamMemberRoleEnum>
    _$changeVendorTeamMemberRoleEnumValues = BuiltSet<
        ChangeVendorTeamMemberRoleEnum>(const <ChangeVendorTeamMemberRoleEnum>[
  _$changeVendorTeamMemberRoleEnum_STORE_MANAGER,
  _$changeVendorTeamMemberRoleEnum_STORE_STAFF,
  _$changeVendorTeamMemberRoleEnum_CUSTOMER_SERVICE,
  _$changeVendorTeamMemberRoleEnum_INVENTORY,
  _$changeVendorTeamMemberRoleEnum_FULFILLMENT,
]);

const ChangeVendorTeamMemberStatusEnum
    _$changeVendorTeamMemberStatusEnum_ACTIVE =
    const ChangeVendorTeamMemberStatusEnum._('ACTIVE');
const ChangeVendorTeamMemberStatusEnum
    _$changeVendorTeamMemberStatusEnum_SUSPENDED =
    const ChangeVendorTeamMemberStatusEnum._('SUSPENDED');
const ChangeVendorTeamMemberStatusEnum
    _$changeVendorTeamMemberStatusEnum_DEACTIVATED =
    const ChangeVendorTeamMemberStatusEnum._('DEACTIVATED');

ChangeVendorTeamMemberStatusEnum _$changeVendorTeamMemberStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ACTIVE':
      return _$changeVendorTeamMemberStatusEnum_ACTIVE;
    case 'SUSPENDED':
      return _$changeVendorTeamMemberStatusEnum_SUSPENDED;
    case 'DEACTIVATED':
      return _$changeVendorTeamMemberStatusEnum_DEACTIVATED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChangeVendorTeamMemberStatusEnum>
    _$changeVendorTeamMemberStatusEnumValues = BuiltSet<
        ChangeVendorTeamMemberStatusEnum>(const <ChangeVendorTeamMemberStatusEnum>[
  _$changeVendorTeamMemberStatusEnum_ACTIVE,
  _$changeVendorTeamMemberStatusEnum_SUSPENDED,
  _$changeVendorTeamMemberStatusEnum_DEACTIVATED,
]);

Serializer<ChangeVendorTeamMemberRoleEnum>
    _$changeVendorTeamMemberRoleEnumSerializer =
    _$ChangeVendorTeamMemberRoleEnumSerializer();
Serializer<ChangeVendorTeamMemberStatusEnum>
    _$changeVendorTeamMemberStatusEnumSerializer =
    _$ChangeVendorTeamMemberStatusEnumSerializer();

class _$ChangeVendorTeamMemberRoleEnumSerializer
    implements PrimitiveSerializer<ChangeVendorTeamMemberRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'STORE_MANAGER': 'STORE_MANAGER',
    'STORE_STAFF': 'STORE_STAFF',
    'CUSTOMER_SERVICE': 'CUSTOMER_SERVICE',
    'INVENTORY': 'INVENTORY',
    'FULFILLMENT': 'FULFILLMENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'STORE_MANAGER': 'STORE_MANAGER',
    'STORE_STAFF': 'STORE_STAFF',
    'CUSTOMER_SERVICE': 'CUSTOMER_SERVICE',
    'INVENTORY': 'INVENTORY',
    'FULFILLMENT': 'FULFILLMENT',
  };

  @override
  final Iterable<Type> types = const <Type>[ChangeVendorTeamMemberRoleEnum];
  @override
  final String wireName = 'ChangeVendorTeamMemberRoleEnum';

  @override
  Object serialize(
          Serializers serializers, ChangeVendorTeamMemberRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChangeVendorTeamMemberRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChangeVendorTeamMemberRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChangeVendorTeamMemberStatusEnumSerializer
    implements PrimitiveSerializer<ChangeVendorTeamMemberStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'SUSPENDED': 'SUSPENDED',
    'DEACTIVATED': 'DEACTIVATED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'SUSPENDED': 'SUSPENDED',
    'DEACTIVATED': 'DEACTIVATED',
  };

  @override
  final Iterable<Type> types = const <Type>[ChangeVendorTeamMemberStatusEnum];
  @override
  final String wireName = 'ChangeVendorTeamMemberStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ChangeVendorTeamMemberStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChangeVendorTeamMemberStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChangeVendorTeamMemberStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChangeVendorTeamMember extends ChangeVendorTeamMember {
  @override
  final int lockVersion;
  @override
  final ChangeVendorTeamMemberRoleEnum? role;
  @override
  final ChangeVendorTeamMemberStatusEnum? status;
  @override
  final bool? canManageStaff;

  factory _$ChangeVendorTeamMember(
          [void Function(ChangeVendorTeamMemberBuilder)? updates]) =>
      (ChangeVendorTeamMemberBuilder()..update(updates))._build();

  _$ChangeVendorTeamMember._(
      {required this.lockVersion, this.role, this.status, this.canManageStaff})
      : super._();
  @override
  ChangeVendorTeamMember rebuild(
          void Function(ChangeVendorTeamMemberBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChangeVendorTeamMemberBuilder toBuilder() =>
      ChangeVendorTeamMemberBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChangeVendorTeamMember &&
        lockVersion == other.lockVersion &&
        role == other.role &&
        status == other.status &&
        canManageStaff == other.canManageStaff;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, canManageStaff.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChangeVendorTeamMember')
          ..add('lockVersion', lockVersion)
          ..add('role', role)
          ..add('status', status)
          ..add('canManageStaff', canManageStaff))
        .toString();
  }
}

class ChangeVendorTeamMemberBuilder
    implements Builder<ChangeVendorTeamMember, ChangeVendorTeamMemberBuilder> {
  _$ChangeVendorTeamMember? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ChangeVendorTeamMemberRoleEnum? _role;
  ChangeVendorTeamMemberRoleEnum? get role => _$this._role;
  set role(ChangeVendorTeamMemberRoleEnum? role) => _$this._role = role;

  ChangeVendorTeamMemberStatusEnum? _status;
  ChangeVendorTeamMemberStatusEnum? get status => _$this._status;
  set status(ChangeVendorTeamMemberStatusEnum? status) =>
      _$this._status = status;

  bool? _canManageStaff;
  bool? get canManageStaff => _$this._canManageStaff;
  set canManageStaff(bool? canManageStaff) =>
      _$this._canManageStaff = canManageStaff;

  ChangeVendorTeamMemberBuilder() {
    ChangeVendorTeamMember._defaults(this);
  }

  ChangeVendorTeamMemberBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _role = $v.role;
      _status = $v.status;
      _canManageStaff = $v.canManageStaff;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChangeVendorTeamMember other) {
    _$v = other as _$ChangeVendorTeamMember;
  }

  @override
  void update(void Function(ChangeVendorTeamMemberBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChangeVendorTeamMember build() => _build();

  _$ChangeVendorTeamMember _build() {
    final _$result = _$v ??
        _$ChangeVendorTeamMember._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'ChangeVendorTeamMember', 'lockVersion'),
          role: role,
          status: status,
          canManageStaff: canManageStaff,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
