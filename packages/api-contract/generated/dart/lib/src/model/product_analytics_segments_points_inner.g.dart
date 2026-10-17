// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_analytics_segments_points_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductAnalyticsSegmentsPointsInner
    extends ProductAnalyticsSegmentsPointsInner {
  @override
  final String listingId;
  @override
  final String name;
  @override
  final int views;
  @override
  final num conversionPercent;
  @override
  final int orders;
  @override
  final String segment;

  factory _$ProductAnalyticsSegmentsPointsInner(
          [void Function(ProductAnalyticsSegmentsPointsInnerBuilder)?
              updates]) =>
      (ProductAnalyticsSegmentsPointsInnerBuilder()..update(updates))._build();

  _$ProductAnalyticsSegmentsPointsInner._(
      {required this.listingId,
      required this.name,
      required this.views,
      required this.conversionPercent,
      required this.orders,
      required this.segment})
      : super._();
  @override
  ProductAnalyticsSegmentsPointsInner rebuild(
          void Function(ProductAnalyticsSegmentsPointsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductAnalyticsSegmentsPointsInnerBuilder toBuilder() =>
      ProductAnalyticsSegmentsPointsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductAnalyticsSegmentsPointsInner &&
        listingId == other.listingId &&
        name == other.name &&
        views == other.views &&
        conversionPercent == other.conversionPercent &&
        orders == other.orders &&
        segment == other.segment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, views.hashCode);
    _$hash = $jc(_$hash, conversionPercent.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, segment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductAnalyticsSegmentsPointsInner')
          ..add('listingId', listingId)
          ..add('name', name)
          ..add('views', views)
          ..add('conversionPercent', conversionPercent)
          ..add('orders', orders)
          ..add('segment', segment))
        .toString();
  }
}

class ProductAnalyticsSegmentsPointsInnerBuilder
    implements
        Builder<ProductAnalyticsSegmentsPointsInner,
            ProductAnalyticsSegmentsPointsInnerBuilder> {
  _$ProductAnalyticsSegmentsPointsInner? _$v;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _views;
  int? get views => _$this._views;
  set views(int? views) => _$this._views = views;

  num? _conversionPercent;
  num? get conversionPercent => _$this._conversionPercent;
  set conversionPercent(num? conversionPercent) =>
      _$this._conversionPercent = conversionPercent;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  String? _segment;
  String? get segment => _$this._segment;
  set segment(String? segment) => _$this._segment = segment;

  ProductAnalyticsSegmentsPointsInnerBuilder() {
    ProductAnalyticsSegmentsPointsInner._defaults(this);
  }

  ProductAnalyticsSegmentsPointsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingId = $v.listingId;
      _name = $v.name;
      _views = $v.views;
      _conversionPercent = $v.conversionPercent;
      _orders = $v.orders;
      _segment = $v.segment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductAnalyticsSegmentsPointsInner other) {
    _$v = other as _$ProductAnalyticsSegmentsPointsInner;
  }

  @override
  void update(
      void Function(ProductAnalyticsSegmentsPointsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductAnalyticsSegmentsPointsInner build() => _build();

  _$ProductAnalyticsSegmentsPointsInner _build() {
    final _$result = _$v ??
        _$ProductAnalyticsSegmentsPointsInner._(
          listingId: BuiltValueNullFieldError.checkNotNull(
              listingId, r'ProductAnalyticsSegmentsPointsInner', 'listingId'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ProductAnalyticsSegmentsPointsInner', 'name'),
          views: BuiltValueNullFieldError.checkNotNull(
              views, r'ProductAnalyticsSegmentsPointsInner', 'views'),
          conversionPercent: BuiltValueNullFieldError.checkNotNull(
              conversionPercent,
              r'ProductAnalyticsSegmentsPointsInner',
              'conversionPercent'),
          orders: BuiltValueNullFieldError.checkNotNull(
              orders, r'ProductAnalyticsSegmentsPointsInner', 'orders'),
          segment: BuiltValueNullFieldError.checkNotNull(
              segment, r'ProductAnalyticsSegmentsPointsInner', 'segment'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
