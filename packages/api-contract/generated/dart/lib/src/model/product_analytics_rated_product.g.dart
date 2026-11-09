// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_analytics_rated_product.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductAnalyticsRatedProduct extends ProductAnalyticsRatedProduct {
  @override
  final String listingId;
  @override
  final String name;
  @override
  final String category;
  @override
  final String average;
  @override
  final int count;

  factory _$ProductAnalyticsRatedProduct(
          [void Function(ProductAnalyticsRatedProductBuilder)? updates]) =>
      (ProductAnalyticsRatedProductBuilder()..update(updates))._build();

  _$ProductAnalyticsRatedProduct._(
      {required this.listingId,
      required this.name,
      required this.category,
      required this.average,
      required this.count})
      : super._();
  @override
  ProductAnalyticsRatedProduct rebuild(
          void Function(ProductAnalyticsRatedProductBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductAnalyticsRatedProductBuilder toBuilder() =>
      ProductAnalyticsRatedProductBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductAnalyticsRatedProduct &&
        listingId == other.listingId &&
        name == other.name &&
        category == other.category &&
        average == other.average &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, average.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductAnalyticsRatedProduct')
          ..add('listingId', listingId)
          ..add('name', name)
          ..add('category', category)
          ..add('average', average)
          ..add('count', count))
        .toString();
  }
}

class ProductAnalyticsRatedProductBuilder
    implements
        Builder<ProductAnalyticsRatedProduct,
            ProductAnalyticsRatedProductBuilder> {
  _$ProductAnalyticsRatedProduct? _$v;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _average;
  String? get average => _$this._average;
  set average(String? average) => _$this._average = average;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  ProductAnalyticsRatedProductBuilder() {
    ProductAnalyticsRatedProduct._defaults(this);
  }

  ProductAnalyticsRatedProductBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingId = $v.listingId;
      _name = $v.name;
      _category = $v.category;
      _average = $v.average;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductAnalyticsRatedProduct other) {
    _$v = other as _$ProductAnalyticsRatedProduct;
  }

  @override
  void update(void Function(ProductAnalyticsRatedProductBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductAnalyticsRatedProduct build() => _build();

  _$ProductAnalyticsRatedProduct _build() {
    final _$result = _$v ??
        _$ProductAnalyticsRatedProduct._(
          listingId: BuiltValueNullFieldError.checkNotNull(
              listingId, r'ProductAnalyticsRatedProduct', 'listingId'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ProductAnalyticsRatedProduct', 'name'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'ProductAnalyticsRatedProduct', 'category'),
          average: BuiltValueNullFieldError.checkNotNull(
              average, r'ProductAnalyticsRatedProduct', 'average'),
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'ProductAnalyticsRatedProduct', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
