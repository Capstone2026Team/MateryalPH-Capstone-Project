// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_analytics_detail_kpis.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorProductAnalyticsDetailKpis
    extends VendorProductAnalyticsDetailKpis {
  @override
  final DashboardDelta views;
  @override
  final DashboardDelta viewers;
  @override
  final DashboardDelta orders;
  @override
  final int buyers;
  @override
  final DashboardRate conversion;
  @override
  final DashboardRate storeConversion;
  @override
  final DashboardDelta? valueCentavos;
  @override
  final int products;

  factory _$VendorProductAnalyticsDetailKpis(
          [void Function(VendorProductAnalyticsDetailKpisBuilder)? updates]) =>
      (VendorProductAnalyticsDetailKpisBuilder()..update(updates))._build();

  _$VendorProductAnalyticsDetailKpis._(
      {required this.views,
      required this.viewers,
      required this.orders,
      required this.buyers,
      required this.conversion,
      required this.storeConversion,
      this.valueCentavos,
      required this.products})
      : super._();
  @override
  VendorProductAnalyticsDetailKpis rebuild(
          void Function(VendorProductAnalyticsDetailKpisBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductAnalyticsDetailKpisBuilder toBuilder() =>
      VendorProductAnalyticsDetailKpisBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductAnalyticsDetailKpis &&
        views == other.views &&
        viewers == other.viewers &&
        orders == other.orders &&
        buyers == other.buyers &&
        conversion == other.conversion &&
        storeConversion == other.storeConversion &&
        valueCentavos == other.valueCentavos &&
        products == other.products;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, views.hashCode);
    _$hash = $jc(_$hash, viewers.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, buyers.hashCode);
    _$hash = $jc(_$hash, conversion.hashCode);
    _$hash = $jc(_$hash, storeConversion.hashCode);
    _$hash = $jc(_$hash, valueCentavos.hashCode);
    _$hash = $jc(_$hash, products.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorProductAnalyticsDetailKpis')
          ..add('views', views)
          ..add('viewers', viewers)
          ..add('orders', orders)
          ..add('buyers', buyers)
          ..add('conversion', conversion)
          ..add('storeConversion', storeConversion)
          ..add('valueCentavos', valueCentavos)
          ..add('products', products))
        .toString();
  }
}

class VendorProductAnalyticsDetailKpisBuilder
    implements
        Builder<VendorProductAnalyticsDetailKpis,
            VendorProductAnalyticsDetailKpisBuilder> {
  _$VendorProductAnalyticsDetailKpis? _$v;

  DashboardDeltaBuilder? _views;
  DashboardDeltaBuilder get views => _$this._views ??= DashboardDeltaBuilder();
  set views(DashboardDeltaBuilder? views) => _$this._views = views;

  DashboardDeltaBuilder? _viewers;
  DashboardDeltaBuilder get viewers =>
      _$this._viewers ??= DashboardDeltaBuilder();
  set viewers(DashboardDeltaBuilder? viewers) => _$this._viewers = viewers;

  DashboardDeltaBuilder? _orders;
  DashboardDeltaBuilder get orders =>
      _$this._orders ??= DashboardDeltaBuilder();
  set orders(DashboardDeltaBuilder? orders) => _$this._orders = orders;

  int? _buyers;
  int? get buyers => _$this._buyers;
  set buyers(int? buyers) => _$this._buyers = buyers;

  DashboardRateBuilder? _conversion;
  DashboardRateBuilder get conversion =>
      _$this._conversion ??= DashboardRateBuilder();
  set conversion(DashboardRateBuilder? conversion) =>
      _$this._conversion = conversion;

  DashboardRateBuilder? _storeConversion;
  DashboardRateBuilder get storeConversion =>
      _$this._storeConversion ??= DashboardRateBuilder();
  set storeConversion(DashboardRateBuilder? storeConversion) =>
      _$this._storeConversion = storeConversion;

  DashboardDeltaBuilder? _valueCentavos;
  DashboardDeltaBuilder get valueCentavos =>
      _$this._valueCentavos ??= DashboardDeltaBuilder();
  set valueCentavos(DashboardDeltaBuilder? valueCentavos) =>
      _$this._valueCentavos = valueCentavos;

  int? _products;
  int? get products => _$this._products;
  set products(int? products) => _$this._products = products;

  VendorProductAnalyticsDetailKpisBuilder() {
    VendorProductAnalyticsDetailKpis._defaults(this);
  }

  VendorProductAnalyticsDetailKpisBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _views = $v.views.toBuilder();
      _viewers = $v.viewers.toBuilder();
      _orders = $v.orders.toBuilder();
      _buyers = $v.buyers;
      _conversion = $v.conversion.toBuilder();
      _storeConversion = $v.storeConversion.toBuilder();
      _valueCentavos = $v.valueCentavos?.toBuilder();
      _products = $v.products;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorProductAnalyticsDetailKpis other) {
    _$v = other as _$VendorProductAnalyticsDetailKpis;
  }

  @override
  void update(void Function(VendorProductAnalyticsDetailKpisBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductAnalyticsDetailKpis build() => _build();

  _$VendorProductAnalyticsDetailKpis _build() {
    _$VendorProductAnalyticsDetailKpis _$result;
    try {
      _$result = _$v ??
          _$VendorProductAnalyticsDetailKpis._(
            views: views.build(),
            viewers: viewers.build(),
            orders: orders.build(),
            buyers: BuiltValueNullFieldError.checkNotNull(
                buyers, r'VendorProductAnalyticsDetailKpis', 'buyers'),
            conversion: conversion.build(),
            storeConversion: storeConversion.build(),
            valueCentavos: _valueCentavos?.build(),
            products: BuiltValueNullFieldError.checkNotNull(
                products, r'VendorProductAnalyticsDetailKpis', 'products'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'views';
        views.build();
        _$failedField = 'viewers';
        viewers.build();
        _$failedField = 'orders';
        orders.build();

        _$failedField = 'conversion';
        conversion.build();
        _$failedField = 'storeConversion';
        storeConversion.build();
        _$failedField = 'valueCentavos';
        _valueCentavos?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorProductAnalyticsDetailKpis', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
