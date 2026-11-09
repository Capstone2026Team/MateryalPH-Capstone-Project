// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_archive_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectArchivePage extends ProjectArchivePage {
  @override
  final BuiltList<ProjectArchiveItem> items;
  @override
  final int page;
  @override
  final bool hasMore;

  factory _$ProjectArchivePage(
          [void Function(ProjectArchivePageBuilder)? updates]) =>
      (ProjectArchivePageBuilder()..update(updates))._build();

  _$ProjectArchivePage._(
      {required this.items, required this.page, required this.hasMore})
      : super._();
  @override
  ProjectArchivePage rebuild(
          void Function(ProjectArchivePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectArchivePageBuilder toBuilder() =>
      ProjectArchivePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectArchivePage &&
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
    return (newBuiltValueToStringHelper(r'ProjectArchivePage')
          ..add('items', items)
          ..add('page', page)
          ..add('hasMore', hasMore))
        .toString();
  }
}

class ProjectArchivePageBuilder
    implements Builder<ProjectArchivePage, ProjectArchivePageBuilder> {
  _$ProjectArchivePage? _$v;

  ListBuilder<ProjectArchiveItem>? _items;
  ListBuilder<ProjectArchiveItem> get items =>
      _$this._items ??= ListBuilder<ProjectArchiveItem>();
  set items(ListBuilder<ProjectArchiveItem>? items) => _$this._items = items;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  ProjectArchivePageBuilder() {
    ProjectArchivePage._defaults(this);
  }

  ProjectArchivePageBuilder get _$this {
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
  void replace(ProjectArchivePage other) {
    _$v = other as _$ProjectArchivePage;
  }

  @override
  void update(void Function(ProjectArchivePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectArchivePage build() => _build();

  _$ProjectArchivePage _build() {
    _$ProjectArchivePage _$result;
    try {
      _$result = _$v ??
          _$ProjectArchivePage._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'ProjectArchivePage', 'page'),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'ProjectArchivePage', 'hasMore'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectArchivePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
