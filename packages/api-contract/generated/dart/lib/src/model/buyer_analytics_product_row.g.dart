// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_analytics_product_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

abstract class BuyerAnalyticsProductRowBuilder {
  void replace(BuyerAnalyticsProductRow other);
  void update(void Function(BuyerAnalyticsProductRowBuilder) updates);
  AnalyticsMaterialRefBuilder get material;
  set material(AnalyticsMaterialRefBuilder? material);

  AnalyticsCategoryRefBuilder get category;
  set category(AnalyticsCategoryRefBuilder? category);

  bool? get regulated;
  set regulated(bool? regulated);

  AnalyticsUnitBuilder get unit;
  set unit(AnalyticsUnitBuilder? unit);

  int? get variantCount;
  set variantCount(int? variantCount);

  int? get vendorCount;
  set vendorCount(int? vendorCount);

  AnalyticsPriceRangeBuilder get price;
  set price(AnalyticsPriceRangeBuilder? price);
}

class _$$BuyerAnalyticsProductRow extends $BuyerAnalyticsProductRow {
  @override
  final AnalyticsMaterialRef material;
  @override
  final AnalyticsCategoryRef category;
  @override
  final bool regulated;
  @override
  final AnalyticsUnit unit;
  @override
  final int variantCount;
  @override
  final int vendorCount;
  @override
  final AnalyticsPriceRange price;

  factory _$$BuyerAnalyticsProductRow(
          [void Function($BuyerAnalyticsProductRowBuilder)? updates]) =>
      ($BuyerAnalyticsProductRowBuilder()..update(updates))._build();

  _$$BuyerAnalyticsProductRow._(
      {required this.material,
      required this.category,
      required this.regulated,
      required this.unit,
      required this.variantCount,
      required this.vendorCount,
      required this.price})
      : super._();
  @override
  $BuyerAnalyticsProductRow rebuild(
          void Function($BuyerAnalyticsProductRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  $BuyerAnalyticsProductRowBuilder toBuilder() =>
      $BuyerAnalyticsProductRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is $BuyerAnalyticsProductRow &&
        material == other.material &&
        category == other.category &&
        regulated == other.regulated &&
        unit == other.unit &&
        variantCount == other.variantCount &&
        vendorCount == other.vendorCount &&
        price == other.price;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, material.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, regulated.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jc(_$hash, variantCount.hashCode);
    _$hash = $jc(_$hash, vendorCount.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'$BuyerAnalyticsProductRow')
          ..add('material', material)
          ..add('category', category)
          ..add('regulated', regulated)
          ..add('unit', unit)
          ..add('variantCount', variantCount)
          ..add('vendorCount', vendorCount)
          ..add('price', price))
        .toString();
  }
}

class $BuyerAnalyticsProductRowBuilder
    implements
        Builder<$BuyerAnalyticsProductRow, $BuyerAnalyticsProductRowBuilder>,
        BuyerAnalyticsProductRowBuilder {
  _$$BuyerAnalyticsProductRow? _$v;

  AnalyticsMaterialRefBuilder? _material;
  AnalyticsMaterialRefBuilder get material =>
      _$this._material ??= AnalyticsMaterialRefBuilder();
  set material(covariant AnalyticsMaterialRefBuilder? material) =>
      _$this._material = material;

  AnalyticsCategoryRefBuilder? _category;
  AnalyticsCategoryRefBuilder get category =>
      _$this._category ??= AnalyticsCategoryRefBuilder();
  set category(covariant AnalyticsCategoryRefBuilder? category) =>
      _$this._category = category;

  bool? _regulated;
  bool? get regulated => _$this._regulated;
  set regulated(covariant bool? regulated) => _$this._regulated = regulated;

  AnalyticsUnitBuilder? _unit;
  AnalyticsUnitBuilder get unit => _$this._unit ??= AnalyticsUnitBuilder();
  set unit(covariant AnalyticsUnitBuilder? unit) => _$this._unit = unit;

  int? _variantCount;
  int? get variantCount => _$this._variantCount;
  set variantCount(covariant int? variantCount) =>
      _$this._variantCount = variantCount;

  int? _vendorCount;
  int? get vendorCount => _$this._vendorCount;
  set vendorCount(covariant int? vendorCount) =>
      _$this._vendorCount = vendorCount;

  AnalyticsPriceRangeBuilder? _price;
  AnalyticsPriceRangeBuilder get price =>
      _$this._price ??= AnalyticsPriceRangeBuilder();
  set price(covariant AnalyticsPriceRangeBuilder? price) =>
      _$this._price = price;

  $BuyerAnalyticsProductRowBuilder() {
    $BuyerAnalyticsProductRow._defaults(this);
  }

  $BuyerAnalyticsProductRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _material = $v.material.toBuilder();
      _category = $v.category.toBuilder();
      _regulated = $v.regulated;
      _unit = $v.unit.toBuilder();
      _variantCount = $v.variantCount;
      _vendorCount = $v.vendorCount;
      _price = $v.price.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant $BuyerAnalyticsProductRow other) {
    _$v = other as _$$BuyerAnalyticsProductRow;
  }

  @override
  void update(void Function($BuyerAnalyticsProductRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  $BuyerAnalyticsProductRow build() => _build();

  _$$BuyerAnalyticsProductRow _build() {
    _$$BuyerAnalyticsProductRow _$result;
    try {
      _$result = _$v ??
          _$$BuyerAnalyticsProductRow._(
            material: material.build(),
            category: category.build(),
            regulated: BuiltValueNullFieldError.checkNotNull(
                regulated, r'$BuyerAnalyticsProductRow', 'regulated'),
            unit: unit.build(),
            variantCount: BuiltValueNullFieldError.checkNotNull(
                variantCount, r'$BuyerAnalyticsProductRow', 'variantCount'),
            vendorCount: BuiltValueNullFieldError.checkNotNull(
                vendorCount, r'$BuyerAnalyticsProductRow', 'vendorCount'),
            price: price.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'material';
        material.build();
        _$failedField = 'category';
        category.build();

        _$failedField = 'unit';
        unit.build();

        _$failedField = 'price';
        price.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'$BuyerAnalyticsProductRow', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
