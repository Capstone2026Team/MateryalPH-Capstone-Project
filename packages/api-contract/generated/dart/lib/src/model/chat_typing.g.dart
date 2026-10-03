// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_typing.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatTyping extends ChatTyping {
  @override
  final bool typing;

  factory _$ChatTyping([void Function(ChatTypingBuilder)? updates]) =>
      (ChatTypingBuilder()..update(updates))._build();

  _$ChatTyping._({required this.typing}) : super._();
  @override
  ChatTyping rebuild(void Function(ChatTypingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatTypingBuilder toBuilder() => ChatTypingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatTyping && typing == other.typing;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, typing.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatTyping')..add('typing', typing))
        .toString();
  }
}

class ChatTypingBuilder implements Builder<ChatTyping, ChatTypingBuilder> {
  _$ChatTyping? _$v;

  bool? _typing;
  bool? get typing => _$this._typing;
  set typing(bool? typing) => _$this._typing = typing;

  ChatTypingBuilder() {
    ChatTyping._defaults(this);
  }

  ChatTypingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _typing = $v.typing;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatTyping other) {
    _$v = other as _$ChatTyping;
  }

  @override
  void update(void Function(ChatTypingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatTyping build() => _build();

  _$ChatTyping _build() {
    final _$result = _$v ??
        _$ChatTyping._(
          typing: BuiltValueNullFieldError.checkNotNull(
              typing, r'ChatTyping', 'typing'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
