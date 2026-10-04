// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_list_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InvoiceListMeta extends InvoiceListMeta {
  @override
  final String? view;
  @override
  final BuiltMap<String, int>? counts;
  @override
  final int? page;
  @override
  final int? perPage;
  @override
  final int? total;
  @override
  final bool? hasMore;
  @override
  final bool? canUpload;
  @override
  final String? issuanceNotice;
  @override
  final String? notice;

  factory _$InvoiceListMeta([void Function(InvoiceListMetaBuilder)? updates]) =>
      (InvoiceListMetaBuilder()..update(updates))._build();

  _$InvoiceListMeta._(
      {this.view,
      this.counts,
      this.page,
      this.perPage,
      this.total,
      this.hasMore,
      this.canUpload,
      this.issuanceNotice,
      this.notice})
      : super._();
  @override
  InvoiceListMeta rebuild(void Function(InvoiceListMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoiceListMetaBuilder toBuilder() => InvoiceListMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoiceListMeta &&
        view == other.view &&
        counts == other.counts &&
        page == other.page &&
        perPage == other.perPage &&
        total == other.total &&
        hasMore == other.hasMore &&
        canUpload == other.canUpload &&
        issuanceNotice == other.issuanceNotice &&
        notice == other.notice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, view.hashCode);
    _$hash = $jc(_$hash, counts.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jc(_$hash, canUpload.hashCode);
    _$hash = $jc(_$hash, issuanceNotice.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvoiceListMeta')
          ..add('view', view)
          ..add('counts', counts)
          ..add('page', page)
          ..add('perPage', perPage)
          ..add('total', total)
          ..add('hasMore', hasMore)
          ..add('canUpload', canUpload)
          ..add('issuanceNotice', issuanceNotice)
          ..add('notice', notice))
        .toString();
  }
}

class InvoiceListMetaBuilder
    implements Builder<InvoiceListMeta, InvoiceListMetaBuilder> {
  _$InvoiceListMeta? _$v;

  String? _view;
  String? get view => _$this._view;
  set view(String? view) => _$this._view = view;

  MapBuilder<String, int>? _counts;
  MapBuilder<String, int> get counts =>
      _$this._counts ??= MapBuilder<String, int>();
  set counts(MapBuilder<String, int>? counts) => _$this._counts = counts;

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

  bool? _canUpload;
  bool? get canUpload => _$this._canUpload;
  set canUpload(bool? canUpload) => _$this._canUpload = canUpload;

  String? _issuanceNotice;
  String? get issuanceNotice => _$this._issuanceNotice;
  set issuanceNotice(String? issuanceNotice) =>
      _$this._issuanceNotice = issuanceNotice;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  InvoiceListMetaBuilder() {
    InvoiceListMeta._defaults(this);
  }

  InvoiceListMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _view = $v.view;
      _counts = $v.counts?.toBuilder();
      _page = $v.page;
      _perPage = $v.perPage;
      _total = $v.total;
      _hasMore = $v.hasMore;
      _canUpload = $v.canUpload;
      _issuanceNotice = $v.issuanceNotice;
      _notice = $v.notice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvoiceListMeta other) {
    _$v = other as _$InvoiceListMeta;
  }

  @override
  void update(void Function(InvoiceListMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoiceListMeta build() => _build();

  _$InvoiceListMeta _build() {
    _$InvoiceListMeta _$result;
    try {
      _$result = _$v ??
          _$InvoiceListMeta._(
            view: view,
            counts: _counts?.build(),
            page: page,
            perPage: perPage,
            total: total,
            hasMore: hasMore,
            canUpload: canUpload,
            issuanceNotice: issuanceNotice,
            notice: notice,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'counts';
        _counts?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InvoiceListMeta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
