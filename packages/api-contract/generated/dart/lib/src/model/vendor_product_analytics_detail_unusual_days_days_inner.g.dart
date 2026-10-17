// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_analytics_detail_unusual_days_days_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorProductAnalyticsDetailUnusualDaysDaysInner
    extends VendorProductAnalyticsDetailUnusualDaysDaysInner {
  @override
  final Date date;
  @override
  final int views;
  @override
  final int orders;

  factory _$VendorProductAnalyticsDetailUnusualDaysDaysInner(
          [void Function(
                  VendorProductAnalyticsDetailUnusualDaysDaysInnerBuilder)?
              updates]) =>
      (VendorProductAnalyticsDetailUnusualDaysDaysInnerBuilder()
            ..update(updates))
          ._build();

  _$VendorProductAnalyticsDetailUnusualDaysDaysInner._(
      {required this.date, required this.views, required this.orders})
      : super._();
  @override
  VendorProductAnalyticsDetailUnusualDaysDaysInner rebuild(
          void Function(VendorProductAnalyticsDetailUnusualDaysDaysInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductAnalyticsDetailUnusualDaysDaysInnerBuilder toBuilder() =>
      VendorProductAnalyticsDetailUnusualDaysDaysInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductAnalyticsDetailUnusualDaysDaysInner &&
        date == other.date &&
        views == other.views &&
        orders == other.orders;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, views.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VendorProductAnalyticsDetailUnusualDaysDaysInner')
          ..add('date', date)
          ..add('views', views)
          ..add('orders', orders))
        .toString();
  }
}

class VendorProductAnalyticsDetailUnusualDaysDaysInnerBuilder
    implements
        Builder<VendorProductAnalyticsDetailUnusualDaysDaysInner,
            VendorProductAnalyticsDetailUnusualDaysDaysInnerBuilder> {
  _$VendorProductAnalyticsDetailUnusualDaysDaysInner? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  int? _views;
  int? get views => _$this._views;
  set views(int? views) => _$this._views = views;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  VendorProductAnalyticsDetailUnusualDaysDaysInnerBuilder() {
    VendorProductAnalyticsDetailUnusualDaysDaysInner._defaults(this);
  }

  VendorProductAnalyticsDetailUnusualDaysDaysInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _views = $v.views;
      _orders = $v.orders;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorProductAnalyticsDetailUnusualDaysDaysInner other) {
    _$v = other as _$VendorProductAnalyticsDetailUnusualDaysDaysInner;
  }

  @override
  void update(
      void Function(VendorProductAnalyticsDetailUnusualDaysDaysInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductAnalyticsDetailUnusualDaysDaysInner build() => _build();

  _$VendorProductAnalyticsDetailUnusualDaysDaysInner _build() {
    final _$result = _$v ??
        _$VendorProductAnalyticsDetailUnusualDaysDaysInner._(
          date: BuiltValueNullFieldError.checkNotNull(date,
              r'VendorProductAnalyticsDetailUnusualDaysDaysInner', 'date'),
          views: BuiltValueNullFieldError.checkNotNull(views,
              r'VendorProductAnalyticsDetailUnusualDaysDaysInner', 'views'),
          orders: BuiltValueNullFieldError.checkNotNull(orders,
              r'VendorProductAnalyticsDetailUnusualDaysDaysInner', 'orders'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
