// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_delegation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountDelegation extends AccountDelegation {
  @override
  final bool canManageStaff;

  factory _$AccountDelegation(
          [void Function(AccountDelegationBuilder)? updates]) =>
      (AccountDelegationBuilder()..update(updates))._build();

  _$AccountDelegation._({required this.canManageStaff}) : super._();
  @override
  AccountDelegation rebuild(void Function(AccountDelegationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountDelegationBuilder toBuilder() =>
      AccountDelegationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountDelegation && canManageStaff == other.canManageStaff;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, canManageStaff.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountDelegation')
          ..add('canManageStaff', canManageStaff))
        .toString();
  }
}

class AccountDelegationBuilder
    implements Builder<AccountDelegation, AccountDelegationBuilder> {
  _$AccountDelegation? _$v;

  bool? _canManageStaff;
  bool? get canManageStaff => _$this._canManageStaff;
  set canManageStaff(bool? canManageStaff) =>
      _$this._canManageStaff = canManageStaff;

  AccountDelegationBuilder() {
    AccountDelegation._defaults(this);
  }

  AccountDelegationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _canManageStaff = $v.canManageStaff;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountDelegation other) {
    _$v = other as _$AccountDelegation;
  }

  @override
  void update(void Function(AccountDelegationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountDelegation build() => _build();

  _$AccountDelegation _build() {
    final _$result = _$v ??
        _$AccountDelegation._(
          canManageStaff: BuiltValueNullFieldError.checkNotNull(
              canManageStaff, r'AccountDelegation', 'canManageStaff'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
