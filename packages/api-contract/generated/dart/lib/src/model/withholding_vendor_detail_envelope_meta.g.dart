// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withholding_vendor_detail_envelope_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WithholdingVendorDetailEnvelopeMeta
    extends WithholdingVendorDetailEnvelopeMeta {
  @override
  final bool hasMore;
  @override
  final int total;
  @override
  final int page;

  factory _$WithholdingVendorDetailEnvelopeMeta(
          [void Function(WithholdingVendorDetailEnvelopeMetaBuilder)?
              updates]) =>
      (WithholdingVendorDetailEnvelopeMetaBuilder()..update(updates))._build();

  _$WithholdingVendorDetailEnvelopeMeta._(
      {required this.hasMore, required this.total, required this.page})
      : super._();
  @override
  WithholdingVendorDetailEnvelopeMeta rebuild(
          void Function(WithholdingVendorDetailEnvelopeMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WithholdingVendorDetailEnvelopeMetaBuilder toBuilder() =>
      WithholdingVendorDetailEnvelopeMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WithholdingVendorDetailEnvelopeMeta &&
        hasMore == other.hasMore &&
        total == other.total &&
        page == other.page;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WithholdingVendorDetailEnvelopeMeta')
          ..add('hasMore', hasMore)
          ..add('total', total)
          ..add('page', page))
        .toString();
  }
}

class WithholdingVendorDetailEnvelopeMetaBuilder
    implements
        Builder<WithholdingVendorDetailEnvelopeMeta,
            WithholdingVendorDetailEnvelopeMetaBuilder> {
  _$WithholdingVendorDetailEnvelopeMeta? _$v;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  WithholdingVendorDetailEnvelopeMetaBuilder() {
    WithholdingVendorDetailEnvelopeMeta._defaults(this);
  }

  WithholdingVendorDetailEnvelopeMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _hasMore = $v.hasMore;
      _total = $v.total;
      _page = $v.page;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WithholdingVendorDetailEnvelopeMeta other) {
    _$v = other as _$WithholdingVendorDetailEnvelopeMeta;
  }

  @override
  void update(
      void Function(WithholdingVendorDetailEnvelopeMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WithholdingVendorDetailEnvelopeMeta build() => _build();

  _$WithholdingVendorDetailEnvelopeMeta _build() {
    final _$result = _$v ??
        _$WithholdingVendorDetailEnvelopeMeta._(
          hasMore: BuiltValueNullFieldError.checkNotNull(
              hasMore, r'WithholdingVendorDetailEnvelopeMeta', 'hasMore'),
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'WithholdingVendorDetailEnvelopeMeta', 'total'),
          page: BuiltValueNullFieldError.checkNotNull(
              page, r'WithholdingVendorDetailEnvelopeMeta', 'page'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
