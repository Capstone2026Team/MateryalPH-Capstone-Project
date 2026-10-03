// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConversationPage extends ConversationPage {
  @override
  final BuiltList<ConversationView> items;
  @override
  final int page;
  @override
  final bool hasMore;

  factory _$ConversationPage(
          [void Function(ConversationPageBuilder)? updates]) =>
      (ConversationPageBuilder()..update(updates))._build();

  _$ConversationPage._(
      {required this.items, required this.page, required this.hasMore})
      : super._();
  @override
  ConversationPage rebuild(void Function(ConversationPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConversationPageBuilder toBuilder() =>
      ConversationPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConversationPage &&
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
    return (newBuiltValueToStringHelper(r'ConversationPage')
          ..add('items', items)
          ..add('page', page)
          ..add('hasMore', hasMore))
        .toString();
  }
}

class ConversationPageBuilder
    implements Builder<ConversationPage, ConversationPageBuilder> {
  _$ConversationPage? _$v;

  ListBuilder<ConversationView>? _items;
  ListBuilder<ConversationView> get items =>
      _$this._items ??= ListBuilder<ConversationView>();
  set items(ListBuilder<ConversationView>? items) => _$this._items = items;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  ConversationPageBuilder() {
    ConversationPage._defaults(this);
  }

  ConversationPageBuilder get _$this {
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
  void replace(ConversationPage other) {
    _$v = other as _$ConversationPage;
  }

  @override
  void update(void Function(ConversationPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConversationPage build() => _build();

  _$ConversationPage _build() {
    _$ConversationPage _$result;
    try {
      _$result = _$v ??
          _$ConversationPage._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'ConversationPage', 'page'),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'ConversationPage', 'hasMore'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ConversationPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
