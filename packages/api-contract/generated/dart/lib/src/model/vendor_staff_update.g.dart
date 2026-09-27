// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_staff_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorStaffUpdateRoleEnum _$vendorStaffUpdateRoleEnum_STORE_MANAGER =
    const VendorStaffUpdateRoleEnum._('STORE_MANAGER');
const VendorStaffUpdateRoleEnum _$vendorStaffUpdateRoleEnum_STORE_STAFF =
    const VendorStaffUpdateRoleEnum._('STORE_STAFF');
const VendorStaffUpdateRoleEnum _$vendorStaffUpdateRoleEnum_CUSTOMER_SERVICE =
    const VendorStaffUpdateRoleEnum._('CUSTOMER_SERVICE');
const VendorStaffUpdateRoleEnum _$vendorStaffUpdateRoleEnum_INVENTORY =
    const VendorStaffUpdateRoleEnum._('INVENTORY');
const VendorStaffUpdateRoleEnum _$vendorStaffUpdateRoleEnum_FULFILLMENT =
    const VendorStaffUpdateRoleEnum._('FULFILLMENT');

VendorStaffUpdateRoleEnum _$vendorStaffUpdateRoleEnumValueOf(String name) {
  switch (name) {
    case 'STORE_MANAGER':
      return _$vendorStaffUpdateRoleEnum_STORE_MANAGER;
    case 'STORE_STAFF':
      return _$vendorStaffUpdateRoleEnum_STORE_STAFF;
    case 'CUSTOMER_SERVICE':
      return _$vendorStaffUpdateRoleEnum_CUSTOMER_SERVICE;
    case 'INVENTORY':
      return _$vendorStaffUpdateRoleEnum_INVENTORY;
    case 'FULFILLMENT':
      return _$vendorStaffUpdateRoleEnum_FULFILLMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorStaffUpdateRoleEnum> _$vendorStaffUpdateRoleEnumValues =
    BuiltSet<VendorStaffUpdateRoleEnum>(const <VendorStaffUpdateRoleEnum>[
  _$vendorStaffUpdateRoleEnum_STORE_MANAGER,
  _$vendorStaffUpdateRoleEnum_STORE_STAFF,
  _$vendorStaffUpdateRoleEnum_CUSTOMER_SERVICE,
  _$vendorStaffUpdateRoleEnum_INVENTORY,
  _$vendorStaffUpdateRoleEnum_FULFILLMENT,
]);

Serializer<VendorStaffUpdateRoleEnum> _$vendorStaffUpdateRoleEnumSerializer =
    _$VendorStaffUpdateRoleEnumSerializer();

class _$VendorStaffUpdateRoleEnumSerializer
    implements PrimitiveSerializer<VendorStaffUpdateRoleEnum> {
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
  final Iterable<Type> types = const <Type>[VendorStaffUpdateRoleEnum];
  @override
  final String wireName = 'VendorStaffUpdateRoleEnum';

  @override
  Object serialize(Serializers serializers, VendorStaffUpdateRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorStaffUpdateRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorStaffUpdateRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorStaffUpdate extends VendorStaffUpdate {
  @override
  final String fullName;
  @override
  final VendorStaffUpdateRoleEnum role;
  @override
  final int lockVersion;

  factory _$VendorStaffUpdate(
          [void Function(VendorStaffUpdateBuilder)? updates]) =>
      (VendorStaffUpdateBuilder()..update(updates))._build();

  _$VendorStaffUpdate._(
      {required this.fullName, required this.role, required this.lockVersion})
      : super._();
  @override
  VendorStaffUpdate rebuild(void Function(VendorStaffUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorStaffUpdateBuilder toBuilder() =>
      VendorStaffUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorStaffUpdate &&
        fullName == other.fullName &&
        role == other.role &&
        lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorStaffUpdate')
          ..add('fullName', fullName)
          ..add('role', role)
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class VendorStaffUpdateBuilder
    implements Builder<VendorStaffUpdate, VendorStaffUpdateBuilder> {
  _$VendorStaffUpdate? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  VendorStaffUpdateRoleEnum? _role;
  VendorStaffUpdateRoleEnum? get role => _$this._role;
  set role(VendorStaffUpdateRoleEnum? role) => _$this._role = role;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  VendorStaffUpdateBuilder() {
    VendorStaffUpdate._defaults(this);
  }

  VendorStaffUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fullName = $v.fullName;
      _role = $v.role;
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorStaffUpdate other) {
    _$v = other as _$VendorStaffUpdate;
  }

  @override
  void update(void Function(VendorStaffUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorStaffUpdate build() => _build();

  _$VendorStaffUpdate _build() {
    final _$result = _$v ??
        _$VendorStaffUpdate._(
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'VendorStaffUpdate', 'fullName'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'VendorStaffUpdate', 'role'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'VendorStaffUpdate', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
