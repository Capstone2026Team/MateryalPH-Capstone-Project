// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_product.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardProduct extends VendorDashboardProduct {
  @override
  final String name;
  @override
  final String category;
  @override
  final int orders;
  @override
  final int buyers;
  @override
  final int? valueCentavos;

  factory _$VendorDashboardProduct(
          [void Function(VendorDashboardProductBuilder)? updates]) =>
      (VendorDashboardProductBuilder()..update(updates))._build();

  _$VendorDashboardProduct._(
      {required this.name,
      required this.category,
      required this.orders,
      required this.buyers,
      this.valueCentavos})
      : super._();
  @override
  VendorDashboardProduct rebuild(
          void Function(VendorDashboardProductBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardProductBuilder toBuilder() =>
      VendorDashboardProductBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardProduct &&
        name == other.name &&
        category == other.category &&
        orders == other.orders &&
        buyers == other.buyers &&
        valueCentavos == other.valueCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, buyers.hashCode);
    _$hash = $jc(_$hash, valueCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardProduct')
          ..add('name', name)
          ..add('category', category)
          ..add('orders', orders)
          ..add('buyers', buyers)
          ..add('valueCentavos', valueCentavos))
        .toString();
  }
}

class VendorDashboardProductBuilder
    implements Builder<VendorDashboardProduct, VendorDashboardProductBuilder> {
  _$VendorDashboardProduct? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  int? _buyers;
  int? get buyers => _$this._buyers;
  set buyers(int? buyers) => _$this._buyers = buyers;

  int? _valueCentavos;
  int? get valueCentavos => _$this._valueCentavos;
  set valueCentavos(int? valueCentavos) =>
      _$this._valueCentavos = valueCentavos;

  VendorDashboardProductBuilder() {
    VendorDashboardProduct._defaults(this);
  }

  VendorDashboardProductBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _category = $v.category;
      _orders = $v.orders;
      _buyers = $v.buyers;
      _valueCentavos = $v.valueCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardProduct other) {
    _$v = other as _$VendorDashboardProduct;
  }

  @override
  void update(void Function(VendorDashboardProductBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardProduct build() => _build();

  _$VendorDashboardProduct _build() {
    final _$result = _$v ??
        _$VendorDashboardProduct._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'VendorDashboardProduct', 'name'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'VendorDashboardProduct', 'category'),
          orders: BuiltValueNullFieldError.checkNotNull(
              orders, r'VendorDashboardProduct', 'orders'),
          buyers: BuiltValueNullFieldError.checkNotNull(
              buyers, r'VendorDashboardProduct', 'buyers'),
          valueCentavos: valueCentavos,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
