// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_invitation_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorInvitationRequestRoleEnum
    _$vendorInvitationRequestRoleEnum_STORE_MANAGER =
    const VendorInvitationRequestRoleEnum._('STORE_MANAGER');
const VendorInvitationRequestRoleEnum
    _$vendorInvitationRequestRoleEnum_STORE_STAFF =
    const VendorInvitationRequestRoleEnum._('STORE_STAFF');
const VendorInvitationRequestRoleEnum
    _$vendorInvitationRequestRoleEnum_CUSTOMER_SERVICE =
    const VendorInvitationRequestRoleEnum._('CUSTOMER_SERVICE');
const VendorInvitationRequestRoleEnum
    _$vendorInvitationRequestRoleEnum_INVENTORY =
    const VendorInvitationRequestRoleEnum._('INVENTORY');
const VendorInvitationRequestRoleEnum
    _$vendorInvitationRequestRoleEnum_FULFILLMENT =
    const VendorInvitationRequestRoleEnum._('FULFILLMENT');

VendorInvitationRequestRoleEnum _$vendorInvitationRequestRoleEnumValueOf(
    String name) {
  switch (name) {
    case 'STORE_MANAGER':
      return _$vendorInvitationRequestRoleEnum_STORE_MANAGER;
    case 'STORE_STAFF':
      return _$vendorInvitationRequestRoleEnum_STORE_STAFF;
    case 'CUSTOMER_SERVICE':
      return _$vendorInvitationRequestRoleEnum_CUSTOMER_SERVICE;
    case 'INVENTORY':
      return _$vendorInvitationRequestRoleEnum_INVENTORY;
    case 'FULFILLMENT':
      return _$vendorInvitationRequestRoleEnum_FULFILLMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorInvitationRequestRoleEnum>
    _$vendorInvitationRequestRoleEnumValues = BuiltSet<
        VendorInvitationRequestRoleEnum>(const <VendorInvitationRequestRoleEnum>[
  _$vendorInvitationRequestRoleEnum_STORE_MANAGER,
  _$vendorInvitationRequestRoleEnum_STORE_STAFF,
  _$vendorInvitationRequestRoleEnum_CUSTOMER_SERVICE,
  _$vendorInvitationRequestRoleEnum_INVENTORY,
  _$vendorInvitationRequestRoleEnum_FULFILLMENT,
]);

Serializer<VendorInvitationRequestRoleEnum>
    _$vendorInvitationRequestRoleEnumSerializer =
    _$VendorInvitationRequestRoleEnumSerializer();

class _$VendorInvitationRequestRoleEnumSerializer
    implements PrimitiveSerializer<VendorInvitationRequestRoleEnum> {
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
  final Iterable<Type> types = const <Type>[VendorInvitationRequestRoleEnum];
  @override
  final String wireName = 'VendorInvitationRequestRoleEnum';

  @override
  Object serialize(
          Serializers serializers, VendorInvitationRequestRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorInvitationRequestRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorInvitationRequestRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorInvitationRequest extends VendorInvitationRequest {
  @override
  final String email;
  @override
  final String inviteeName;
  @override
  final String? inviteeMobile;
  @override
  final VendorInvitationRequestRoleEnum role;
  @override
  final bool? canManageStaff;

  factory _$VendorInvitationRequest(
          [void Function(VendorInvitationRequestBuilder)? updates]) =>
      (VendorInvitationRequestBuilder()..update(updates))._build();

  _$VendorInvitationRequest._(
      {required this.email,
      required this.inviteeName,
      this.inviteeMobile,
      required this.role,
      this.canManageStaff})
      : super._();
  @override
  VendorInvitationRequest rebuild(
          void Function(VendorInvitationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorInvitationRequestBuilder toBuilder() =>
      VendorInvitationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorInvitationRequest &&
        email == other.email &&
        inviteeName == other.inviteeName &&
        inviteeMobile == other.inviteeMobile &&
        role == other.role &&
        canManageStaff == other.canManageStaff;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, inviteeName.hashCode);
    _$hash = $jc(_$hash, inviteeMobile.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, canManageStaff.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorInvitationRequest')
          ..add('email', email)
          ..add('inviteeName', inviteeName)
          ..add('inviteeMobile', inviteeMobile)
          ..add('role', role)
          ..add('canManageStaff', canManageStaff))
        .toString();
  }
}

class VendorInvitationRequestBuilder
    implements
        Builder<VendorInvitationRequest, VendorInvitationRequestBuilder> {
  _$VendorInvitationRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _inviteeName;
  String? get inviteeName => _$this._inviteeName;
  set inviteeName(String? inviteeName) => _$this._inviteeName = inviteeName;

  String? _inviteeMobile;
  String? get inviteeMobile => _$this._inviteeMobile;
  set inviteeMobile(String? inviteeMobile) =>
      _$this._inviteeMobile = inviteeMobile;

  VendorInvitationRequestRoleEnum? _role;
  VendorInvitationRequestRoleEnum? get role => _$this._role;
  set role(VendorInvitationRequestRoleEnum? role) => _$this._role = role;

  bool? _canManageStaff;
  bool? get canManageStaff => _$this._canManageStaff;
  set canManageStaff(bool? canManageStaff) =>
      _$this._canManageStaff = canManageStaff;

  VendorInvitationRequestBuilder() {
    VendorInvitationRequest._defaults(this);
  }

  VendorInvitationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _inviteeName = $v.inviteeName;
      _inviteeMobile = $v.inviteeMobile;
      _role = $v.role;
      _canManageStaff = $v.canManageStaff;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorInvitationRequest other) {
    _$v = other as _$VendorInvitationRequest;
  }

  @override
  void update(void Function(VendorInvitationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorInvitationRequest build() => _build();

  _$VendorInvitationRequest _build() {
    final _$result = _$v ??
        _$VendorInvitationRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'VendorInvitationRequest', 'email'),
          inviteeName: BuiltValueNullFieldError.checkNotNull(
              inviteeName, r'VendorInvitationRequest', 'inviteeName'),
          inviteeMobile: inviteeMobile,
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'VendorInvitationRequest', 'role'),
          canManageStaff: canManageStaff,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
