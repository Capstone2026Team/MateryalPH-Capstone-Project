// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_analytics_kpis.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorProductAnalyticsKpis extends VendorProductAnalyticsKpis {
  @override
  final DashboardDelta views;
  @override
  final DashboardDelta viewers;
  @override
  final VendorProductAnalyticsKpisProductsViewed productsViewed;
  @override
  final DashboardDelta orders;
  @override
  final DashboardRate conversion;
  @override
  final DashboardDelta? valueCentavos;

  factory _$VendorProductAnalyticsKpis(
          [void Function(VendorProductAnalyticsKpisBuilder)? updates]) =>
      (VendorProductAnalyticsKpisBuilder()..update(updates))._build();

  _$VendorProductAnalyticsKpis._(
      {required this.views,
      required this.viewers,
      required this.productsViewed,
      required this.orders,
      required this.conversion,
      this.valueCentavos})
      : super._();
  @override
  VendorProductAnalyticsKpis rebuild(
          void Function(VendorProductAnalyticsKpisBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductAnalyticsKpisBuilder toBuilder() =>
      VendorProductAnalyticsKpisBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductAnalyticsKpis &&
        views == other.views &&
        viewers == other.viewers &&
        productsViewed == other.productsViewed &&
        orders == other.orders &&
        conversion == other.conversion &&
        valueCentavos == other.valueCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, views.hashCode);
    _$hash = $jc(_$hash, viewers.hashCode);
    _$hash = $jc(_$hash, productsViewed.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, conversion.hashCode);
    _$hash = $jc(_$hash, valueCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorProductAnalyticsKpis')
          ..add('views', views)
          ..add('viewers', viewers)
          ..add('productsViewed', productsViewed)
          ..add('orders', orders)
          ..add('conversion', conversion)
          ..add('valueCentavos', valueCentavos))
        .toString();
  }
}

class VendorProductAnalyticsKpisBuilder
    implements
        Builder<VendorProductAnalyticsKpis, VendorProductAnalyticsKpisBuilder> {
  _$VendorProductAnalyticsKpis? _$v;

  DashboardDeltaBuilder? _views;
  DashboardDeltaBuilder get views => _$this._views ??= DashboardDeltaBuilder();
  set views(DashboardDeltaBuilder? views) => _$this._views = views;

  DashboardDeltaBuilder? _viewers;
  DashboardDeltaBuilder get viewers =>
      _$this._viewers ??= DashboardDeltaBuilder();
  set viewers(DashboardDeltaBuilder? viewers) => _$this._viewers = viewers;

  VendorProductAnalyticsKpisProductsViewedBuilder? _productsViewed;
  VendorProductAnalyticsKpisProductsViewedBuilder get productsViewed =>
      _$this._productsViewed ??=
          VendorProductAnalyticsKpisProductsViewedBuilder();
  set productsViewed(
          VendorProductAnalyticsKpisProductsViewedBuilder? productsViewed) =>
      _$this._productsViewed = productsViewed;

  DashboardDeltaBuilder? _orders;
  DashboardDeltaBuilder get orders =>
      _$this._orders ??= DashboardDeltaBuilder();
  set orders(DashboardDeltaBuilder? orders) => _$this._orders = orders;

  DashboardRateBuilder? _conversion;
  DashboardRateBuilder get conversion =>
      _$this._conversion ??= DashboardRateBuilder();
  set conversion(DashboardRateBuilder? conversion) =>
      _$this._conversion = conversion;

  DashboardDeltaBuilder? _valueCentavos;
  DashboardDeltaBuilder get valueCentavos =>
      _$this._valueCentavos ??= DashboardDeltaBuilder();
  set valueCentavos(DashboardDeltaBuilder? valueCentavos) =>
      _$this._valueCentavos = valueCentavos;

  VendorProductAnalyticsKpisBuilder() {
    VendorProductAnalyticsKpis._defaults(this);
  }

  VendorProductAnalyticsKpisBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _views = $v.views.toBuilder();
      _viewers = $v.viewers.toBuilder();
      _productsViewed = $v.productsViewed.toBuilder();
      _orders = $v.orders.toBuilder();
      _conversion = $v.conversion.toBuilder();
      _valueCentavos = $v.valueCentavos?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorProductAnalyticsKpis other) {
    _$v = other as _$VendorProductAnalyticsKpis;
  }

  @override
  void update(void Function(VendorProductAnalyticsKpisBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductAnalyticsKpis build() => _build();

  _$VendorProductAnalyticsKpis _build() {
    _$VendorProductAnalyticsKpis _$result;
    try {
      _$result = _$v ??
          _$VendorProductAnalyticsKpis._(
            views: views.build(),
            viewers: viewers.build(),
            productsViewed: productsViewed.build(),
            orders: orders.build(),
            conversion: conversion.build(),
            valueCentavos: _valueCentavos?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'views';
        views.build();
        _$failedField = 'viewers';
        viewers.build();
        _$failedField = 'productsViewed';
        productsViewed.build();
        _$failedField = 'orders';
        orders.build();
        _$failedField = 'conversion';
        conversion.build();
        _$failedField = 'valueCentavos';
        _valueCentavos?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorProductAnalyticsKpis', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
