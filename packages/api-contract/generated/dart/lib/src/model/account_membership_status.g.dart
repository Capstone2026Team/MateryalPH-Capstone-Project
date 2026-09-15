// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_membership_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AccountMembershipStatusStatusEnum
    _$accountMembershipStatusStatusEnum_ACTIVE =
    const AccountMembershipStatusStatusEnum._('ACTIVE');
const AccountMembershipStatusStatusEnum
    _$accountMembershipStatusStatusEnum_SUSPENDED =
    const AccountMembershipStatusStatusEnum._('SUSPENDED');
const AccountMembershipStatusStatusEnum
    _$accountMembershipStatusStatusEnum_DEACTIVATED =
    const AccountMembershipStatusStatusEnum._('DEACTIVATED');

AccountMembershipStatusStatusEnum _$accountMembershipStatusStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ACTIVE':
      return _$accountMembershipStatusStatusEnum_ACTIVE;
    case 'SUSPENDED':
      return _$accountMembershipStatusStatusEnum_SUSPENDED;
    case 'DEACTIVATED':
      return _$accountMembershipStatusStatusEnum_DEACTIVATED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AccountMembershipStatusStatusEnum>
    _$accountMembershipStatusStatusEnumValues = BuiltSet<
        AccountMembershipStatusStatusEnum>(const <AccountMembershipStatusStatusEnum>[
  _$accountMembershipStatusStatusEnum_ACTIVE,
  _$accountMembershipStatusStatusEnum_SUSPENDED,
  _$accountMembershipStatusStatusEnum_DEACTIVATED,
]);

Serializer<AccountMembershipStatusStatusEnum>
    _$accountMembershipStatusStatusEnumSerializer =
    _$AccountMembershipStatusStatusEnumSerializer();

class _$AccountMembershipStatusStatusEnumSerializer
    implements PrimitiveSerializer<AccountMembershipStatusStatusEnum> {
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
  final Iterable<Type> types = const <Type>[AccountMembershipStatusStatusEnum];
  @override
  final String wireName = 'AccountMembershipStatusStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AccountMembershipStatusStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AccountMembershipStatusStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AccountMembershipStatusStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AccountMembershipStatus extends AccountMembershipStatus {
  @override
  final AccountMembershipStatusStatusEnum status;

  factory _$AccountMembershipStatus(
          [void Function(AccountMembershipStatusBuilder)? updates]) =>
      (AccountMembershipStatusBuilder()..update(updates))._build();

  _$AccountMembershipStatus._({required this.status}) : super._();
  @override
  AccountMembershipStatus rebuild(
          void Function(AccountMembershipStatusBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountMembershipStatusBuilder toBuilder() =>
      AccountMembershipStatusBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountMembershipStatus && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountMembershipStatus')
          ..add('status', status))
        .toString();
  }
}

class AccountMembershipStatusBuilder
    implements
        Builder<AccountMembershipStatus, AccountMembershipStatusBuilder> {
  _$AccountMembershipStatus? _$v;

  AccountMembershipStatusStatusEnum? _status;
  AccountMembershipStatusStatusEnum? get status => _$this._status;
  set status(AccountMembershipStatusStatusEnum? status) =>
      _$this._status = status;

  AccountMembershipStatusBuilder() {
    AccountMembershipStatus._defaults(this);
  }

  AccountMembershipStatusBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountMembershipStatus other) {
    _$v = other as _$AccountMembershipStatus;
  }

  @override
  void update(void Function(AccountMembershipStatusBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountMembershipStatus build() => _build();

  _$AccountMembershipStatus _build() {
    final _$result = _$v ??
        _$AccountMembershipStatus._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AccountMembershipStatus', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
