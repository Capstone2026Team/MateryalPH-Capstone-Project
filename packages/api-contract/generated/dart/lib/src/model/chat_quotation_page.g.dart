// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_quotation_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatQuotationPage extends ChatQuotationPage {
  @override
  final ChatQuotation? quotation;
  @override
  final BuiltList<ChatQuotationVersion> versions;
  @override
  final bool hasMore;
  @override
  final int? page;

  factory _$ChatQuotationPage(
          [void Function(ChatQuotationPageBuilder)? updates]) =>
      (ChatQuotationPageBuilder()..update(updates))._build();

  _$ChatQuotationPage._(
      {this.quotation,
      required this.versions,
      required this.hasMore,
      this.page})
      : super._();
  @override
  ChatQuotationPage rebuild(void Function(ChatQuotationPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatQuotationPageBuilder toBuilder() =>
      ChatQuotationPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatQuotationPage &&
        quotation == other.quotation &&
        versions == other.versions &&
        hasMore == other.hasMore &&
        page == other.page;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, quotation.hashCode);
    _$hash = $jc(_$hash, versions.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatQuotationPage')
          ..add('quotation', quotation)
          ..add('versions', versions)
          ..add('hasMore', hasMore)
          ..add('page', page))
        .toString();
  }
}

class ChatQuotationPageBuilder
    implements Builder<ChatQuotationPage, ChatQuotationPageBuilder> {
  _$ChatQuotationPage? _$v;

  ChatQuotationBuilder? _quotation;
  ChatQuotationBuilder get quotation =>
      _$this._quotation ??= ChatQuotationBuilder();
  set quotation(ChatQuotationBuilder? quotation) =>
      _$this._quotation = quotation;

  ListBuilder<ChatQuotationVersion>? _versions;
  ListBuilder<ChatQuotationVersion> get versions =>
      _$this._versions ??= ListBuilder<ChatQuotationVersion>();
  set versions(ListBuilder<ChatQuotationVersion>? versions) =>
      _$this._versions = versions;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  ChatQuotationPageBuilder() {
    ChatQuotationPage._defaults(this);
  }

  ChatQuotationPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _quotation = $v.quotation?.toBuilder();
      _versions = $v.versions.toBuilder();
      _hasMore = $v.hasMore;
      _page = $v.page;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatQuotationPage other) {
    _$v = other as _$ChatQuotationPage;
  }

  @override
  void update(void Function(ChatQuotationPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatQuotationPage build() => _build();

  _$ChatQuotationPage _build() {
    _$ChatQuotationPage _$result;
    try {
      _$result = _$v ??
          _$ChatQuotationPage._(
            quotation: _quotation?.build(),
            versions: versions.build(),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'ChatQuotationPage', 'hasMore'),
            page: page,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'quotation';
        _quotation?.build();
        _$failedField = 'versions';
        versions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatQuotationPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
