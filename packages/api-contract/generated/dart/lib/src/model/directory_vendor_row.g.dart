// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_vendor_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DirectoryVendorRowStatusEnum _$directoryVendorRowStatusEnum_NOT_READY =
    const DirectoryVendorRowStatusEnum._('NOT_READY');
const DirectoryVendorRowStatusEnum _$directoryVendorRowStatusEnum_READY =
    const DirectoryVendorRowStatusEnum._('READY');
const DirectoryVendorRowStatusEnum _$directoryVendorRowStatusEnum_ACTIVE =
    const DirectoryVendorRowStatusEnum._('ACTIVE');
const DirectoryVendorRowStatusEnum _$directoryVendorRowStatusEnum_RESTRICTED =
    const DirectoryVendorRowStatusEnum._('RESTRICTED');
const DirectoryVendorRowStatusEnum _$directoryVendorRowStatusEnum_SUSPENDED =
    const DirectoryVendorRowStatusEnum._('SUSPENDED');

DirectoryVendorRowStatusEnum _$directoryVendorRowStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'NOT_READY':
      return _$directoryVendorRowStatusEnum_NOT_READY;
    case 'READY':
      return _$directoryVendorRowStatusEnum_READY;
    case 'ACTIVE':
      return _$directoryVendorRowStatusEnum_ACTIVE;
    case 'RESTRICTED':
      return _$directoryVendorRowStatusEnum_RESTRICTED;
    case 'SUSPENDED':
      return _$directoryVendorRowStatusEnum_SUSPENDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectoryVendorRowStatusEnum>
    _$directoryVendorRowStatusEnumValues =
    BuiltSet<DirectoryVendorRowStatusEnum>(const <DirectoryVendorRowStatusEnum>[
  _$directoryVendorRowStatusEnum_NOT_READY,
  _$directoryVendorRowStatusEnum_READY,
  _$directoryVendorRowStatusEnum_ACTIVE,
  _$directoryVendorRowStatusEnum_RESTRICTED,
  _$directoryVendorRowStatusEnum_SUSPENDED,
]);

const DirectoryVendorRowVerificationStatusEnum
    _$directoryVendorRowVerificationStatusEnum_NOT_STARTED =
    const DirectoryVendorRowVerificationStatusEnum._('NOT_STARTED');
const DirectoryVendorRowVerificationStatusEnum
    _$directoryVendorRowVerificationStatusEnum_IN_PROGRESS =
    const DirectoryVendorRowVerificationStatusEnum._('IN_PROGRESS');
const DirectoryVendorRowVerificationStatusEnum
    _$directoryVendorRowVerificationStatusEnum_SUBMITTED =
    const DirectoryVendorRowVerificationStatusEnum._('SUBMITTED');
const DirectoryVendorRowVerificationStatusEnum
    _$directoryVendorRowVerificationStatusEnum_PENDING_VERIFICATION =
    const DirectoryVendorRowVerificationStatusEnum._('PENDING_VERIFICATION');
const DirectoryVendorRowVerificationStatusEnum
    _$directoryVendorRowVerificationStatusEnum_APPROVED =
    const DirectoryVendorRowVerificationStatusEnum._('APPROVED');
const DirectoryVendorRowVerificationStatusEnum
    _$directoryVendorRowVerificationStatusEnum_CHANGES_REQUIRED =
    const DirectoryVendorRowVerificationStatusEnum._('CHANGES_REQUIRED');
const DirectoryVendorRowVerificationStatusEnum
    _$directoryVendorRowVerificationStatusEnum_REJECTED =
    const DirectoryVendorRowVerificationStatusEnum._('REJECTED');
const DirectoryVendorRowVerificationStatusEnum
    _$directoryVendorRowVerificationStatusEnum_EXPIRED =
    const DirectoryVendorRowVerificationStatusEnum._('EXPIRED');

