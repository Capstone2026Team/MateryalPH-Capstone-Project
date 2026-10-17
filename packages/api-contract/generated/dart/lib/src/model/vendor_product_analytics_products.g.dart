// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_analytics_products.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorProductAnalyticsProducts extends VendorProductAnalyticsProducts {
  @override
  final BuiltList<ProductAnalyticsRow> items;
  @override
  final VendorProductAnalyticsProductsMeta meta;

  factory _$VendorProductAnalyticsProducts(
          [void Function(VendorProductAnalyticsProductsBuilder)? updates]) =>
      (VendorProductAnalyticsProductsBuilder()..update(updates))._build();

  _$VendorProductAnalyticsProducts._({required this.items, required this.meta})
      : super._();
  @override
  VendorProductAnalyticsProducts rebuild(
          void Function(VendorProductAnalyticsProductsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductAnalyticsProductsBuilder toBuilder() =>
      VendorProductAnalyticsProductsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductAnalyticsProducts &&
        items == other.items &&
        meta == other.meta;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorProductAnalyticsProducts')
          ..add('items', items)
          ..add('meta', meta))
        .toString();
  }
}

class VendorProductAnalyticsProductsBuilder
    implements
        Builder<VendorProductAnalyticsProducts,
            VendorProductAnalyticsProductsBuilder> {
  _$VendorProductAnalyticsProducts? _$v;

  ListBuilder<ProductAnalyticsRow>? _items;
  ListBuilder<ProductAnalyticsRow> get items =>
      _$this._items ??= ListBuilder<ProductAnalyticsRow>();
  set items(ListBuilder<ProductAnalyticsRow>? items) => _$this._items = items;

  VendorProductAnalyticsProductsMetaBuilder? _meta;
  VendorProductAnalyticsProductsMetaBuilder get meta =>
      _$this._meta ??= VendorProductAnalyticsProductsMetaBuilder();
  set meta(VendorProductAnalyticsProductsMetaBuilder? meta) =>
      _$this._meta = meta;

  VendorProductAnalyticsProductsBuilder() {
    VendorProductAnalyticsProducts._defaults(this);
  }

  VendorProductAnalyticsProductsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorProductAnalyticsProducts other) {
    _$v = other as _$VendorProductAnalyticsProducts;
  }

  @override
  void update(void Function(VendorProductAnalyticsProductsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductAnalyticsProducts build() => _build();

  _$VendorProductAnalyticsProducts _build() {
    _$VendorProductAnalyticsProducts _$result;
    try {
      _$result = _$v ??
          _$VendorProductAnalyticsProducts._(
            items: items.build(),
            meta: meta.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
        _$failedField = 'meta';
        meta.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorProductAnalyticsProducts', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
