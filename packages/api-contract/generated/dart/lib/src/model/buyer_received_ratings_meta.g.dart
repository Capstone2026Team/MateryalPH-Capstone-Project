// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_received_ratings_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerReceivedRatingsMeta extends BuyerReceivedRatingsMeta {
  @override
  final int page;
  @override
  final int perPage;
  @override
  final int total;
  @override
  final BuyerRatingSummary summary;

  factory _$BuyerReceivedRatingsMeta(
          [void Function(BuyerReceivedRatingsMetaBuilder)? updates]) =>
      (BuyerReceivedRatingsMetaBuilder()..update(updates))._build();

  _$BuyerReceivedRatingsMeta._(
      {required this.page,
      required this.perPage,
      required this.total,
      required this.summary})
      : super._();
  @override
  BuyerReceivedRatingsMeta rebuild(
          void Function(BuyerReceivedRatingsMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerReceivedRatingsMetaBuilder toBuilder() =>
      BuyerReceivedRatingsMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerReceivedRatingsMeta &&
        page == other.page &&
        perPage == other.perPage &&
        total == other.total &&
        summary == other.summary;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerReceivedRatingsMeta')
          ..add('page', page)
          ..add('perPage', perPage)
          ..add('total', total)
          ..add('summary', summary))
        .toString();
  }
}

class BuyerReceivedRatingsMetaBuilder
    implements
        Builder<BuyerReceivedRatingsMeta, BuyerReceivedRatingsMetaBuilder> {
  _$BuyerReceivedRatingsMeta? _$v;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _perPage;
  int? get perPage => _$this._perPage;
  set perPage(int? perPage) => _$this._perPage = perPage;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  BuyerRatingSummaryBuilder? _summary;
  BuyerRatingSummaryBuilder get summary =>
      _$this._summary ??= BuyerRatingSummaryBuilder();
  set summary(BuyerRatingSummaryBuilder? summary) => _$this._summary = summary;

  BuyerReceivedRatingsMetaBuilder() {
    BuyerReceivedRatingsMeta._defaults(this);
  }

  BuyerReceivedRatingsMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _page = $v.page;
      _perPage = $v.perPage;
      _total = $v.total;
      _summary = $v.summary.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerReceivedRatingsMeta other) {
    _$v = other as _$BuyerReceivedRatingsMeta;
  }

  @override
  void update(void Function(BuyerReceivedRatingsMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerReceivedRatingsMeta build() => _build();

  _$BuyerReceivedRatingsMeta _build() {
    _$BuyerReceivedRatingsMeta _$result;
    try {
      _$result = _$v ??
          _$BuyerReceivedRatingsMeta._(
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'BuyerReceivedRatingsMeta', 'page'),
            perPage: BuiltValueNullFieldError.checkNotNull(
                perPage, r'BuyerReceivedRatingsMeta', 'perPage'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'BuyerReceivedRatingsMeta', 'total'),
            summary: summary.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'summary';
        summary.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerReceivedRatingsMeta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
