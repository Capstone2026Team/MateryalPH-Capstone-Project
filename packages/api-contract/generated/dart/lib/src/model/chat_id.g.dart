// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_id.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatId extends ChatId {
  @override
  final String id;
  @override
  final String? storeConversationId;

  factory _$ChatId([void Function(ChatIdBuilder)? updates]) =>
      (ChatIdBuilder()..update(updates))._build();

  _$ChatId._({required this.id, this.storeConversationId}) : super._();
  @override
  ChatId rebuild(void Function(ChatIdBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatIdBuilder toBuilder() => ChatIdBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatId &&
        id == other.id &&
        storeConversationId == other.storeConversationId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, storeConversationId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatId')
          ..add('id', id)
          ..add('storeConversationId', storeConversationId))
        .toString();
  }
}

class ChatIdBuilder implements Builder<ChatId, ChatIdBuilder> {
  _$ChatId? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _storeConversationId;
  String? get storeConversationId => _$this._storeConversationId;
  set storeConversationId(String? storeConversationId) =>
      _$this._storeConversationId = storeConversationId;

  ChatIdBuilder() {
    ChatId._defaults(this);
  }

  ChatIdBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _storeConversationId = $v.storeConversationId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatId other) {
    _$v = other as _$ChatId;
  }

  @override
  void update(void Function(ChatIdBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatId build() => _build();

  _$ChatId _build() {
    final _$result = _$v ??
        _$ChatId._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ChatId', 'id'),
          storeConversationId: storeConversationId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
