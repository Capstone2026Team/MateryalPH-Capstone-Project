// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_session.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountSession extends AccountSession {
  @override
  final String id;
  @override
  final String description;
  @override
  final bool current;
  @override
  final String? createdAt;
  @override
  final String? lastActiveAt;

  factory _$AccountSession([void Function(AccountSessionBuilder)? updates]) =>
      (AccountSessionBuilder()..update(updates))._build();

  _$AccountSession._(
      {required this.id,
      required this.description,
      required this.current,
      this.createdAt,
      this.lastActiveAt})
      : super._();
  @override
  AccountSession rebuild(void Function(AccountSessionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountSessionBuilder toBuilder() => AccountSessionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountSession &&
        id == other.id &&
        description == other.description &&
        current == other.current &&
        createdAt == other.createdAt &&
        lastActiveAt == other.lastActiveAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, current.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, lastActiveAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountSession')
          ..add('id', id)
          ..add('description', description)
          ..add('current', current)
          ..add('createdAt', createdAt)
          ..add('lastActiveAt', lastActiveAt))
        .toString();
  }
}

class AccountSessionBuilder
    implements Builder<AccountSession, AccountSessionBuilder> {
  _$AccountSession? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  bool? _current;
  bool? get current => _$this._current;
  set current(bool? current) => _$this._current = current;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _lastActiveAt;
  String? get lastActiveAt => _$this._lastActiveAt;
  set lastActiveAt(String? lastActiveAt) => _$this._lastActiveAt = lastActiveAt;

  AccountSessionBuilder() {
    AccountSession._defaults(this);
  }

  AccountSessionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _description = $v.description;
      _current = $v.current;
      _createdAt = $v.createdAt;
      _lastActiveAt = $v.lastActiveAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountSession other) {
    _$v = other as _$AccountSession;
  }

  @override
  void update(void Function(AccountSessionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountSession build() => _build();

  _$AccountSession _build() {
    final _$result = _$v ??
        _$AccountSession._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AccountSession', 'id'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'AccountSession', 'description'),
          current: BuiltValueNullFieldError.checkNotNull(
              current, r'AccountSession', 'current'),
          createdAt: createdAt,
          lastActiveAt: lastActiveAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
