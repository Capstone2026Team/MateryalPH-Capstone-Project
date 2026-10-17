// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_analytics_summaries_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorProductAnalyticsSummariesItemsInner
    extends VendorProductAnalyticsSummariesItemsInner {
  @override
  final String listingId;
  @override
  final int views;
  @override
  final int previousViews;
  @override
  final num? viewsChangePercent;
  @override
  final int viewers;
  @override
  final int orders;
  @override
  final DashboardRate conversion;
  @override
  final BuiltList<int> dailyViews;

  factory _$VendorProductAnalyticsSummariesItemsInner(
          [void Function(VendorProductAnalyticsSummariesItemsInnerBuilder)?
              updates]) =>
      (VendorProductAnalyticsSummariesItemsInnerBuilder()..update(updates))
          ._build();

  _$VendorProductAnalyticsSummariesItemsInner._(
      {required this.listingId,
      required this.views,
      required this.previousViews,
      this.viewsChangePercent,
      required this.viewers,
      required this.orders,
      required this.conversion,
      required this.dailyViews})
      : super._();
  @override
  VendorProductAnalyticsSummariesItemsInner rebuild(
          void Function(VendorProductAnalyticsSummariesItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductAnalyticsSummariesItemsInnerBuilder toBuilder() =>
      VendorProductAnalyticsSummariesItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductAnalyticsSummariesItemsInner &&
        listingId == other.listingId &&
        views == other.views &&
        previousViews == other.previousViews &&
        viewsChangePercent == other.viewsChangePercent &&
        viewers == other.viewers &&
        orders == other.orders &&
        conversion == other.conversion &&
        dailyViews == other.dailyViews;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, views.hashCode);
    _$hash = $jc(_$hash, previousViews.hashCode);
    _$hash = $jc(_$hash, viewsChangePercent.hashCode);
    _$hash = $jc(_$hash, viewers.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, conversion.hashCode);
    _$hash = $jc(_$hash, dailyViews.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VendorProductAnalyticsSummariesItemsInner')
          ..add('listingId', listingId)
          ..add('views', views)
          ..add('previousViews', previousViews)
          ..add('viewsChangePercent', viewsChangePercent)
          ..add('viewers', viewers)
          ..add('orders', orders)
          ..add('conversion', conversion)
          ..add('dailyViews', dailyViews))
        .toString();
  }
}

class VendorProductAnalyticsSummariesItemsInnerBuilder
    implements
        Builder<VendorProductAnalyticsSummariesItemsInner,
            VendorProductAnalyticsSummariesItemsInnerBuilder> {
  _$VendorProductAnalyticsSummariesItemsInner? _$v;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  int? _views;
  int? get views => _$this._views;
  set views(int? views) => _$this._views = views;

  int? _previousViews;
  int? get previousViews => _$this._previousViews;
  set previousViews(int? previousViews) =>
      _$this._previousViews = previousViews;

  num? _viewsChangePercent;
  num? get viewsChangePercent => _$this._viewsChangePercent;
  set viewsChangePercent(num? viewsChangePercent) =>
      _$this._viewsChangePercent = viewsChangePercent;

  int? _viewers;
  int? get viewers => _$this._viewers;
  set viewers(int? viewers) => _$this._viewers = viewers;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  DashboardRateBuilder? _conversion;
  DashboardRateBuilder get conversion =>
      _$this._conversion ??= DashboardRateBuilder();
  set conversion(DashboardRateBuilder? conversion) =>
      _$this._conversion = conversion;

  ListBuilder<int>? _dailyViews;
  ListBuilder<int> get dailyViews => _$this._dailyViews ??= ListBuilder<int>();
  set dailyViews(ListBuilder<int>? dailyViews) =>
      _$this._dailyViews = dailyViews;

  VendorProductAnalyticsSummariesItemsInnerBuilder() {
    VendorProductAnalyticsSummariesItemsInner._defaults(this);
  }

  VendorProductAnalyticsSummariesItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingId = $v.listingId;
      _views = $v.views;
      _previousViews = $v.previousViews;
      _viewsChangePercent = $v.viewsChangePercent;
      _viewers = $v.viewers;
      _orders = $v.orders;
      _conversion = $v.conversion.toBuilder();
      _dailyViews = $v.dailyViews.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorProductAnalyticsSummariesItemsInner other) {
    _$v = other as _$VendorProductAnalyticsSummariesItemsInner;
  }

  @override
  void update(
      void Function(VendorProductAnalyticsSummariesItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductAnalyticsSummariesItemsInner build() => _build();

  _$VendorProductAnalyticsSummariesItemsInner _build() {
    _$VendorProductAnalyticsSummariesItemsInner _$result;
    try {
      _$result = _$v ??
          _$VendorProductAnalyticsSummariesItemsInner._(
            listingId: BuiltValueNullFieldError.checkNotNull(listingId,
                r'VendorProductAnalyticsSummariesItemsInner', 'listingId'),
            views: BuiltValueNullFieldError.checkNotNull(
                views, r'VendorProductAnalyticsSummariesItemsInner', 'views'),
            previousViews: BuiltValueNullFieldError.checkNotNull(previousViews,
                r'VendorProductAnalyticsSummariesItemsInner', 'previousViews'),
            viewsChangePercent: viewsChangePercent,
            viewers: BuiltValueNullFieldError.checkNotNull(viewers,
                r'VendorProductAnalyticsSummariesItemsInner', 'viewers'),
            orders: BuiltValueNullFieldError.checkNotNull(
                orders, r'VendorProductAnalyticsSummariesItemsInner', 'orders'),
            conversion: conversion.build(),
            dailyViews: dailyViews.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'conversion';
        conversion.build();
        _$failedField = 'dailyViews';
        dailyViews.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorProductAnalyticsSummariesItemsInner',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
