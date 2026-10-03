// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_identity.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatIdentity extends ChatIdentity {
  @override
  final String displayName;
  @override
  final String role;
  @override
  final String? avatarPath;

  factory _$ChatIdentity([void Function(ChatIdentityBuilder)? updates]) =>
      (ChatIdentityBuilder()..update(updates))._build();

  _$ChatIdentity._(
      {required this.displayName, required this.role, this.avatarPath})
      : super._();
  @override
  ChatIdentity rebuild(void Function(ChatIdentityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatIdentityBuilder toBuilder() => ChatIdentityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatIdentity &&
        displayName == other.displayName &&
        role == other.role &&
        avatarPath == other.avatarPath;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, avatarPath.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatIdentity')
          ..add('displayName', displayName)
          ..add('role', role)
          ..add('avatarPath', avatarPath))
        .toString();
  }
}

class ChatIdentityBuilder
    implements Builder<ChatIdentity, ChatIdentityBuilder> {
  _$ChatIdentity? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  String? _avatarPath;
  String? get avatarPath => _$this._avatarPath;
  set avatarPath(String? avatarPath) => _$this._avatarPath = avatarPath;

  ChatIdentityBuilder() {
    ChatIdentity._defaults(this);
  }

  ChatIdentityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _role = $v.role;
      _avatarPath = $v.avatarPath;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatIdentity other) {
    _$v = other as _$ChatIdentity;
  }

  @override
  void update(void Function(ChatIdentityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatIdentity build() => _build();

  _$ChatIdentity _build() {
    final _$result = _$v ??
        _$ChatIdentity._(
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'ChatIdentity', 'displayName'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'ChatIdentity', 'role'),
          avatarPath: avatarPath,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
