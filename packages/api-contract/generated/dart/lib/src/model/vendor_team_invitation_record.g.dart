// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_invitation_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorTeamInvitationRecordStatusEnum
    _$vendorTeamInvitationRecordStatusEnum_PENDING =
    const VendorTeamInvitationRecordStatusEnum._('PENDING');
const VendorTeamInvitationRecordStatusEnum
    _$vendorTeamInvitationRecordStatusEnum_ACCEPTED =
    const VendorTeamInvitationRecordStatusEnum._('ACCEPTED');
const VendorTeamInvitationRecordStatusEnum
    _$vendorTeamInvitationRecordStatusEnum_REVOKED =
    const VendorTeamInvitationRecordStatusEnum._('REVOKED');
const VendorTeamInvitationRecordStatusEnum
    _$vendorTeamInvitationRecordStatusEnum_EXPIRED =
    const VendorTeamInvitationRecordStatusEnum._('EXPIRED');

VendorTeamInvitationRecordStatusEnum
    _$vendorTeamInvitationRecordStatusEnumValueOf(String name) {
  switch (name) {
    case 'PENDING':
      return _$vendorTeamInvitationRecordStatusEnum_PENDING;
    case 'ACCEPTED':
      return _$vendorTeamInvitationRecordStatusEnum_ACCEPTED;
    case 'REVOKED':
      return _$vendorTeamInvitationRecordStatusEnum_REVOKED;
    case 'EXPIRED':
      return _$vendorTeamInvitationRecordStatusEnum_EXPIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorTeamInvitationRecordStatusEnum>
    _$vendorTeamInvitationRecordStatusEnumValues = BuiltSet<
        VendorTeamInvitationRecordStatusEnum>(const <VendorTeamInvitationRecordStatusEnum>[
  _$vendorTeamInvitationRecordStatusEnum_PENDING,
  _$vendorTeamInvitationRecordStatusEnum_ACCEPTED,
  _$vendorTeamInvitationRecordStatusEnum_REVOKED,
  _$vendorTeamInvitationRecordStatusEnum_EXPIRED,
]);

Serializer<VendorTeamInvitationRecordStatusEnum>
    _$vendorTeamInvitationRecordStatusEnumSerializer =
    _$VendorTeamInvitationRecordStatusEnumSerializer();

class _$VendorTeamInvitationRecordStatusEnumSerializer
    implements PrimitiveSerializer<VendorTeamInvitationRecordStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING': 'PENDING',
    'ACCEPTED': 'ACCEPTED',
    'REVOKED': 'REVOKED',
    'EXPIRED': 'EXPIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'PENDING',
    'ACCEPTED': 'ACCEPTED',
    'REVOKED': 'REVOKED',
    'EXPIRED': 'EXPIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorTeamInvitationRecordStatusEnum
  ];
  @override
  final String wireName = 'VendorTeamInvitationRecordStatusEnum';

  @override
  Object serialize(
          Serializers serializers, VendorTeamInvitationRecordStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorTeamInvitationRecordStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorTeamInvitationRecordStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorTeamInvitationRecord extends VendorTeamInvitationRecord {
  @override
  final String id;
  @override
  final String? inviteeName;
  @override
  final String email;
  @override
  final String? inviteeMobile;
  @override
  final String vendorOrganizationId;
  @override
  final String role;
  @override
  final bool canManageStaff;
  @override
  final VendorTeamInvitationRecordStatusEnum status;
  @override
  final String invitedById;
  @override
  final String invitedByName;
  @override
  final DateTime createdAt;
  @override
  final DateTime expiresAt;
  @override
  final DateTime? acceptedAt;

  factory _$VendorTeamInvitationRecord(
          [void Function(VendorTeamInvitationRecordBuilder)? updates]) =>
      (VendorTeamInvitationRecordBuilder()..update(updates))._build();

  _$VendorTeamInvitationRecord._(
      {required this.id,
      this.inviteeName,
      required this.email,
      this.inviteeMobile,
      required this.vendorOrganizationId,
      required this.role,
      required this.canManageStaff,
      required this.status,
      required this.invitedById,
      required this.invitedByName,
      required this.createdAt,
      required this.expiresAt,
      this.acceptedAt})
      : super._();
  @override
  VendorTeamInvitationRecord rebuild(
          void Function(VendorTeamInvitationRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamInvitationRecordBuilder toBuilder() =>
      VendorTeamInvitationRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamInvitationRecord &&
        id == other.id &&
        inviteeName == other.inviteeName &&
        email == other.email &&
        inviteeMobile == other.inviteeMobile &&
        vendorOrganizationId == other.vendorOrganizationId &&
        role == other.role &&
        canManageStaff == other.canManageStaff &&
        status == other.status &&
        invitedById == other.invitedById &&
        invitedByName == other.invitedByName &&
        createdAt == other.createdAt &&
        expiresAt == other.expiresAt &&
        acceptedAt == other.acceptedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, inviteeName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, inviteeMobile.hashCode);
    _$hash = $jc(_$hash, vendorOrganizationId.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, canManageStaff.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, invitedById.hashCode);
    _$hash = $jc(_$hash, invitedByName.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, acceptedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeamInvitationRecord')
          ..add('id', id)
          ..add('inviteeName', inviteeName)
          ..add('email', email)
          ..add('inviteeMobile', inviteeMobile)
          ..add('vendorOrganizationId', vendorOrganizationId)
          ..add('role', role)
          ..add('canManageStaff', canManageStaff)
          ..add('status', status)
          ..add('invitedById', invitedById)
          ..add('invitedByName', invitedByName)
          ..add('createdAt', createdAt)
          ..add('expiresAt', expiresAt)
          ..add('acceptedAt', acceptedAt))
        .toString();
  }
}

class VendorTeamInvitationRecordBuilder
    implements
        Builder<VendorTeamInvitationRecord, VendorTeamInvitationRecordBuilder> {
  _$VendorTeamInvitationRecord? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _inviteeName;
  String? get inviteeName => _$this._inviteeName;
  set inviteeName(String? inviteeName) => _$this._inviteeName = inviteeName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _inviteeMobile;
  String? get inviteeMobile => _$this._inviteeMobile;
  set inviteeMobile(String? inviteeMobile) =>
      _$this._inviteeMobile = inviteeMobile;

  String? _vendorOrganizationId;
  String? get vendorOrganizationId => _$this._vendorOrganizationId;
  set vendorOrganizationId(String? vendorOrganizationId) =>
      _$this._vendorOrganizationId = vendorOrganizationId;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  bool? _canManageStaff;
  bool? get canManageStaff => _$this._canManageStaff;
  set canManageStaff(bool? canManageStaff) =>
      _$this._canManageStaff = canManageStaff;

  VendorTeamInvitationRecordStatusEnum? _status;
  VendorTeamInvitationRecordStatusEnum? get status => _$this._status;
  set status(VendorTeamInvitationRecordStatusEnum? status) =>
      _$this._status = status;

  String? _invitedById;
  String? get invitedById => _$this._invitedById;
  set invitedById(String? invitedById) => _$this._invitedById = invitedById;

  String? _invitedByName;
  String? get invitedByName => _$this._invitedByName;
  set invitedByName(String? invitedByName) =>
      _$this._invitedByName = invitedByName;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DateTime? _acceptedAt;
  DateTime? get acceptedAt => _$this._acceptedAt;
  set acceptedAt(DateTime? acceptedAt) => _$this._acceptedAt = acceptedAt;

  VendorTeamInvitationRecordBuilder() {
    VendorTeamInvitationRecord._defaults(this);
  }

  VendorTeamInvitationRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _inviteeName = $v.inviteeName;
      _email = $v.email;
      _inviteeMobile = $v.inviteeMobile;
      _vendorOrganizationId = $v.vendorOrganizationId;
      _role = $v.role;
      _canManageStaff = $v.canManageStaff;
      _status = $v.status;
      _invitedById = $v.invitedById;
      _invitedByName = $v.invitedByName;
      _createdAt = $v.createdAt;
      _expiresAt = $v.expiresAt;
      _acceptedAt = $v.acceptedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamInvitationRecord other) {
    _$v = other as _$VendorTeamInvitationRecord;
  }

  @override
  void update(void Function(VendorTeamInvitationRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamInvitationRecord build() => _build();

  _$VendorTeamInvitationRecord _build() {
    final _$result = _$v ??
        _$VendorTeamInvitationRecord._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'VendorTeamInvitationRecord', 'id'),
          inviteeName: inviteeName,
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'VendorTeamInvitationRecord', 'email'),
          inviteeMobile: inviteeMobile,
          vendorOrganizationId: BuiltValueNullFieldError.checkNotNull(
              vendorOrganizationId,
              r'VendorTeamInvitationRecord',
              'vendorOrganizationId'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'VendorTeamInvitationRecord', 'role'),
          canManageStaff: BuiltValueNullFieldError.checkNotNull(
              canManageStaff, r'VendorTeamInvitationRecord', 'canManageStaff'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'VendorTeamInvitationRecord', 'status'),
          invitedById: BuiltValueNullFieldError.checkNotNull(
              invitedById, r'VendorTeamInvitationRecord', 'invitedById'),
          invitedByName: BuiltValueNullFieldError.checkNotNull(
              invitedByName, r'VendorTeamInvitationRecord', 'invitedByName'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'VendorTeamInvitationRecord', 'createdAt'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'VendorTeamInvitationRecord', 'expiresAt'),
          acceptedAt: acceptedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
