// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_review_list_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorReviewListMeta extends VendorReviewListMeta {
  @override
  final int? page;
  @override
  final int? perPage;
  @override
  final int? total;
  @override
  final String? type;
  @override
  final ReviewSummary? summary;
  @override
  final String? correlationId;

  factory _$VendorReviewListMeta(
          [void Function(VendorReviewListMetaBuilder)? updates]) =>
      (VendorReviewListMetaBuilder()..update(updates))._build();

  _$VendorReviewListMeta._(
      {this.page,
      this.perPage,
      this.total,
      this.type,
      this.summary,
      this.correlationId})
      : super._();
  @override
  VendorReviewListMeta rebuild(
          void Function(VendorReviewListMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorReviewListMetaBuilder toBuilder() =>
      VendorReviewListMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorReviewListMeta &&
        page == other.page &&
        perPage == other.perPage &&
        total == other.total &&
        type == other.type &&
        summary == other.summary &&
        correlationId == other.correlationId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jc(_$hash, correlationId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorReviewListMeta')
          ..add('page', page)
          ..add('perPage', perPage)
          ..add('total', total)
          ..add('type', type)
          ..add('summary', summary)
          ..add('correlationId', correlationId))
        .toString();
  }
}

class VendorReviewListMetaBuilder
    implements Builder<VendorReviewListMeta, VendorReviewListMetaBuilder> {
  _$VendorReviewListMeta? _$v;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _perPage;
  int? get perPage => _$this._perPage;
  set perPage(int? perPage) => _$this._perPage = perPage;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  ReviewSummaryBuilder? _summary;
  ReviewSummaryBuilder get summary =>
      _$this._summary ??= ReviewSummaryBuilder();
  set summary(ReviewSummaryBuilder? summary) => _$this._summary = summary;

  String? _correlationId;
  String? get correlationId => _$this._correlationId;
  set correlationId(String? correlationId) =>
      _$this._correlationId = correlationId;

  VendorReviewListMetaBuilder() {
    VendorReviewListMeta._defaults(this);
  }

  VendorReviewListMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _page = $v.page;
      _perPage = $v.perPage;
      _total = $v.total;
      _type = $v.type;
      _summary = $v.summary?.toBuilder();
      _correlationId = $v.correlationId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorReviewListMeta other) {
    _$v = other as _$VendorReviewListMeta;
  }

  @override
  void update(void Function(VendorReviewListMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorReviewListMeta build() => _build();

  _$VendorReviewListMeta _build() {
    _$VendorReviewListMeta _$result;
    try {
      _$result = _$v ??
          _$VendorReviewListMeta._(
            page: page,
            perPage: perPage,
            total: total,
            type: type,
            summary: _summary?.build(),
            correlationId: correlationId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'summary';
        _summary?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorReviewListMeta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
