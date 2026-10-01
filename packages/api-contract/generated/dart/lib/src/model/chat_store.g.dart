// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatStore extends ChatStore {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? logoUrl;
  @override
  final bool verified;

  factory _$ChatStore([void Function(ChatStoreBuilder)? updates]) =>
      (ChatStoreBuilder()..update(updates))._build();

  _$ChatStore._(
      {required this.id,
      required this.name,
      this.logoUrl,
      required this.verified})
      : super._();
  @override
  ChatStore rebuild(void Function(ChatStoreBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatStoreBuilder toBuilder() => ChatStoreBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatStore &&
        id == other.id &&
        name == other.name &&
        logoUrl == other.logoUrl &&
        verified == other.verified;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, verified.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatStore')
          ..add('id', id)
          ..add('name', name)
          ..add('logoUrl', logoUrl)
          ..add('verified', verified))
        .toString();
  }
}

class ChatStoreBuilder implements Builder<ChatStore, ChatStoreBuilder> {
  _$ChatStore? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

  bool? _verified;
  bool? get verified => _$this._verified;
  set verified(bool? verified) => _$this._verified = verified;

  ChatStoreBuilder() {
    ChatStore._defaults(this);
  }

  ChatStoreBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _logoUrl = $v.logoUrl;
      _verified = $v.verified;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatStore other) {
    _$v = other as _$ChatStore;
  }

  @override
  void update(void Function(ChatStoreBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatStore build() => _build();

  _$ChatStore _build() {
    final _$result = _$v ??
        _$ChatStore._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ChatStore', 'id'),
          name:
              BuiltValueNullFieldError.checkNotNull(name, r'ChatStore', 'name'),
          logoUrl: logoUrl,
          verified: BuiltValueNullFieldError.checkNotNull(
              verified, r'ChatStore', 'verified'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
