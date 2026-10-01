// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatMessagePage extends ChatMessagePage {
  @override
  final BuiltList<ChatMessage> items;
  @override
  final bool hasMore;
  @override
  final String? nextBefore;

  factory _$ChatMessagePage([void Function(ChatMessagePageBuilder)? updates]) =>
      (ChatMessagePageBuilder()..update(updates))._build();

  _$ChatMessagePage._(
      {required this.items, required this.hasMore, this.nextBefore})
      : super._();
  @override
  ChatMessagePage rebuild(void Function(ChatMessagePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatMessagePageBuilder toBuilder() => ChatMessagePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatMessagePage &&
        items == other.items &&
        hasMore == other.hasMore &&
        nextBefore == other.nextBefore;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jc(_$hash, nextBefore.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatMessagePage')
          ..add('items', items)
          ..add('hasMore', hasMore)
          ..add('nextBefore', nextBefore))
        .toString();
  }
}

class ChatMessagePageBuilder
    implements Builder<ChatMessagePage, ChatMessagePageBuilder> {
  _$ChatMessagePage? _$v;

  ListBuilder<ChatMessage>? _items;
  ListBuilder<ChatMessage> get items =>
      _$this._items ??= ListBuilder<ChatMessage>();
  set items(ListBuilder<ChatMessage>? items) => _$this._items = items;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  String? _nextBefore;
  String? get nextBefore => _$this._nextBefore;
  set nextBefore(String? nextBefore) => _$this._nextBefore = nextBefore;

  ChatMessagePageBuilder() {
    ChatMessagePage._defaults(this);
  }

  ChatMessagePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _hasMore = $v.hasMore;
      _nextBefore = $v.nextBefore;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatMessagePage other) {
    _$v = other as _$ChatMessagePage;
  }

  @override
  void update(void Function(ChatMessagePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatMessagePage build() => _build();

  _$ChatMessagePage _build() {
    _$ChatMessagePage _$result;
    try {
      _$result = _$v ??
          _$ChatMessagePage._(
            items: items.build(),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'ChatMessagePage', 'hasMore'),
            nextBefore: nextBefore,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatMessagePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
