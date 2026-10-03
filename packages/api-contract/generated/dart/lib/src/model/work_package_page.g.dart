// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkPackagePage extends WorkPackagePage {
  @override
  final BuiltList<WorkPackageSummary> items;
  @override
  final int page;
  @override
  final bool hasMore;

  factory _$WorkPackagePage([void Function(WorkPackagePageBuilder)? updates]) =>
      (WorkPackagePageBuilder()..update(updates))._build();

  _$WorkPackagePage._(
      {required this.items, required this.page, required this.hasMore})
      : super._();
  @override
  WorkPackagePage rebuild(void Function(WorkPackagePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkPackagePageBuilder toBuilder() => WorkPackagePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkPackagePage &&
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
    return (newBuiltValueToStringHelper(r'WorkPackagePage')
          ..add('items', items)
          ..add('page', page)
          ..add('hasMore', hasMore))
        .toString();
  }
}

class WorkPackagePageBuilder
    implements Builder<WorkPackagePage, WorkPackagePageBuilder> {
  _$WorkPackagePage? _$v;

  ListBuilder<WorkPackageSummary>? _items;
  ListBuilder<WorkPackageSummary> get items =>
      _$this._items ??= ListBuilder<WorkPackageSummary>();
  set items(ListBuilder<WorkPackageSummary>? items) => _$this._items = items;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  WorkPackagePageBuilder() {
    WorkPackagePage._defaults(this);
  }

  WorkPackagePageBuilder get _$this {
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
  void replace(WorkPackagePage other) {
    _$v = other as _$WorkPackagePage;
  }

  @override
  void update(void Function(WorkPackagePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkPackagePage build() => _build();

  _$WorkPackagePage _build() {
    _$WorkPackagePage _$result;
    try {
      _$result = _$v ??
          _$WorkPackagePage._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'WorkPackagePage', 'page'),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'WorkPackagePage', 'hasMore'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkPackagePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
