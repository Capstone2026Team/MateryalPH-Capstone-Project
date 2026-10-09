// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fulfillment_conversation_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FulfillmentConversationPage extends FulfillmentConversationPage {
  @override
  final BuiltList<FulfillmentConversationSummary> items;
  @override
  final int page;
  @override
  final bool hasMore;

  factory _$FulfillmentConversationPage(
          [void Function(FulfillmentConversationPageBuilder)? updates]) =>
      (FulfillmentConversationPageBuilder()..update(updates))._build();

  _$FulfillmentConversationPage._(
      {required this.items, required this.page, required this.hasMore})
      : super._();
  @override
  FulfillmentConversationPage rebuild(
          void Function(FulfillmentConversationPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FulfillmentConversationPageBuilder toBuilder() =>
      FulfillmentConversationPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FulfillmentConversationPage &&
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
    return (newBuiltValueToStringHelper(r'FulfillmentConversationPage')
          ..add('items', items)
          ..add('page', page)
          ..add('hasMore', hasMore))
        .toString();
  }
}

class FulfillmentConversationPageBuilder
    implements
        Builder<FulfillmentConversationPage,
            FulfillmentConversationPageBuilder> {
  _$FulfillmentConversationPage? _$v;

  ListBuilder<FulfillmentConversationSummary>? _items;
  ListBuilder<FulfillmentConversationSummary> get items =>
      _$this._items ??= ListBuilder<FulfillmentConversationSummary>();
  set items(ListBuilder<FulfillmentConversationSummary>? items) =>
      _$this._items = items;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  FulfillmentConversationPageBuilder() {
    FulfillmentConversationPage._defaults(this);
  }

  FulfillmentConversationPageBuilder get _$this {
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
  void replace(FulfillmentConversationPage other) {
    _$v = other as _$FulfillmentConversationPage;
  }

  @override
  void update(void Function(FulfillmentConversationPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FulfillmentConversationPage build() => _build();

  _$FulfillmentConversationPage _build() {
    _$FulfillmentConversationPage _$result;
    try {
      _$result = _$v ??
          _$FulfillmentConversationPage._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'FulfillmentConversationPage', 'page'),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'FulfillmentConversationPage', 'hasMore'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FulfillmentConversationPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
