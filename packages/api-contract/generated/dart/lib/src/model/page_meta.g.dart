// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PageMeta extends PageMeta {
  @override
  final int currentPage;
  @override
  final int lastPage;
  @override
  final int total;

  factory _$PageMeta([void Function(PageMetaBuilder)? updates]) =>
      (PageMetaBuilder()..update(updates))._build();

  _$PageMeta._(
      {required this.currentPage, required this.lastPage, required this.total})
      : super._();
  @override
  PageMeta rebuild(void Function(PageMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PageMetaBuilder toBuilder() => PageMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PageMeta &&
        currentPage == other.currentPage &&
        lastPage == other.lastPage &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentPage.hashCode);
    _$hash = $jc(_$hash, lastPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PageMeta')
          ..add('currentPage', currentPage)
          ..add('lastPage', lastPage)
          ..add('total', total))
        .toString();
  }
}

class PageMetaBuilder implements Builder<PageMeta, PageMetaBuilder> {
  _$PageMeta? _$v;

  int? _currentPage;
  int? get currentPage => _$this._currentPage;
  set currentPage(int? currentPage) => _$this._currentPage = currentPage;

  int? _lastPage;
  int? get lastPage => _$this._lastPage;
  set lastPage(int? lastPage) => _$this._lastPage = lastPage;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  PageMetaBuilder() {
    PageMeta._defaults(this);
  }

  PageMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentPage = $v.currentPage;
      _lastPage = $v.lastPage;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PageMeta other) {
    _$v = other as _$PageMeta;
  }

  @override
  void update(void Function(PageMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PageMeta build() => _build();

  _$PageMeta _build() {
    final _$result = _$v ??
        _$PageMeta._(
          currentPage: BuiltValueNullFieldError.checkNotNull(
              currentPage, r'PageMeta', 'currentPage'),
          lastPage: BuiltValueNullFieldError.checkNotNull(
              lastPage, r'PageMeta', 'lastPage'),
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'PageMeta', 'total'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
