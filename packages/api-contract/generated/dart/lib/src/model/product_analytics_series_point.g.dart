// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_analytics_series_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductAnalyticsSeriesPoint extends ProductAnalyticsSeriesPoint {
  @override
  final Date date;
  @override
  final int views;
  @override
  final int orders;
  @override
  final int? valueCentavos;

  factory _$ProductAnalyticsSeriesPoint(
          [void Function(ProductAnalyticsSeriesPointBuilder)? updates]) =>
      (ProductAnalyticsSeriesPointBuilder()..update(updates))._build();

  _$ProductAnalyticsSeriesPoint._(
      {required this.date,
      required this.views,
      required this.orders,
      this.valueCentavos})
      : super._();
  @override
  ProductAnalyticsSeriesPoint rebuild(
          void Function(ProductAnalyticsSeriesPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductAnalyticsSeriesPointBuilder toBuilder() =>
      ProductAnalyticsSeriesPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductAnalyticsSeriesPoint &&
        date == other.date &&
        views == other.views &&
        orders == other.orders &&
        valueCentavos == other.valueCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, views.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, valueCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductAnalyticsSeriesPoint')
          ..add('date', date)
          ..add('views', views)
          ..add('orders', orders)
          ..add('valueCentavos', valueCentavos))
        .toString();
  }
}

class ProductAnalyticsSeriesPointBuilder
    implements
        Builder<ProductAnalyticsSeriesPoint,
            ProductAnalyticsSeriesPointBuilder> {
  _$ProductAnalyticsSeriesPoint? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  int? _views;
  int? get views => _$this._views;
  set views(int? views) => _$this._views = views;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  int? _valueCentavos;
  int? get valueCentavos => _$this._valueCentavos;
  set valueCentavos(int? valueCentavos) =>
      _$this._valueCentavos = valueCentavos;

  ProductAnalyticsSeriesPointBuilder() {
    ProductAnalyticsSeriesPoint._defaults(this);
  }

  ProductAnalyticsSeriesPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _views = $v.views;
      _orders = $v.orders;
      _valueCentavos = $v.valueCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductAnalyticsSeriesPoint other) {
    _$v = other as _$ProductAnalyticsSeriesPoint;
  }

  @override
  void update(void Function(ProductAnalyticsSeriesPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductAnalyticsSeriesPoint build() => _build();

  _$ProductAnalyticsSeriesPoint _build() {
    final _$result = _$v ??
        _$ProductAnalyticsSeriesPoint._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'ProductAnalyticsSeriesPoint', 'date'),
          views: BuiltValueNullFieldError.checkNotNull(
              views, r'ProductAnalyticsSeriesPoint', 'views'),
          orders: BuiltValueNullFieldError.checkNotNull(
              orders, r'ProductAnalyticsSeriesPoint', 'orders'),
          valueCentavos: valueCentavos,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
