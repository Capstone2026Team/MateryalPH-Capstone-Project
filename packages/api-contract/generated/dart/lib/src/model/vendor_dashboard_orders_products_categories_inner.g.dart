// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_orders_products_categories_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardOrdersProductsCategoriesInner
    extends VendorDashboardOrdersProductsCategoriesInner {
  @override
  final String category;
  @override
  final int orders;
  @override
  final int? valueCentavos;

  factory _$VendorDashboardOrdersProductsCategoriesInner(
          [void Function(VendorDashboardOrdersProductsCategoriesInnerBuilder)?
              updates]) =>
      (VendorDashboardOrdersProductsCategoriesInnerBuilder()..update(updates))
          ._build();

  _$VendorDashboardOrdersProductsCategoriesInner._(
      {required this.category, required this.orders, this.valueCentavos})
      : super._();
  @override
  VendorDashboardOrdersProductsCategoriesInner rebuild(
          void Function(VendorDashboardOrdersProductsCategoriesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardOrdersProductsCategoriesInnerBuilder toBuilder() =>
      VendorDashboardOrdersProductsCategoriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardOrdersProductsCategoriesInner &&
        category == other.category &&
        orders == other.orders &&
        valueCentavos == other.valueCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, valueCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VendorDashboardOrdersProductsCategoriesInner')
          ..add('category', category)
          ..add('orders', orders)
          ..add('valueCentavos', valueCentavos))
        .toString();
  }
}

class VendorDashboardOrdersProductsCategoriesInnerBuilder
    implements
        Builder<VendorDashboardOrdersProductsCategoriesInner,
            VendorDashboardOrdersProductsCategoriesInnerBuilder> {
  _$VendorDashboardOrdersProductsCategoriesInner? _$v;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  int? _valueCentavos;
  int? get valueCentavos => _$this._valueCentavos;
  set valueCentavos(int? valueCentavos) =>
      _$this._valueCentavos = valueCentavos;

  VendorDashboardOrdersProductsCategoriesInnerBuilder() {
    VendorDashboardOrdersProductsCategoriesInner._defaults(this);
  }

  VendorDashboardOrdersProductsCategoriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _orders = $v.orders;
      _valueCentavos = $v.valueCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardOrdersProductsCategoriesInner other) {
    _$v = other as _$VendorDashboardOrdersProductsCategoriesInner;
  }

  @override
  void update(
      void Function(VendorDashboardOrdersProductsCategoriesInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardOrdersProductsCategoriesInner build() => _build();

  _$VendorDashboardOrdersProductsCategoriesInner _build() {
    final _$result = _$v ??
        _$VendorDashboardOrdersProductsCategoriesInner._(
          category: BuiltValueNullFieldError.checkNotNull(category,
              r'VendorDashboardOrdersProductsCategoriesInner', 'category'),
          orders: BuiltValueNullFieldError.checkNotNull(orders,
              r'VendorDashboardOrdersProductsCategoriesInner', 'orders'),
          valueCentavos: valueCentavos,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
