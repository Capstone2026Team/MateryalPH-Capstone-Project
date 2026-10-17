// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_orders_products_segments_points_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardOrdersProductsSegmentsPointsInner
    extends VendorDashboardOrdersProductsSegmentsPointsInner {
  @override
  final String name;
  @override
  final int orders;
  @override
  final int buyers;
  @override
  final String segment;

  factory _$VendorDashboardOrdersProductsSegmentsPointsInner(
          [void Function(
                  VendorDashboardOrdersProductsSegmentsPointsInnerBuilder)?
              updates]) =>
      (VendorDashboardOrdersProductsSegmentsPointsInnerBuilder()
            ..update(updates))
          ._build();

  _$VendorDashboardOrdersProductsSegmentsPointsInner._(
      {required this.name,
      required this.orders,
      required this.buyers,
      required this.segment})
      : super._();
  @override
  VendorDashboardOrdersProductsSegmentsPointsInner rebuild(
          void Function(VendorDashboardOrdersProductsSegmentsPointsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardOrdersProductsSegmentsPointsInnerBuilder toBuilder() =>
      VendorDashboardOrdersProductsSegmentsPointsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardOrdersProductsSegmentsPointsInner &&
        name == other.name &&
        orders == other.orders &&
        buyers == other.buyers &&
        segment == other.segment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, buyers.hashCode);
    _$hash = $jc(_$hash, segment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VendorDashboardOrdersProductsSegmentsPointsInner')
          ..add('name', name)
          ..add('orders', orders)
          ..add('buyers', buyers)
          ..add('segment', segment))
        .toString();
  }
}

class VendorDashboardOrdersProductsSegmentsPointsInnerBuilder
    implements
        Builder<VendorDashboardOrdersProductsSegmentsPointsInner,
            VendorDashboardOrdersProductsSegmentsPointsInnerBuilder> {
  _$VendorDashboardOrdersProductsSegmentsPointsInner? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  int? _buyers;
  int? get buyers => _$this._buyers;
  set buyers(int? buyers) => _$this._buyers = buyers;

  String? _segment;
  String? get segment => _$this._segment;
  set segment(String? segment) => _$this._segment = segment;

  VendorDashboardOrdersProductsSegmentsPointsInnerBuilder() {
    VendorDashboardOrdersProductsSegmentsPointsInner._defaults(this);
  }

  VendorDashboardOrdersProductsSegmentsPointsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _orders = $v.orders;
      _buyers = $v.buyers;
      _segment = $v.segment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardOrdersProductsSegmentsPointsInner other) {
    _$v = other as _$VendorDashboardOrdersProductsSegmentsPointsInner;
  }

  @override
  void update(
      void Function(VendorDashboardOrdersProductsSegmentsPointsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardOrdersProductsSegmentsPointsInner build() => _build();

  _$VendorDashboardOrdersProductsSegmentsPointsInner _build() {
    final _$result = _$v ??
        _$VendorDashboardOrdersProductsSegmentsPointsInner._(
          name: BuiltValueNullFieldError.checkNotNull(name,
              r'VendorDashboardOrdersProductsSegmentsPointsInner', 'name'),
          orders: BuiltValueNullFieldError.checkNotNull(orders,
              r'VendorDashboardOrdersProductsSegmentsPointsInner', 'orders'),
          buyers: BuiltValueNullFieldError.checkNotNull(buyers,
              r'VendorDashboardOrdersProductsSegmentsPointsInner', 'buyers'),
          segment: BuiltValueNullFieldError.checkNotNull(segment,
              r'VendorDashboardOrdersProductsSegmentsPointsInner', 'segment'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
