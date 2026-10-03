// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_read.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatRead extends ChatRead {
  @override
  final String throughMessageId;

  factory _$ChatRead([void Function(ChatReadBuilder)? updates]) =>
      (ChatReadBuilder()..update(updates))._build();

  _$ChatRead._({required this.throughMessageId}) : super._();
  @override
  ChatRead rebuild(void Function(ChatReadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatReadBuilder toBuilder() => ChatReadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatRead && throughMessageId == other.throughMessageId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, throughMessageId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatRead')
          ..add('throughMessageId', throughMessageId))
        .toString();
  }
}

class ChatReadBuilder implements Builder<ChatRead, ChatReadBuilder> {
  _$ChatRead? _$v;

  String? _throughMessageId;
  String? get throughMessageId => _$this._throughMessageId;
  set throughMessageId(String? throughMessageId) =>
      _$this._throughMessageId = throughMessageId;

  ChatReadBuilder() {
    ChatRead._defaults(this);
  }

  ChatReadBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _throughMessageId = $v.throughMessageId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatRead other) {
    _$v = other as _$ChatRead;
  }

  @override
  void update(void Function(ChatReadBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatRead build() => _build();

  _$ChatRead _build() {
    final _$result = _$v ??
        _$ChatRead._(
          throughMessageId: BuiltValueNullFieldError.checkNotNull(
              throughMessageId, r'ChatRead', 'throughMessageId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
