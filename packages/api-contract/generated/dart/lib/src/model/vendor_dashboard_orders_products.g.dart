// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_orders_products.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardOrdersProducts extends VendorDashboardOrdersProducts {
  @override
  final BuiltList<VendorDashboardProduct> top;
  @override
  final BuiltList<VendorDashboardOrdersProductsCategoriesInner> categories;
  @override
  final VendorDashboardOrdersProductsSegments segments;
  @override
  final VendorDashboardOrdersProductsBasketRules basketRules;

  factory _$VendorDashboardOrdersProducts(
          [void Function(VendorDashboardOrdersProductsBuilder)? updates]) =>
      (VendorDashboardOrdersProductsBuilder()..update(updates))._build();

  _$VendorDashboardOrdersProducts._(
      {required this.top,
      required this.categories,
      required this.segments,
      required this.basketRules})
      : super._();
  @override
  VendorDashboardOrdersProducts rebuild(
          void Function(VendorDashboardOrdersProductsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardOrdersProductsBuilder toBuilder() =>
      VendorDashboardOrdersProductsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardOrdersProducts &&
        top == other.top &&
        categories == other.categories &&
        segments == other.segments &&
        basketRules == other.basketRules;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, top.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, segments.hashCode);
    _$hash = $jc(_$hash, basketRules.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardOrdersProducts')
          ..add('top', top)
          ..add('categories', categories)
          ..add('segments', segments)
          ..add('basketRules', basketRules))
        .toString();
  }
}

class VendorDashboardOrdersProductsBuilder
    implements
        Builder<VendorDashboardOrdersProducts,
            VendorDashboardOrdersProductsBuilder> {
  _$VendorDashboardOrdersProducts? _$v;

  ListBuilder<VendorDashboardProduct>? _top;
  ListBuilder<VendorDashboardProduct> get top =>
      _$this._top ??= ListBuilder<VendorDashboardProduct>();
  set top(ListBuilder<VendorDashboardProduct>? top) => _$this._top = top;

  ListBuilder<VendorDashboardOrdersProductsCategoriesInner>? _categories;
  ListBuilder<VendorDashboardOrdersProductsCategoriesInner> get categories =>
      _$this._categories ??=
          ListBuilder<VendorDashboardOrdersProductsCategoriesInner>();
  set categories(
          ListBuilder<VendorDashboardOrdersProductsCategoriesInner>?
              categories) =>
      _$this._categories = categories;

  VendorDashboardOrdersProductsSegmentsBuilder? _segments;
  VendorDashboardOrdersProductsSegmentsBuilder get segments =>
      _$this._segments ??= VendorDashboardOrdersProductsSegmentsBuilder();
  set segments(VendorDashboardOrdersProductsSegmentsBuilder? segments) =>
      _$this._segments = segments;

  VendorDashboardOrdersProductsBasketRulesBuilder? _basketRules;
  VendorDashboardOrdersProductsBasketRulesBuilder get basketRules =>
      _$this._basketRules ??= VendorDashboardOrdersProductsBasketRulesBuilder();
  set basketRules(
          VendorDashboardOrdersProductsBasketRulesBuilder? basketRules) =>
      _$this._basketRules = basketRules;

  VendorDashboardOrdersProductsBuilder() {
    VendorDashboardOrdersProducts._defaults(this);
  }

  VendorDashboardOrdersProductsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _top = $v.top.toBuilder();
      _categories = $v.categories.toBuilder();
      _segments = $v.segments.toBuilder();
      _basketRules = $v.basketRules.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardOrdersProducts other) {
    _$v = other as _$VendorDashboardOrdersProducts;
  }

  @override
  void update(void Function(VendorDashboardOrdersProductsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardOrdersProducts build() => _build();

  _$VendorDashboardOrdersProducts _build() {
    _$VendorDashboardOrdersProducts _$result;
    try {
      _$result = _$v ??
          _$VendorDashboardOrdersProducts._(
            top: top.build(),
            categories: categories.build(),
            segments: segments.build(),
            basketRules: basketRules.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'top';
        top.build();
        _$failedField = 'categories';
        categories.build();
        _$failedField = 'segments';
        segments.build();
        _$failedField = 'basketRules';
        basketRules.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorDashboardOrdersProducts', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
