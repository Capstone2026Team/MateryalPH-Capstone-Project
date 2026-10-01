// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_send.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatSend extends ChatSend {
  @override
  final String clientMessageId;
  @override
  final String body;

  factory _$ChatSend([void Function(ChatSendBuilder)? updates]) =>
      (ChatSendBuilder()..update(updates))._build();

  _$ChatSend._({required this.clientMessageId, required this.body}) : super._();
  @override
  ChatSend rebuild(void Function(ChatSendBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatSendBuilder toBuilder() => ChatSendBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatSend &&
        clientMessageId == other.clientMessageId &&
        body == other.body;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientMessageId.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatSend')
          ..add('clientMessageId', clientMessageId)
          ..add('body', body))
        .toString();
  }
}

class ChatSendBuilder implements Builder<ChatSend, ChatSendBuilder> {
  _$ChatSend? _$v;

  String? _clientMessageId;
  String? get clientMessageId => _$this._clientMessageId;
  set clientMessageId(String? clientMessageId) =>
      _$this._clientMessageId = clientMessageId;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  ChatSendBuilder() {
    ChatSend._defaults(this);
  }

  ChatSendBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientMessageId = $v.clientMessageId;
      _body = $v.body;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatSend other) {
    _$v = other as _$ChatSend;
  }

  @override
  void update(void Function(ChatSendBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatSend build() => _build();

  _$ChatSend _build() {
    final _$result = _$v ??
        _$ChatSend._(
          clientMessageId: BuiltValueNullFieldError.checkNotNull(
              clientMessageId, r'ChatSend', 'clientMessageId'),
          body:
              BuiltValueNullFieldError.checkNotNull(body, r'ChatSend', 'body'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
