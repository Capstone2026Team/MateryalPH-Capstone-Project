// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_buyer_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DirectoryBuyerRowStatusEnum _$directoryBuyerRowStatusEnum_ACTIVE =
    const DirectoryBuyerRowStatusEnum._('ACTIVE');
const DirectoryBuyerRowStatusEnum
    _$directoryBuyerRowStatusEnum_PENDING_VERIFICATION =
    const DirectoryBuyerRowStatusEnum._('PENDING_VERIFICATION');
const DirectoryBuyerRowStatusEnum _$directoryBuyerRowStatusEnum_SUSPENDED =
    const DirectoryBuyerRowStatusEnum._('SUSPENDED');
const DirectoryBuyerRowStatusEnum _$directoryBuyerRowStatusEnum_DEACTIVATED =
    const DirectoryBuyerRowStatusEnum._('DEACTIVATED');
const DirectoryBuyerRowStatusEnum _$directoryBuyerRowStatusEnum_DELETED =
    const DirectoryBuyerRowStatusEnum._('DELETED');

DirectoryBuyerRowStatusEnum _$directoryBuyerRowStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$directoryBuyerRowStatusEnum_ACTIVE;
    case 'PENDING_VERIFICATION':
      return _$directoryBuyerRowStatusEnum_PENDING_VERIFICATION;
    case 'SUSPENDED':
      return _$directoryBuyerRowStatusEnum_SUSPENDED;
    case 'DEACTIVATED':
      return _$directoryBuyerRowStatusEnum_DEACTIVATED;
    case 'DELETED':
      return _$directoryBuyerRowStatusEnum_DELETED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectoryBuyerRowStatusEnum>
    _$directoryBuyerRowStatusEnumValues =
    BuiltSet<DirectoryBuyerRowStatusEnum>(const <DirectoryBuyerRowStatusEnum>[
  _$directoryBuyerRowStatusEnum_ACTIVE,
  _$directoryBuyerRowStatusEnum_PENDING_VERIFICATION,
  _$directoryBuyerRowStatusEnum_SUSPENDED,
  _$directoryBuyerRowStatusEnum_DEACTIVATED,
  _$directoryBuyerRowStatusEnum_DELETED,
]);

const DirectoryBuyerRowBuyerTypeEnum
    _$directoryBuyerRowBuyerTypeEnum_INDIVIDUAL =
    const DirectoryBuyerRowBuyerTypeEnum._('INDIVIDUAL');
const DirectoryBuyerRowBuyerTypeEnum _$directoryBuyerRowBuyerTypeEnum_BUSINESS =
    const DirectoryBuyerRowBuyerTypeEnum._('BUSINESS');

DirectoryBuyerRowBuyerTypeEnum _$directoryBuyerRowBuyerTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'INDIVIDUAL':
      return _$directoryBuyerRowBuyerTypeEnum_INDIVIDUAL;
    case 'BUSINESS':
      return _$directoryBuyerRowBuyerTypeEnum_BUSINESS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectoryBuyerRowBuyerTypeEnum>
    _$directoryBuyerRowBuyerTypeEnumValues = BuiltSet<
        DirectoryBuyerRowBuyerTypeEnum>(const <DirectoryBuyerRowBuyerTypeEnum>[
  _$directoryBuyerRowBuyerTypeEnum_INDIVIDUAL,
  _$directoryBuyerRowBuyerTypeEnum_BUSINESS,
]);

Serializer<DirectoryBuyerRowStatusEnum>
    _$directoryBuyerRowStatusEnumSerializer =
    _$DirectoryBuyerRowStatusEnumSerializer();
Serializer<DirectoryBuyerRowBuyerTypeEnum>
    _$directoryBuyerRowBuyerTypeEnumSerializer =
    _$DirectoryBuyerRowBuyerTypeEnumSerializer();

