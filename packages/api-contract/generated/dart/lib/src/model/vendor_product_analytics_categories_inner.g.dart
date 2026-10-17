// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_analytics_categories_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorProductAnalyticsCategoriesInner
    extends VendorProductAnalyticsCategoriesInner {
  @override
  final String category;
  @override
  final int views;
  @override
  final int orders;
  @override
  final int? valueCentavos;

  factory _$VendorProductAnalyticsCategoriesInner(
          [void Function(VendorProductAnalyticsCategoriesInnerBuilder)?
              updates]) =>
      (VendorProductAnalyticsCategoriesInnerBuilder()..update(updates))
          ._build();

  _$VendorProductAnalyticsCategoriesInner._(
      {required this.category,
      required this.views,
      required this.orders,
      this.valueCentavos})
      : super._();
  @override
  VendorProductAnalyticsCategoriesInner rebuild(
          void Function(VendorProductAnalyticsCategoriesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductAnalyticsCategoriesInnerBuilder toBuilder() =>
      VendorProductAnalyticsCategoriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductAnalyticsCategoriesInner &&
        category == other.category &&
        views == other.views &&
        orders == other.orders &&
        valueCentavos == other.valueCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, views.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, valueCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VendorProductAnalyticsCategoriesInner')
          ..add('category', category)
          ..add('views', views)
          ..add('orders', orders)
          ..add('valueCentavos', valueCentavos))
        .toString();
  }
}

class VendorProductAnalyticsCategoriesInnerBuilder
    implements
        Builder<VendorProductAnalyticsCategoriesInner,
            VendorProductAnalyticsCategoriesInnerBuilder> {
  _$VendorProductAnalyticsCategoriesInner? _$v;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

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

  VendorProductAnalyticsCategoriesInnerBuilder() {
    VendorProductAnalyticsCategoriesInner._defaults(this);
  }

  VendorProductAnalyticsCategoriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _views = $v.views;
      _orders = $v.orders;
      _valueCentavos = $v.valueCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorProductAnalyticsCategoriesInner other) {
    _$v = other as _$VendorProductAnalyticsCategoriesInner;
  }

  @override
  void update(
      void Function(VendorProductAnalyticsCategoriesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductAnalyticsCategoriesInner build() => _build();

  _$VendorProductAnalyticsCategoriesInner _build() {
    final _$result = _$v ??
        _$VendorProductAnalyticsCategoriesInner._(
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'VendorProductAnalyticsCategoriesInner', 'category'),
          views: BuiltValueNullFieldError.checkNotNull(
              views, r'VendorProductAnalyticsCategoriesInner', 'views'),
          orders: BuiltValueNullFieldError.checkNotNull(
              orders, r'VendorProductAnalyticsCategoriesInner', 'orders'),
          valueCentavos: valueCentavos,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
