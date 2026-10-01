// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_channel_auth.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatChannelAuth extends ChatChannelAuth {
  @override
  final String socketId;
  @override
  final String channelName;

  factory _$ChatChannelAuth([void Function(ChatChannelAuthBuilder)? updates]) =>
      (ChatChannelAuthBuilder()..update(updates))._build();

  _$ChatChannelAuth._({required this.socketId, required this.channelName})
      : super._();
  @override
  ChatChannelAuth rebuild(void Function(ChatChannelAuthBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatChannelAuthBuilder toBuilder() => ChatChannelAuthBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatChannelAuth &&
        socketId == other.socketId &&
        channelName == other.channelName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, socketId.hashCode);
    _$hash = $jc(_$hash, channelName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatChannelAuth')
          ..add('socketId', socketId)
          ..add('channelName', channelName))
        .toString();
  }
}

class ChatChannelAuthBuilder
    implements Builder<ChatChannelAuth, ChatChannelAuthBuilder> {
  _$ChatChannelAuth? _$v;

  String? _socketId;
  String? get socketId => _$this._socketId;
  set socketId(String? socketId) => _$this._socketId = socketId;

  String? _channelName;
  String? get channelName => _$this._channelName;
  set channelName(String? channelName) => _$this._channelName = channelName;

  ChatChannelAuthBuilder() {
    ChatChannelAuth._defaults(this);
  }

  ChatChannelAuthBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _socketId = $v.socketId;
      _channelName = $v.channelName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatChannelAuth other) {
    _$v = other as _$ChatChannelAuth;
  }

  @override
  void update(void Function(ChatChannelAuthBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatChannelAuth build() => _build();

  _$ChatChannelAuth _build() {
    final _$result = _$v ??
        _$ChatChannelAuth._(
          socketId: BuiltValueNullFieldError.checkNotNull(
              socketId, r'ChatChannelAuth', 'socketId'),
          channelName: BuiltValueNullFieldError.checkNotNull(
              channelName, r'ChatChannelAuth', 'channelName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
