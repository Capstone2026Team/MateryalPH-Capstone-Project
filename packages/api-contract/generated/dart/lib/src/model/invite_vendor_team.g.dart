// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_vendor_team.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InviteVendorTeamRoleEnum _$inviteVendorTeamRoleEnum_STORE_MANAGER =
    const InviteVendorTeamRoleEnum._('STORE_MANAGER');
const InviteVendorTeamRoleEnum _$inviteVendorTeamRoleEnum_STORE_STAFF =
    const InviteVendorTeamRoleEnum._('STORE_STAFF');
const InviteVendorTeamRoleEnum _$inviteVendorTeamRoleEnum_CUSTOMER_SERVICE =
    const InviteVendorTeamRoleEnum._('CUSTOMER_SERVICE');
const InviteVendorTeamRoleEnum _$inviteVendorTeamRoleEnum_INVENTORY =
    const InviteVendorTeamRoleEnum._('INVENTORY');
const InviteVendorTeamRoleEnum _$inviteVendorTeamRoleEnum_FULFILLMENT =
    const InviteVendorTeamRoleEnum._('FULFILLMENT');

InviteVendorTeamRoleEnum _$inviteVendorTeamRoleEnumValueOf(String name) {
  switch (name) {
    case 'STORE_MANAGER':
      return _$inviteVendorTeamRoleEnum_STORE_MANAGER;
    case 'STORE_STAFF':
      return _$inviteVendorTeamRoleEnum_STORE_STAFF;
    case 'CUSTOMER_SERVICE':
      return _$inviteVendorTeamRoleEnum_CUSTOMER_SERVICE;
    case 'INVENTORY':
      return _$inviteVendorTeamRoleEnum_INVENTORY;
    case 'FULFILLMENT':
      return _$inviteVendorTeamRoleEnum_FULFILLMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InviteVendorTeamRoleEnum> _$inviteVendorTeamRoleEnumValues =
    BuiltSet<InviteVendorTeamRoleEnum>(const <InviteVendorTeamRoleEnum>[
  _$inviteVendorTeamRoleEnum_STORE_MANAGER,
  _$inviteVendorTeamRoleEnum_STORE_STAFF,
  _$inviteVendorTeamRoleEnum_CUSTOMER_SERVICE,
  _$inviteVendorTeamRoleEnum_INVENTORY,
  _$inviteVendorTeamRoleEnum_FULFILLMENT,
]);

Serializer<InviteVendorTeamRoleEnum> _$inviteVendorTeamRoleEnumSerializer =
    _$InviteVendorTeamRoleEnumSerializer();

class _$InviteVendorTeamRoleEnumSerializer
    implements PrimitiveSerializer<InviteVendorTeamRoleEnum> {
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
  final Iterable<Type> types = const <Type>[InviteVendorTeamRoleEnum];
  @override
  final String wireName = 'InviteVendorTeamRoleEnum';

  @override
  Object serialize(Serializers serializers, InviteVendorTeamRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InviteVendorTeamRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InviteVendorTeamRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InviteVendorTeam extends InviteVendorTeam {
  @override
  final String fullName;
  @override
  final String email;
  @override
  final String? telephoneE164;
  @override
  final InviteVendorTeamRoleEnum role;
  @override
  final bool? canManageStaff;
  @override
  final DateTime expiresAt;

  factory _$InviteVendorTeam(
          [void Function(InviteVendorTeamBuilder)? updates]) =>
      (InviteVendorTeamBuilder()..update(updates))._build();

  _$InviteVendorTeam._(
      {required this.fullName,
      required this.email,
      this.telephoneE164,
      required this.role,
      this.canManageStaff,
      required this.expiresAt})
      : super._();
  @override
  InviteVendorTeam rebuild(void Function(InviteVendorTeamBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InviteVendorTeamBuilder toBuilder() =>
      InviteVendorTeamBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InviteVendorTeam &&
        fullName == other.fullName &&
        email == other.email &&
        telephoneE164 == other.telephoneE164 &&
        role == other.role &&
        canManageStaff == other.canManageStaff &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, telephoneE164.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, canManageStaff.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InviteVendorTeam')
          ..add('fullName', fullName)
          ..add('email', email)
          ..add('telephoneE164', telephoneE164)
          ..add('role', role)
          ..add('canManageStaff', canManageStaff)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class InviteVendorTeamBuilder
    implements Builder<InviteVendorTeam, InviteVendorTeamBuilder> {
  _$InviteVendorTeam? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _telephoneE164;
  String? get telephoneE164 => _$this._telephoneE164;
  set telephoneE164(String? telephoneE164) =>
      _$this._telephoneE164 = telephoneE164;

  InviteVendorTeamRoleEnum? _role;
  InviteVendorTeamRoleEnum? get role => _$this._role;
  set role(InviteVendorTeamRoleEnum? role) => _$this._role = role;

  bool? _canManageStaff;
  bool? get canManageStaff => _$this._canManageStaff;
  set canManageStaff(bool? canManageStaff) =>
      _$this._canManageStaff = canManageStaff;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  InviteVendorTeamBuilder() {
    InviteVendorTeam._defaults(this);
  }

  InviteVendorTeamBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fullName = $v.fullName;
      _email = $v.email;
      _telephoneE164 = $v.telephoneE164;
      _role = $v.role;
      _canManageStaff = $v.canManageStaff;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InviteVendorTeam other) {
    _$v = other as _$InviteVendorTeam;
  }

  @override
  void update(void Function(InviteVendorTeamBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InviteVendorTeam build() => _build();

  _$InviteVendorTeam _build() {
    final _$result = _$v ??
        _$InviteVendorTeam._(
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'InviteVendorTeam', 'fullName'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'InviteVendorTeam', 'email'),
          telephoneE164: telephoneE164,
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'InviteVendorTeam', 'role'),
          canManageStaff: canManageStaff,
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'InviteVendorTeam', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
