// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_analytics_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProductAnalyticsRowStockStatusEnum
    _$productAnalyticsRowStockStatusEnum_IN_STOCK =
    const ProductAnalyticsRowStockStatusEnum._('IN_STOCK');
const ProductAnalyticsRowStockStatusEnum
    _$productAnalyticsRowStockStatusEnum_LIMITED_STOCK =
    const ProductAnalyticsRowStockStatusEnum._('LIMITED_STOCK');
const ProductAnalyticsRowStockStatusEnum
    _$productAnalyticsRowStockStatusEnum_OUT_OF_STOCK =
    const ProductAnalyticsRowStockStatusEnum._('OUT_OF_STOCK');

ProductAnalyticsRowStockStatusEnum _$productAnalyticsRowStockStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'IN_STOCK':
      return _$productAnalyticsRowStockStatusEnum_IN_STOCK;
    case 'LIMITED_STOCK':
      return _$productAnalyticsRowStockStatusEnum_LIMITED_STOCK;
    case 'OUT_OF_STOCK':
      return _$productAnalyticsRowStockStatusEnum_OUT_OF_STOCK;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProductAnalyticsRowStockStatusEnum>
    _$productAnalyticsRowStockStatusEnumValues = BuiltSet<
        ProductAnalyticsRowStockStatusEnum>(const <ProductAnalyticsRowStockStatusEnum>[
  _$productAnalyticsRowStockStatusEnum_IN_STOCK,
  _$productAnalyticsRowStockStatusEnum_LIMITED_STOCK,
  _$productAnalyticsRowStockStatusEnum_OUT_OF_STOCK,
]);

Serializer<ProductAnalyticsRowStockStatusEnum>
    _$productAnalyticsRowStockStatusEnumSerializer =
    _$ProductAnalyticsRowStockStatusEnumSerializer();

class _$ProductAnalyticsRowStockStatusEnumSerializer
    implements PrimitiveSerializer<ProductAnalyticsRowStockStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'IN_STOCK': 'IN_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
    'OUT_OF_STOCK': 'OUT_OF_STOCK',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'IN_STOCK': 'IN_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
    'OUT_OF_STOCK': 'OUT_OF_STOCK',
  };

  @override
  final Iterable<Type> types = const <Type>[ProductAnalyticsRowStockStatusEnum];
  @override
  final String wireName = 'ProductAnalyticsRowStockStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ProductAnalyticsRowStockStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProductAnalyticsRowStockStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProductAnalyticsRowStockStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProductAnalyticsRow extends ProductAnalyticsRow {
  @override
  final String listingId;
  @override
  final String name;
  @override
  final String? sku;
  @override
  final String category;
  @override
  final String? status;
  @override
  final ProductAnalyticsRowStockStatusEnum stockStatus;
  @override
  final int views;
  @override
  final int previousViews;
  @override
  final num? viewsChangePercent;
  @override
  final int viewers;
  @override
  final int converted;
  @override
  final DashboardRate conversion;
  @override
  final num? conversionLowerBound;
  @override
  final int orders;
  @override
  final int previousOrders;
  @override
  final int buyers;
  @override
  final int? valueCentavos;
  @override
  final String? segment;
  @override
  final int? rankViews;
  @override
  final int? rankOrders;

  factory _$ProductAnalyticsRow(
          [void Function(ProductAnalyticsRowBuilder)? updates]) =>
      (ProductAnalyticsRowBuilder()..update(updates))._build();

  _$ProductAnalyticsRow._(
      {required this.listingId,
      required this.name,
      this.sku,
      required this.category,
      this.status,
      required this.stockStatus,
      required this.views,
      required this.previousViews,
      this.viewsChangePercent,
      required this.viewers,
      required this.converted,
      required this.conversion,
      this.conversionLowerBound,
      required this.orders,
      required this.previousOrders,
      required this.buyers,
      this.valueCentavos,
      this.segment,
      this.rankViews,
      this.rankOrders})
      : super._();
  @override
  ProductAnalyticsRow rebuild(
          void Function(ProductAnalyticsRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductAnalyticsRowBuilder toBuilder() =>
      ProductAnalyticsRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductAnalyticsRow &&
        listingId == other.listingId &&
        name == other.name &&
        sku == other.sku &&
        category == other.category &&
        status == other.status &&
        stockStatus == other.stockStatus &&
        views == other.views &&
        previousViews == other.previousViews &&
        viewsChangePercent == other.viewsChangePercent &&
        viewers == other.viewers &&
        converted == other.converted &&
        conversion == other.conversion &&
        conversionLowerBound == other.conversionLowerBound &&
        orders == other.orders &&
        previousOrders == other.previousOrders &&
        buyers == other.buyers &&
        valueCentavos == other.valueCentavos &&
        segment == other.segment &&
        rankViews == other.rankViews &&
        rankOrders == other.rankOrders;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, stockStatus.hashCode);
    _$hash = $jc(_$hash, views.hashCode);
    _$hash = $jc(_$hash, previousViews.hashCode);
    _$hash = $jc(_$hash, viewsChangePercent.hashCode);
    _$hash = $jc(_$hash, viewers.hashCode);
    _$hash = $jc(_$hash, converted.hashCode);
    _$hash = $jc(_$hash, conversion.hashCode);
    _$hash = $jc(_$hash, conversionLowerBound.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, previousOrders.hashCode);
    _$hash = $jc(_$hash, buyers.hashCode);
    _$hash = $jc(_$hash, valueCentavos.hashCode);
    _$hash = $jc(_$hash, segment.hashCode);
    _$hash = $jc(_$hash, rankViews.hashCode);
    _$hash = $jc(_$hash, rankOrders.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductAnalyticsRow')
          ..add('listingId', listingId)
          ..add('name', name)
          ..add('sku', sku)
          ..add('category', category)
          ..add('status', status)
          ..add('stockStatus', stockStatus)
          ..add('views', views)
          ..add('previousViews', previousViews)
          ..add('viewsChangePercent', viewsChangePercent)
          ..add('viewers', viewers)
          ..add('converted', converted)
          ..add('conversion', conversion)
          ..add('conversionLowerBound', conversionLowerBound)
          ..add('orders', orders)
          ..add('previousOrders', previousOrders)
          ..add('buyers', buyers)
          ..add('valueCentavos', valueCentavos)
          ..add('segment', segment)
          ..add('rankViews', rankViews)
          ..add('rankOrders', rankOrders))
        .toString();
  }
}

