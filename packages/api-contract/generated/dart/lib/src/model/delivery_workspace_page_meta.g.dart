// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_workspace_page_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryWorkspacePageMeta extends DeliveryWorkspacePageMeta {
  @override
  final int page;
  @override
  final int perPage;
  @override
  final int total;
  @override
  final bool hasMore;

  factory _$DeliveryWorkspacePageMeta(
          [void Function(DeliveryWorkspacePageMetaBuilder)? updates]) =>
      (DeliveryWorkspacePageMetaBuilder()..update(updates))._build();

  _$DeliveryWorkspacePageMeta._(
      {required this.page,
      required this.perPage,
      required this.total,
      required this.hasMore})
      : super._();
  @override
  DeliveryWorkspacePageMeta rebuild(
          void Function(DeliveryWorkspacePageMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryWorkspacePageMetaBuilder toBuilder() =>
      DeliveryWorkspacePageMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryWorkspacePageMeta &&
        page == other.page &&
        perPage == other.perPage &&
        total == other.total &&
        hasMore == other.hasMore;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryWorkspacePageMeta')
          ..add('page', page)
          ..add('perPage', perPage)
          ..add('total', total)
          ..add('hasMore', hasMore))
        .toString();
  }
}

class DeliveryWorkspacePageMetaBuilder
    implements
        Builder<DeliveryWorkspacePageMeta, DeliveryWorkspacePageMetaBuilder> {
  _$DeliveryWorkspacePageMeta? _$v;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _perPage;
  int? get perPage => _$this._perPage;
  set perPage(int? perPage) => _$this._perPage = perPage;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  DeliveryWorkspacePageMetaBuilder() {
    DeliveryWorkspacePageMeta._defaults(this);
  }

  DeliveryWorkspacePageMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _page = $v.page;
      _perPage = $v.perPage;
      _total = $v.total;
      _hasMore = $v.hasMore;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryWorkspacePageMeta other) {
    _$v = other as _$DeliveryWorkspacePageMeta;
  }

  @override
  void update(void Function(DeliveryWorkspacePageMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryWorkspacePageMeta build() => _build();

  _$DeliveryWorkspacePageMeta _build() {
    final _$result = _$v ??
        _$DeliveryWorkspacePageMeta._(
          page: BuiltValueNullFieldError.checkNotNull(
              page, r'DeliveryWorkspacePageMeta', 'page'),
          perPage: BuiltValueNullFieldError.checkNotNull(
              perPage, r'DeliveryWorkspacePageMeta', 'perPage'),
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'DeliveryWorkspacePageMeta', 'total'),
          hasMore: BuiltValueNullFieldError.checkNotNull(
              hasMore, r'DeliveryWorkspacePageMeta', 'hasMore'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