DirectoryVendorRowVerificationStatusEnum
    _$directoryVendorRowVerificationStatusEnumValueOf(String name) {
  switch (name) {
    case 'NOT_STARTED':
      return _$directoryVendorRowVerificationStatusEnum_NOT_STARTED;
    case 'IN_PROGRESS':
      return _$directoryVendorRowVerificationStatusEnum_IN_PROGRESS;
    case 'SUBMITTED':
      return _$directoryVendorRowVerificationStatusEnum_SUBMITTED;
    case 'PENDING_VERIFICATION':
      return _$directoryVendorRowVerificationStatusEnum_PENDING_VERIFICATION;
    case 'APPROVED':
      return _$directoryVendorRowVerificationStatusEnum_APPROVED;
    case 'CHANGES_REQUIRED':
      return _$directoryVendorRowVerificationStatusEnum_CHANGES_REQUIRED;
    case 'REJECTED':
      return _$directoryVendorRowVerificationStatusEnum_REJECTED;
    case 'EXPIRED':
      return _$directoryVendorRowVerificationStatusEnum_EXPIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectoryVendorRowVerificationStatusEnum>
    _$directoryVendorRowVerificationStatusEnumValues = BuiltSet<
        DirectoryVendorRowVerificationStatusEnum>(const <DirectoryVendorRowVerificationStatusEnum>[
  _$directoryVendorRowVerificationStatusEnum_NOT_STARTED,
  _$directoryVendorRowVerificationStatusEnum_IN_PROGRESS,
  _$directoryVendorRowVerificationStatusEnum_SUBMITTED,
  _$directoryVendorRowVerificationStatusEnum_PENDING_VERIFICATION,
  _$directoryVendorRowVerificationStatusEnum_APPROVED,
  _$directoryVendorRowVerificationStatusEnum_CHANGES_REQUIRED,
  _$directoryVendorRowVerificationStatusEnum_REJECTED,
  _$directoryVendorRowVerificationStatusEnum_EXPIRED,
]);

Serializer<DirectoryVendorRowStatusEnum>
    _$directoryVendorRowStatusEnumSerializer =
    _$DirectoryVendorRowStatusEnumSerializer();
Serializer<DirectoryVendorRowVerificationStatusEnum>
    _$directoryVendorRowVerificationStatusEnumSerializer =
    _$DirectoryVendorRowVerificationStatusEnumSerializer();

class _$DirectoryVendorRowStatusEnumSerializer
    implements PrimitiveSerializer<DirectoryVendorRowStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_READY': 'NOT_READY',
    'READY': 'READY',
    'ACTIVE': 'ACTIVE',
    'RESTRICTED': 'RESTRICTED',
    'SUSPENDED': 'SUSPENDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_READY': 'NOT_READY',
    'READY': 'READY',
    'ACTIVE': 'ACTIVE',
    'RESTRICTED': 'RESTRICTED',
    'SUSPENDED': 'SUSPENDED',
  };

  @override
  final Iterable<Type> types = const <Type>[DirectoryVendorRowStatusEnum];
  @override
  final String wireName = 'DirectoryVendorRowStatusEnum';

  @override
  Object serialize(Serializers serializers, DirectoryVendorRowStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectoryVendorRowStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectoryVendorRowStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectoryVendorRowVerificationStatusEnumSerializer
    implements PrimitiveSerializer<DirectoryVendorRowVerificationStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_STARTED': 'NOT_STARTED',
    'IN_PROGRESS': 'IN_PROGRESS',
    'SUBMITTED': 'SUBMITTED',
    'PENDING_VERIFICATION': 'PENDING_VERIFICATION',
    'APPROVED': 'APPROVED',
    'CHANGES_REQUIRED': 'CHANGES_REQUIRED',
    'REJECTED': 'REJECTED',
    'EXPIRED': 'EXPIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_STARTED': 'NOT_STARTED',
    'IN_PROGRESS': 'IN_PROGRESS',
    'SUBMITTED': 'SUBMITTED',
    'PENDING_VERIFICATION': 'PENDING_VERIFICATION',
    'APPROVED': 'APPROVED',
    'CHANGES_REQUIRED': 'CHANGES_REQUIRED',
    'REJECTED': 'REJECTED',
    'EXPIRED': 'EXPIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    DirectoryVendorRowVerificationStatusEnum
  ];
  @override
  final String wireName = 'DirectoryVendorRowVerificationStatusEnum';

  @override
  Object serialize(Serializers serializers,
          DirectoryVendorRowVerificationStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectoryVendorRowVerificationStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectoryVendorRowVerificationStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectoryVendorRow extends DirectoryVendorRow {
  @override
  final String id;
  @override
  final String storeName;
  @override
  final String? ownerName;
  @override
  final String? ownerEmail;
  @override
  final DirectoryVendorRowStatusEnum status;
  @override
  final DirectoryVendorRowVerificationStatusEnum verificationStatus;
  @override
  final String discoverabilityStatus;
  @override
  final String accountStatus;
  @override
  final String? location;
  @override
  final DateTime joinedAt;

  factory _$DirectoryVendorRow(
          [void Function(DirectoryVendorRowBuilder)? updates]) =>
      (DirectoryVendorRowBuilder()..update(updates))._build();

  _$DirectoryVendorRow._(
      {required this.id,
      required this.storeName,
      this.ownerName,
      this.ownerEmail,
      required this.status,
      required this.verificationStatus,
      required this.discoverabilityStatus,
      required this.accountStatus,
      this.location,
      required this.joinedAt})
      : super._();
  @override
  DirectoryVendorRow rebuild(
          void Function(DirectoryVendorRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryVendorRowBuilder toBuilder() =>
      DirectoryVendorRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryVendorRow &&
        id == other.id &&
        storeName == other.storeName &&
        ownerName == other.ownerName &&
        ownerEmail == other.ownerEmail &&
        status == other.status &&
        verificationStatus == other.verificationStatus &&
        discoverabilityStatus == other.discoverabilityStatus &&
        accountStatus == other.accountStatus &&
        location == other.location &&
        joinedAt == other.joinedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, storeName.hashCode);
    _$hash = $jc(_$hash, ownerName.hashCode);
    _$hash = $jc(_$hash, ownerEmail.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, verificationStatus.hashCode);
    _$hash = $jc(_$hash, discoverabilityStatus.hashCode);
    _$hash = $jc(_$hash, accountStatus.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, joinedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryVendorRow')
          ..add('id', id)
          ..add('storeName', storeName)
          ..add('ownerName', ownerName)
          ..add('ownerEmail', ownerEmail)
          ..add('status', status)
          ..add('verificationStatus', verificationStatus)
          ..add('discoverabilityStatus', discoverabilityStatus)
          ..add('accountStatus', accountStatus)
          ..add('location', location)
          ..add('joinedAt', joinedAt))
        .toString();
  }
}

class DirectoryVendorRowBuilder
    implements Builder<DirectoryVendorRow, DirectoryVendorRowBuilder> {
  _$DirectoryVendorRow? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _storeName;
  String? get storeName => _$this._storeName;
  set storeName(String? storeName) => _$this._storeName = storeName;

  String? _ownerName;
  String? get ownerName => _$this._ownerName;
  set ownerName(String? ownerName) => _$this._ownerName = ownerName;

  String? _ownerEmail;
  String? get ownerEmail => _$this._ownerEmail;
  set ownerEmail(String? ownerEmail) => _$this._ownerEmail = ownerEmail;

  DirectoryVendorRowStatusEnum? _status;
  DirectoryVendorRowStatusEnum? get status => _$this._status;
  set status(DirectoryVendorRowStatusEnum? status) => _$this._status = status;

  DirectoryVendorRowVerificationStatusEnum? _verificationStatus;
  DirectoryVendorRowVerificationStatusEnum? get verificationStatus =>
      _$this._verificationStatus;
  set verificationStatus(
          DirectoryVendorRowVerificationStatusEnum? verificationStatus) =>
      _$this._verificationStatus = verificationStatus;

  String? _discoverabilityStatus;
  String? get discoverabilityStatus => _$this._discoverabilityStatus;
  set discoverabilityStatus(String? discoverabilityStatus) =>
      _$this._discoverabilityStatus = discoverabilityStatus;

  String? _accountStatus;
  String? get accountStatus => _$this._accountStatus;
  set accountStatus(String? accountStatus) =>
      _$this._accountStatus = accountStatus;

  String? _location;
  String? get location => _$this._location;
  set location(String? location) => _$this._location = location;

  DateTime? _joinedAt;
  DateTime? get joinedAt => _$this._joinedAt;
  set joinedAt(DateTime? joinedAt) => _$this._joinedAt = joinedAt;

  DirectoryVendorRowBuilder() {
    DirectoryVendorRow._defaults(this);
  }

  DirectoryVendorRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _storeName = $v.storeName;
      _ownerName = $v.ownerName;
      _ownerEmail = $v.ownerEmail;
      _status = $v.status;
      _verificationStatus = $v.verificationStatus;
      _discoverabilityStatus = $v.discoverabilityStatus;
      _accountStatus = $v.accountStatus;
      _location = $v.location;
      _joinedAt = $v.joinedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryVendorRow other) {
    _$v = other as _$DirectoryVendorRow;
  }

  @override
  void update(void Function(DirectoryVendorRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryVendorRow build() => _build();

  _$DirectoryVendorRow _build() {
    final _$result = _$v ??
        _$DirectoryVendorRow._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'DirectoryVendorRow', 'id'),
          storeName: BuiltValueNullFieldError.checkNotNull(
              storeName, r'DirectoryVendorRow', 'storeName'),
          ownerName: ownerName,
          ownerEmail: ownerEmail,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'DirectoryVendorRow', 'status'),
          verificationStatus: BuiltValueNullFieldError.checkNotNull(
              verificationStatus, r'DirectoryVendorRow', 'verificationStatus'),
          discoverabilityStatus: BuiltValueNullFieldError.checkNotNull(
              discoverabilityStatus,
              r'DirectoryVendorRow',
              'discoverabilityStatus'),
          accountStatus: BuiltValueNullFieldError.checkNotNull(
              accountStatus, r'DirectoryVendorRow', 'accountStatus'),
          location: location,
          joinedAt: BuiltValueNullFieldError.checkNotNull(
              joinedAt, r'DirectoryVendorRow', 'joinedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