class _$DirectoryBuyerRowStatusEnumSerializer
    implements PrimitiveSerializer<DirectoryBuyerRowStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'PENDING_VERIFICATION': 'PENDING_VERIFICATION',
    'SUSPENDED': 'SUSPENDED',
    'DEACTIVATED': 'DEACTIVATED',
    'DELETED': 'DELETED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'PENDING_VERIFICATION': 'PENDING_VERIFICATION',
    'SUSPENDED': 'SUSPENDED',
    'DEACTIVATED': 'DEACTIVATED',
    'DELETED': 'DELETED',
  };

  @override
  final Iterable<Type> types = const <Type>[DirectoryBuyerRowStatusEnum];
  @override
  final String wireName = 'DirectoryBuyerRowStatusEnum';

  @override
  Object serialize(Serializers serializers, DirectoryBuyerRowStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectoryBuyerRowStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectoryBuyerRowStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectoryBuyerRowBuyerTypeEnumSerializer
    implements PrimitiveSerializer<DirectoryBuyerRowBuyerTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INDIVIDUAL': 'INDIVIDUAL',
    'BUSINESS': 'BUSINESS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INDIVIDUAL': 'INDIVIDUAL',
    'BUSINESS': 'BUSINESS',
  };

  @override
  final Iterable<Type> types = const <Type>[DirectoryBuyerRowBuyerTypeEnum];
  @override
  final String wireName = 'DirectoryBuyerRowBuyerTypeEnum';

  @override
  Object serialize(
          Serializers serializers, DirectoryBuyerRowBuyerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectoryBuyerRowBuyerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectoryBuyerRowBuyerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectoryBuyerRow extends DirectoryBuyerRow {
  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final DirectoryBuyerRowStatusEnum status;
  @override
  final DirectoryBuyerRowBuyerTypeEnum buyerType;
  @override
  final String? companyName;
  @override
  final DateTime joinedAt;
  @override
  final DateTime? lastActiveAt;

  factory _$DirectoryBuyerRow(
          [void Function(DirectoryBuyerRowBuilder)? updates]) =>
      (DirectoryBuyerRowBuilder()..update(updates))._build();

  _$DirectoryBuyerRow._(
      {required this.id,
      required this.name,
      required this.email,
      required this.status,
      required this.buyerType,
      this.companyName,
      required this.joinedAt,
      this.lastActiveAt})
      : super._();
  @override
  DirectoryBuyerRow rebuild(void Function(DirectoryBuyerRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryBuyerRowBuilder toBuilder() =>
      DirectoryBuyerRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryBuyerRow &&
        id == other.id &&
        name == other.name &&
        email == other.email &&
        status == other.status &&
        buyerType == other.buyerType &&
        companyName == other.companyName &&
        joinedAt == other.joinedAt &&
        lastActiveAt == other.lastActiveAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, buyerType.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, joinedAt.hashCode);
    _$hash = $jc(_$hash, lastActiveAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryBuyerRow')
          ..add('id', id)
          ..add('name', name)
          ..add('email', email)
          ..add('status', status)
          ..add('buyerType', buyerType)
          ..add('companyName', companyName)
          ..add('joinedAt', joinedAt)
          ..add('lastActiveAt', lastActiveAt))
        .toString();
  }
}

class DirectoryBuyerRowBuilder
    implements Builder<DirectoryBuyerRow, DirectoryBuyerRowBuilder> {
  _$DirectoryBuyerRow? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  DirectoryBuyerRowStatusEnum? _status;
  DirectoryBuyerRowStatusEnum? get status => _$this._status;
  set status(DirectoryBuyerRowStatusEnum? status) => _$this._status = status;

  DirectoryBuyerRowBuyerTypeEnum? _buyerType;
  DirectoryBuyerRowBuyerTypeEnum? get buyerType => _$this._buyerType;
  set buyerType(DirectoryBuyerRowBuyerTypeEnum? buyerType) =>
      _$this._buyerType = buyerType;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  DateTime? _joinedAt;
  DateTime? get joinedAt => _$this._joinedAt;
  set joinedAt(DateTime? joinedAt) => _$this._joinedAt = joinedAt;

  DateTime? _lastActiveAt;
  DateTime? get lastActiveAt => _$this._lastActiveAt;
  set lastActiveAt(DateTime? lastActiveAt) =>
      _$this._lastActiveAt = lastActiveAt;

  DirectoryBuyerRowBuilder() {
    DirectoryBuyerRow._defaults(this);
  }

  DirectoryBuyerRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _email = $v.email;
      _status = $v.status;
      _buyerType = $v.buyerType;
      _companyName = $v.companyName;
      _joinedAt = $v.joinedAt;
      _lastActiveAt = $v.lastActiveAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryBuyerRow other) {
    _$v = other as _$DirectoryBuyerRow;
  }

  @override
  void update(void Function(DirectoryBuyerRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryBuyerRow build() => _build();

  _$DirectoryBuyerRow _build() {
    final _$result = _$v ??
        _$DirectoryBuyerRow._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'DirectoryBuyerRow', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'DirectoryBuyerRow', 'name'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'DirectoryBuyerRow', 'email'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'DirectoryBuyerRow', 'status'),
          buyerType: BuiltValueNullFieldError.checkNotNull(
              buyerType, r'DirectoryBuyerRow', 'buyerType'),
          companyName: companyName,
          joinedAt: BuiltValueNullFieldError.checkNotNull(
              joinedAt, r'DirectoryBuyerRow', 'joinedAt'),
          lastActiveAt: lastActiveAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
