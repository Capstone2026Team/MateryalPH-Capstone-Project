// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_version_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkPackageVersionPage extends WorkPackageVersionPage {
  @override
  final BuiltList<WorkPackageVersion> items;
  @override
  final int page;
  @override
  final bool hasMore;

  factory _$WorkPackageVersionPage(
          [void Function(WorkPackageVersionPageBuilder)? updates]) =>
      (WorkPackageVersionPageBuilder()..update(updates))._build();

  _$WorkPackageVersionPage._(
      {required this.items, required this.page, required this.hasMore})
      : super._();
  @override
  WorkPackageVersionPage rebuild(
          void Function(WorkPackageVersionPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkPackageVersionPageBuilder toBuilder() =>
      WorkPackageVersionPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkPackageVersionPage &&
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
    return (newBuiltValueToStringHelper(r'WorkPackageVersionPage')
          ..add('items', items)
          ..add('page', page)
          ..add('hasMore', hasMore))
        .toString();
  }
}

class WorkPackageVersionPageBuilder
    implements Builder<WorkPackageVersionPage, WorkPackageVersionPageBuilder> {
  _$WorkPackageVersionPage? _$v;

  ListBuilder<WorkPackageVersion>? _items;
  ListBuilder<WorkPackageVersion> get items =>
      _$this._items ??= ListBuilder<WorkPackageVersion>();
  set items(ListBuilder<WorkPackageVersion>? items) => _$this._items = items;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  WorkPackageVersionPageBuilder() {
    WorkPackageVersionPage._defaults(this);
  }

  WorkPackageVersionPageBuilder get _$this {
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
  void replace(WorkPackageVersionPage other) {
    _$v = other as _$WorkPackageVersionPage;
  }

  @override
  void update(void Function(WorkPackageVersionPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkPackageVersionPage build() => _build();

  _$WorkPackageVersionPage _build() {
    _$WorkPackageVersionPage _$result;
    try {
      _$result = _$v ??
          _$WorkPackageVersionPage._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'WorkPackageVersionPage', 'page'),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'WorkPackageVersionPage', 'hasMore'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkPackageVersionPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
