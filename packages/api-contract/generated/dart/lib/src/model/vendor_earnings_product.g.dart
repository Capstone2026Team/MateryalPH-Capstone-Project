// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_earnings_product.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorEarningsProduct extends VendorEarningsProduct {
  @override
  final String? listingId;
  @override
  final String name;
  @override
  final String category;
  @override
  final String? sku;
  @override
  final int orders;
  @override
  final int valueCentavos;
  @override
  final int vatCentavos;

  factory _$VendorEarningsProduct(
          [void Function(VendorEarningsProductBuilder)? updates]) =>
      (VendorEarningsProductBuilder()..update(updates))._build();

  _$VendorEarningsProduct._(
      {this.listingId,
      required this.name,
      required this.category,
      this.sku,
      required this.orders,
      required this.valueCentavos,
      required this.vatCentavos})
      : super._();
  @override
  VendorEarningsProduct rebuild(
          void Function(VendorEarningsProductBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorEarningsProductBuilder toBuilder() =>
      VendorEarningsProductBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorEarningsProduct &&
        listingId == other.listingId &&
        name == other.name &&
        category == other.category &&
        sku == other.sku &&
        orders == other.orders &&
        valueCentavos == other.valueCentavos &&
        vatCentavos == other.vatCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, valueCentavos.hashCode);
    _$hash = $jc(_$hash, vatCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorEarningsProduct')
          ..add('listingId', listingId)
          ..add('name', name)
          ..add('category', category)
          ..add('sku', sku)
          ..add('orders', orders)
          ..add('valueCentavos', valueCentavos)
          ..add('vatCentavos', vatCentavos))
        .toString();
  }
}

class VendorEarningsProductBuilder
    implements Builder<VendorEarningsProduct, VendorEarningsProductBuilder> {
  _$VendorEarningsProduct? _$v;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  int? _valueCentavos;
  int? get valueCentavos => _$this._valueCentavos;
  set valueCentavos(int? valueCentavos) =>
      _$this._valueCentavos = valueCentavos;

  int? _vatCentavos;
  int? get vatCentavos => _$this._vatCentavos;
  set vatCentavos(int? vatCentavos) => _$this._vatCentavos = vatCentavos;

  VendorEarningsProductBuilder() {
    VendorEarningsProduct._defaults(this);
  }

  VendorEarningsProductBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingId = $v.listingId;
      _name = $v.name;
      _category = $v.category;
      _sku = $v.sku;
      _orders = $v.orders;
      _valueCentavos = $v.valueCentavos;
      _vatCentavos = $v.vatCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorEarningsProduct other) {
    _$v = other as _$VendorEarningsProduct;
  }

  @override
  void update(void Function(VendorEarningsProductBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorEarningsProduct build() => _build();

  _$VendorEarningsProduct _build() {
    final _$result = _$v ??
        _$VendorEarningsProduct._(
          listingId: listingId,
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'VendorEarningsProduct', 'name'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'VendorEarningsProduct', 'category'),
          sku: sku,
          orders: BuiltValueNullFieldError.checkNotNull(
              orders, r'VendorEarningsProduct', 'orders'),
          valueCentavos: BuiltValueNullFieldError.checkNotNull(
              valueCentavos, r'VendorEarningsProduct', 'valueCentavos'),
          vatCentavos: BuiltValueNullFieldError.checkNotNull(
              vatCentavos, r'VendorEarningsProduct', 'vatCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
