// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectPage extends ProjectPage {
  @override
  final BuiltList<ProjectSummary> items;
  @override
  final int page;
  @override
  final bool hasMore;

  factory _$ProjectPage([void Function(ProjectPageBuilder)? updates]) =>
      (ProjectPageBuilder()..update(updates))._build();

  _$ProjectPage._(
      {required this.items, required this.page, required this.hasMore})
      : super._();
  @override
  ProjectPage rebuild(void Function(ProjectPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectPageBuilder toBuilder() => ProjectPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectPage &&
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
    return (newBuiltValueToStringHelper(r'ProjectPage')
          ..add('items', items)
          ..add('page', page)
          ..add('hasMore', hasMore))
        .toString();
  }
}

class ProjectPageBuilder implements Builder<ProjectPage, ProjectPageBuilder> {
  _$ProjectPage? _$v;

  ListBuilder<ProjectSummary>? _items;
  ListBuilder<ProjectSummary> get items =>
      _$this._items ??= ListBuilder<ProjectSummary>();
  set items(ListBuilder<ProjectSummary>? items) => _$this._items = items;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  ProjectPageBuilder() {
    ProjectPage._defaults(this);
  }

  ProjectPageBuilder get _$this {
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
  void replace(ProjectPage other) {
    _$v = other as _$ProjectPage;
  }

  @override
  void update(void Function(ProjectPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectPage build() => _build();

  _$ProjectPage _build() {
    _$ProjectPage _$result;
    try {
      _$result = _$v ??
          _$ProjectPage._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'ProjectPage', 'page'),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'ProjectPage', 'hasMore'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
