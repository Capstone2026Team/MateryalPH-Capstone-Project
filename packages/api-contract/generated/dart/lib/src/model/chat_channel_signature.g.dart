// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_channel_signature.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatChannelSignature extends ChatChannelSignature {
  @override
  final String auth;

  factory _$ChatChannelSignature(
          [void Function(ChatChannelSignatureBuilder)? updates]) =>
      (ChatChannelSignatureBuilder()..update(updates))._build();

  _$ChatChannelSignature._({required this.auth}) : super._();
  @override
  ChatChannelSignature rebuild(
          void Function(ChatChannelSignatureBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatChannelSignatureBuilder toBuilder() =>
      ChatChannelSignatureBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatChannelSignature && auth == other.auth;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, auth.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatChannelSignature')
          ..add('auth', auth))
        .toString();
  }
}

class ChatChannelSignatureBuilder
    implements Builder<ChatChannelSignature, ChatChannelSignatureBuilder> {
  _$ChatChannelSignature? _$v;

  String? _auth;
  String? get auth => _$this._auth;
  set auth(String? auth) => _$this._auth = auth;

  ChatChannelSignatureBuilder() {
    ChatChannelSignature._defaults(this);
  }

  ChatChannelSignatureBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _auth = $v.auth;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatChannelSignature other) {
    _$v = other as _$ChatChannelSignature;
  }

  @override
  void update(void Function(ChatChannelSignatureBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatChannelSignature build() => _build();

  _$ChatChannelSignature _build() {
    final _$result = _$v ??
        _$ChatChannelSignature._(
          auth: BuiltValueNullFieldError.checkNotNull(
              auth, r'ChatChannelSignature', 'auth'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
