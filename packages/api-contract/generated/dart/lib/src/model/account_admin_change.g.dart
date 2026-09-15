// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_admin_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AccountAdminChangeStatusEnum _$accountAdminChangeStatusEnum_ACTIVE =
    const AccountAdminChangeStatusEnum._('ACTIVE');
const AccountAdminChangeStatusEnum _$accountAdminChangeStatusEnum_SUSPENDED =
    const AccountAdminChangeStatusEnum._('SUSPENDED');
const AccountAdminChangeStatusEnum _$accountAdminChangeStatusEnum_DEACTIVATED =
    const AccountAdminChangeStatusEnum._('DEACTIVATED');

AccountAdminChangeStatusEnum _$accountAdminChangeStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ACTIVE':
      return _$accountAdminChangeStatusEnum_ACTIVE;
    case 'SUSPENDED':
      return _$accountAdminChangeStatusEnum_SUSPENDED;
    case 'DEACTIVATED':
      return _$accountAdminChangeStatusEnum_DEACTIVATED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AccountAdminChangeStatusEnum>
    _$accountAdminChangeStatusEnumValues =
    BuiltSet<AccountAdminChangeStatusEnum>(const <AccountAdminChangeStatusEnum>[
  _$accountAdminChangeStatusEnum_ACTIVE,
  _$accountAdminChangeStatusEnum_SUSPENDED,
  _$accountAdminChangeStatusEnum_DEACTIVATED,
]);

Serializer<AccountAdminChangeStatusEnum>
    _$accountAdminChangeStatusEnumSerializer =
    _$AccountAdminChangeStatusEnumSerializer();

class _$AccountAdminChangeStatusEnumSerializer
    implements PrimitiveSerializer<AccountAdminChangeStatusEnum> {
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
  final Iterable<Type> types = const <Type>[AccountAdminChangeStatusEnum];
  @override
  final String wireName = 'AccountAdminChangeStatusEnum';

  @override
  Object serialize(Serializers serializers, AccountAdminChangeStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AccountAdminChangeStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AccountAdminChangeStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AccountAdminChange extends AccountAdminChange {
  @override
  final int lockVersion;
  @override
  final String reason;
  @override
  final AccountAdminChangeStatusEnum? status;
  @override
  final String? roleId;

  factory _$AccountAdminChange(
          [void Function(AccountAdminChangeBuilder)? updates]) =>
      (AccountAdminChangeBuilder()..update(updates))._build();

  _$AccountAdminChange._(
      {required this.lockVersion,
      required this.reason,
      this.status,
      this.roleId})
      : super._();
  @override
  AccountAdminChange rebuild(
          void Function(AccountAdminChangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountAdminChangeBuilder toBuilder() =>
      AccountAdminChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountAdminChange &&
        lockVersion == other.lockVersion &&
        reason == other.reason &&
        status == other.status &&
        roleId == other.roleId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, roleId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountAdminChange')
          ..add('lockVersion', lockVersion)
          ..add('reason', reason)
          ..add('status', status)
          ..add('roleId', roleId))
        .toString();
  }
}

class AccountAdminChangeBuilder
    implements Builder<AccountAdminChange, AccountAdminChangeBuilder> {
  _$AccountAdminChange? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AccountAdminChangeStatusEnum? _status;
  AccountAdminChangeStatusEnum? get status => _$this._status;
  set status(AccountAdminChangeStatusEnum? status) => _$this._status = status;

  String? _roleId;
  String? get roleId => _$this._roleId;
  set roleId(String? roleId) => _$this._roleId = roleId;

  AccountAdminChangeBuilder() {
    AccountAdminChange._defaults(this);
  }

  AccountAdminChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _reason = $v.reason;
      _status = $v.status;
      _roleId = $v.roleId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountAdminChange other) {
    _$v = other as _$AccountAdminChange;
  }

  @override
  void update(void Function(AccountAdminChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountAdminChange build() => _build();

  _$AccountAdminChange _build() {
    final _$result = _$v ??
        _$AccountAdminChange._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'AccountAdminChange', 'lockVersion'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'AccountAdminChange', 'reason'),
          status: status,
          roleId: roleId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
