// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_stock.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardStock extends VendorDashboardStock {
  @override
  final int variants;
  @override
  final int inStock;
  @override
  final int limitedStock;
  @override
  final int outOfStock;
  @override
  final BuiltList<VendorDashboardStockAttentionInner> attention;

  factory _$VendorDashboardStock(
          [void Function(VendorDashboardStockBuilder)? updates]) =>
      (VendorDashboardStockBuilder()..update(updates))._build();

  _$VendorDashboardStock._(
      {required this.variants,
      required this.inStock,
      required this.limitedStock,
      required this.outOfStock,
      required this.attention})
      : super._();
  @override
  VendorDashboardStock rebuild(
          void Function(VendorDashboardStockBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardStockBuilder toBuilder() =>
      VendorDashboardStockBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardStock &&
        variants == other.variants &&
        inStock == other.inStock &&
        limitedStock == other.limitedStock &&
        outOfStock == other.outOfStock &&
        attention == other.attention;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, variants.hashCode);
    _$hash = $jc(_$hash, inStock.hashCode);
    _$hash = $jc(_$hash, limitedStock.hashCode);
    _$hash = $jc(_$hash, outOfStock.hashCode);
    _$hash = $jc(_$hash, attention.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardStock')
          ..add('variants', variants)
          ..add('inStock', inStock)
          ..add('limitedStock', limitedStock)
          ..add('outOfStock', outOfStock)
          ..add('attention', attention))
        .toString();
  }
}

class VendorDashboardStockBuilder
    implements Builder<VendorDashboardStock, VendorDashboardStockBuilder> {
  _$VendorDashboardStock? _$v;

  int? _variants;
  int? get variants => _$this._variants;
  set variants(int? variants) => _$this._variants = variants;

  int? _inStock;
  int? get inStock => _$this._inStock;
  set inStock(int? inStock) => _$this._inStock = inStock;

  int? _limitedStock;
  int? get limitedStock => _$this._limitedStock;
  set limitedStock(int? limitedStock) => _$this._limitedStock = limitedStock;

  int? _outOfStock;
  int? get outOfStock => _$this._outOfStock;
  set outOfStock(int? outOfStock) => _$this._outOfStock = outOfStock;

  ListBuilder<VendorDashboardStockAttentionInner>? _attention;
  ListBuilder<VendorDashboardStockAttentionInner> get attention =>
      _$this._attention ??= ListBuilder<VendorDashboardStockAttentionInner>();
  set attention(ListBuilder<VendorDashboardStockAttentionInner>? attention) =>
      _$this._attention = attention;

  VendorDashboardStockBuilder() {
    VendorDashboardStock._defaults(this);
  }

  VendorDashboardStockBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _variants = $v.variants;
      _inStock = $v.inStock;
      _limitedStock = $v.limitedStock;
      _outOfStock = $v.outOfStock;
      _attention = $v.attention.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardStock other) {
    _$v = other as _$VendorDashboardStock;
  }

  @override
  void update(void Function(VendorDashboardStockBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardStock build() => _build();

  _$VendorDashboardStock _build() {
    _$VendorDashboardStock _$result;
    try {
      _$result = _$v ??
          _$VendorDashboardStock._(
            variants: BuiltValueNullFieldError.checkNotNull(
                variants, r'VendorDashboardStock', 'variants'),
            inStock: BuiltValueNullFieldError.checkNotNull(
                inStock, r'VendorDashboardStock', 'inStock'),
            limitedStock: BuiltValueNullFieldError.checkNotNull(
                limitedStock, r'VendorDashboardStock', 'limitedStock'),
            outOfStock: BuiltValueNullFieldError.checkNotNull(
                outOfStock, r'VendorDashboardStock', 'outOfStock'),
            attention: attention.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attention';
        attention.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorDashboardStock', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
