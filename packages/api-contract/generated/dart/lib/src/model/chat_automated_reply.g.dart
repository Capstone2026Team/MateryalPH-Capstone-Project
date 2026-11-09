// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_automated_reply.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatAutomatedReply extends ChatAutomatedReply {
  @override
  final BuiltList<ChatAutomatedOption> options;

  factory _$ChatAutomatedReply(
          [void Function(ChatAutomatedReplyBuilder)? updates]) =>
      (ChatAutomatedReplyBuilder()..update(updates))._build();

  _$ChatAutomatedReply._({required this.options}) : super._();
  @override
  ChatAutomatedReply rebuild(
          void Function(ChatAutomatedReplyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatAutomatedReplyBuilder toBuilder() =>
      ChatAutomatedReplyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatAutomatedReply && options == other.options;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatAutomatedReply')
          ..add('options', options))
        .toString();
  }
}

class ChatAutomatedReplyBuilder
    implements Builder<ChatAutomatedReply, ChatAutomatedReplyBuilder> {
  _$ChatAutomatedReply? _$v;

  ListBuilder<ChatAutomatedOption>? _options;
  ListBuilder<ChatAutomatedOption> get options =>
      _$this._options ??= ListBuilder<ChatAutomatedOption>();
  set options(ListBuilder<ChatAutomatedOption>? options) =>
      _$this._options = options;

  ChatAutomatedReplyBuilder() {
    ChatAutomatedReply._defaults(this);
  }

  ChatAutomatedReplyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _options = $v.options.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatAutomatedReply other) {
    _$v = other as _$ChatAutomatedReply;
  }

  @override
  void update(void Function(ChatAutomatedReplyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatAutomatedReply build() => _build();

  _$ChatAutomatedReply _build() {
    _$ChatAutomatedReply _$result;
    try {
      _$result = _$v ??
          _$ChatAutomatedReply._(
            options: options.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        options.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatAutomatedReply', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
