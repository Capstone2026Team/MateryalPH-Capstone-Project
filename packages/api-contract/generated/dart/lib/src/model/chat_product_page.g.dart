// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_product_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatProductPage extends ChatProductPage {
  @override
  final BuiltList<ChatProduct> items;
  @override
  final int page;
  @override
  final bool hasMore;

  factory _$ChatProductPage([void Function(ChatProductPageBuilder)? updates]) =>
      (ChatProductPageBuilder()..update(updates))._build();

  _$ChatProductPage._(
      {required this.items, required this.page, required this.hasMore})
      : super._();
  @override
  ChatProductPage rebuild(void Function(ChatProductPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatProductPageBuilder toBuilder() => ChatProductPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatProductPage &&
        items == other.items &&
        page == other.page &&
        hasMore == other.hasMore;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatProductPage')
          ..add('items', items)
          ..add('page', page)
          ..add('hasMore', hasMore))
        .toString();
  }
}

class ChatProductPageBuilder
    implements Builder<ChatProductPage, ChatProductPageBuilder> {
  _$ChatProductPage? _$v;

  ListBuilder<ChatProduct>? _items;
  ListBuilder<ChatProduct> get items =>
      _$this._items ??= ListBuilder<ChatProduct>();
  set items(ListBuilder<ChatProduct>? items) => _$this._items = items;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  ChatProductPageBuilder() {
    ChatProductPage._defaults(this);
  }

  ChatProductPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _page = $v.page;
      _hasMore = $v.hasMore;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatProductPage other) {
    _$v = other as _$ChatProductPage;
  }

  @override
  void update(void Function(ChatProductPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatProductPage build() => _build();

  _$ChatProductPage _build() {
    _$ChatProductPage _$result;
    try {
      _$result = _$v ??
          _$ChatProductPage._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'ChatProductPage', 'page'),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'ChatProductPage', 'hasMore'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatProductPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