class ProductAnalyticsRowBuilder
    implements Builder<ProductAnalyticsRow, ProductAnalyticsRowBuilder> {
  _$ProductAnalyticsRow? _$v;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  ProductAnalyticsRowStockStatusEnum? _stockStatus;
  ProductAnalyticsRowStockStatusEnum? get stockStatus => _$this._stockStatus;
  set stockStatus(ProductAnalyticsRowStockStatusEnum? stockStatus) =>
      _$this._stockStatus = stockStatus;

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

  int? _converted;
  int? get converted => _$this._converted;
  set converted(int? converted) => _$this._converted = converted;

  DashboardRateBuilder? _conversion;
  DashboardRateBuilder get conversion =>
      _$this._conversion ??= DashboardRateBuilder();
  set conversion(DashboardRateBuilder? conversion) =>
      _$this._conversion = conversion;

  num? _conversionLowerBound;
  num? get conversionLowerBound => _$this._conversionLowerBound;
  set conversionLowerBound(num? conversionLowerBound) =>
      _$this._conversionLowerBound = conversionLowerBound;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  int? _previousOrders;
  int? get previousOrders => _$this._previousOrders;
  set previousOrders(int? previousOrders) =>
      _$this._previousOrders = previousOrders;

  int? _buyers;
  int? get buyers => _$this._buyers;
  set buyers(int? buyers) => _$this._buyers = buyers;

  int? _valueCentavos;
  int? get valueCentavos => _$this._valueCentavos;
  set valueCentavos(int? valueCentavos) =>
      _$this._valueCentavos = valueCentavos;

  String? _segment;
  String? get segment => _$this._segment;
  set segment(String? segment) => _$this._segment = segment;

  int? _rankViews;
  int? get rankViews => _$this._rankViews;
  set rankViews(int? rankViews) => _$this._rankViews = rankViews;

  int? _rankOrders;
  int? get rankOrders => _$this._rankOrders;
  set rankOrders(int? rankOrders) => _$this._rankOrders = rankOrders;

  ProductAnalyticsRowBuilder() {
    ProductAnalyticsRow._defaults(this);
  }

  ProductAnalyticsRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingId = $v.listingId;
      _name = $v.name;
      _sku = $v.sku;
      _category = $v.category;
      _status = $v.status;
      _stockStatus = $v.stockStatus;
      _views = $v.views;
      _previousViews = $v.previousViews;
      _viewsChangePercent = $v.viewsChangePercent;
      _viewers = $v.viewers;
      _converted = $v.converted;
      _conversion = $v.conversion.toBuilder();
      _conversionLowerBound = $v.conversionLowerBound;
      _orders = $v.orders;
      _previousOrders = $v.previousOrders;
      _buyers = $v.buyers;
      _valueCentavos = $v.valueCentavos;
      _segment = $v.segment;
      _rankViews = $v.rankViews;
      _rankOrders = $v.rankOrders;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductAnalyticsRow other) {
    _$v = other as _$ProductAnalyticsRow;
  }

  @override
  void update(void Function(ProductAnalyticsRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductAnalyticsRow build() => _build();

  _$ProductAnalyticsRow _build() {
    _$ProductAnalyticsRow _$result;
    try {
      _$result = _$v ??
          _$ProductAnalyticsRow._(
            listingId: BuiltValueNullFieldError.checkNotNull(
                listingId, r'ProductAnalyticsRow', 'listingId'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'ProductAnalyticsRow', 'name'),
            sku: sku,
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'ProductAnalyticsRow', 'category'),
            status: status,
            stockStatus: BuiltValueNullFieldError.checkNotNull(
                stockStatus, r'ProductAnalyticsRow', 'stockStatus'),
            views: BuiltValueNullFieldError.checkNotNull(
                views, r'ProductAnalyticsRow', 'views'),
            previousViews: BuiltValueNullFieldError.checkNotNull(
                previousViews, r'ProductAnalyticsRow', 'previousViews'),
            viewsChangePercent: viewsChangePercent,
            viewers: BuiltValueNullFieldError.checkNotNull(
                viewers, r'ProductAnalyticsRow', 'viewers'),
            converted: BuiltValueNullFieldError.checkNotNull(
                converted, r'ProductAnalyticsRow', 'converted'),
            conversion: conversion.build(),
            conversionLowerBound: conversionLowerBound,
            orders: BuiltValueNullFieldError.checkNotNull(
                orders, r'ProductAnalyticsRow', 'orders'),
            previousOrders: BuiltValueNullFieldError.checkNotNull(
                previousOrders, r'ProductAnalyticsRow', 'previousOrders'),
            buyers: BuiltValueNullFieldError.checkNotNull(
                buyers, r'ProductAnalyticsRow', 'buyers'),
            valueCentavos: valueCentavos,
            segment: segment,
            rankViews: rankViews,
            rankOrders: rankOrders,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'conversion';
        conversion.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProductAnalyticsRow', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
