// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_analytics_category_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerAnalyticsCategorySummary extends BuyerAnalyticsCategorySummary {
  @override
  final AnalyticsCategoryRef category;
  @override
  final int productCount;
  @override
  final int variantCount;

  factory _$BuyerAnalyticsCategorySummary(
          [void Function(BuyerAnalyticsCategorySummaryBuilder)? updates]) =>
      (BuyerAnalyticsCategorySummaryBuilder()..update(updates))._build();

  _$BuyerAnalyticsCategorySummary._(
      {required this.category,
      required this.productCount,
      required this.variantCount})
      : super._();
  @override
  BuyerAnalyticsCategorySummary rebuild(
          void Function(BuyerAnalyticsCategorySummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerAnalyticsCategorySummaryBuilder toBuilder() =>
      BuyerAnalyticsCategorySummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerAnalyticsCategorySummary &&
        category == other.category &&
        productCount == other.productCount &&
        variantCount == other.variantCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, productCount.hashCode);
    _$hash = $jc(_$hash, variantCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerAnalyticsCategorySummary')
          ..add('category', category)
          ..add('productCount', productCount)
          ..add('variantCount', variantCount))
        .toString();
  }
}

class BuyerAnalyticsCategorySummaryBuilder
    implements
        Builder<BuyerAnalyticsCategorySummary,
            BuyerAnalyticsCategorySummaryBuilder> {
  _$BuyerAnalyticsCategorySummary? _$v;

  AnalyticsCategoryRefBuilder? _category;
  AnalyticsCategoryRefBuilder get category =>
      _$this._category ??= AnalyticsCategoryRefBuilder();
  set category(AnalyticsCategoryRefBuilder? category) =>
      _$this._category = category;

  int? _productCount;
  int? get productCount => _$this._productCount;
  set productCount(int? productCount) => _$this._productCount = productCount;

  int? _variantCount;
  int? get variantCount => _$this._variantCount;
  set variantCount(int? variantCount) => _$this._variantCount = variantCount;

  BuyerAnalyticsCategorySummaryBuilder() {
    BuyerAnalyticsCategorySummary._defaults(this);
  }

  BuyerAnalyticsCategorySummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category.toBuilder();
      _productCount = $v.productCount;
      _variantCount = $v.variantCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerAnalyticsCategorySummary other) {
    _$v = other as _$BuyerAnalyticsCategorySummary;
  }

  @override
  void update(void Function(BuyerAnalyticsCategorySummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerAnalyticsCategorySummary build() => _build();

  _$BuyerAnalyticsCategorySummary _build() {
    _$BuyerAnalyticsCategorySummary _$result;
    try {
      _$result = _$v ??
          _$BuyerAnalyticsCategorySummary._(
            category: category.build(),
            productCount: BuiltValueNullFieldError.checkNotNull(
                productCount, r'BuyerAnalyticsCategorySummary', 'productCount'),
            variantCount: BuiltValueNullFieldError.checkNotNull(
                variantCount, r'BuyerAnalyticsCategorySummary', 'variantCount'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'category';
        category.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerAnalyticsCategorySummary', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
