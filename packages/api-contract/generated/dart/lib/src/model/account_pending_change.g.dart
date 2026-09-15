// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_pending_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountPendingChange extends AccountPendingChange {
  @override
  final String id;
  @override
  final String expiresAt;

  factory _$AccountPendingChange(
          [void Function(AccountPendingChangeBuilder)? updates]) =>
      (AccountPendingChangeBuilder()..update(updates))._build();

  _$AccountPendingChange._({required this.id, required this.expiresAt})
      : super._();
  @override
  AccountPendingChange rebuild(
          void Function(AccountPendingChangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountPendingChangeBuilder toBuilder() =>
      AccountPendingChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountPendingChange &&
        id == other.id &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountPendingChange')
          ..add('id', id)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class AccountPendingChangeBuilder
    implements Builder<AccountPendingChange, AccountPendingChangeBuilder> {
  _$AccountPendingChange? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _expiresAt;
  String? get expiresAt => _$this._expiresAt;
  set expiresAt(String? expiresAt) => _$this._expiresAt = expiresAt;

  AccountPendingChangeBuilder() {
    AccountPendingChange._defaults(this);
  }

  AccountPendingChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountPendingChange other) {
    _$v = other as _$AccountPendingChange;
  }

  @override
  void update(void Function(AccountPendingChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountPendingChange build() => _build();

  _$AccountPendingChange _build() {
    final _$result = _$v ??
        _$AccountPendingChange._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AccountPendingChange', 'id'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'AccountPendingChange', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
