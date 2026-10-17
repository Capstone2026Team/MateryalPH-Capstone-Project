// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_earnings_breakdown_sales.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorEarningsBreakdownSales extends VendorEarningsBreakdownSales {
  @override
  final int orders;
  @override
  final int materialsBeforeDiscountCentavos;
  @override
  final int vendorDiscountsCentavos;
  @override
  final int materialsAfterDiscountCentavos;
  @override
  final int deliveryCentavos;

  factory _$VendorEarningsBreakdownSales(
          [void Function(VendorEarningsBreakdownSalesBuilder)? updates]) =>
      (VendorEarningsBreakdownSalesBuilder()..update(updates))._build();

  _$VendorEarningsBreakdownSales._(
      {required this.orders,
      required this.materialsBeforeDiscountCentavos,
      required this.vendorDiscountsCentavos,
      required this.materialsAfterDiscountCentavos,
      required this.deliveryCentavos})
      : super._();
  @override
  VendorEarningsBreakdownSales rebuild(
          void Function(VendorEarningsBreakdownSalesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorEarningsBreakdownSalesBuilder toBuilder() =>
      VendorEarningsBreakdownSalesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorEarningsBreakdownSales &&
        orders == other.orders &&
        materialsBeforeDiscountCentavos ==
            other.materialsBeforeDiscountCentavos &&
        vendorDiscountsCentavos == other.vendorDiscountsCentavos &&
        materialsAfterDiscountCentavos ==
            other.materialsAfterDiscountCentavos &&
        deliveryCentavos == other.deliveryCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, materialsBeforeDiscountCentavos.hashCode);
    _$hash = $jc(_$hash, vendorDiscountsCentavos.hashCode);
    _$hash = $jc(_$hash, materialsAfterDiscountCentavos.hashCode);
    _$hash = $jc(_$hash, deliveryCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorEarningsBreakdownSales')
          ..add('orders', orders)
          ..add('materialsBeforeDiscountCentavos',
              materialsBeforeDiscountCentavos)
          ..add('vendorDiscountsCentavos', vendorDiscountsCentavos)
          ..add(
              'materialsAfterDiscountCentavos', materialsAfterDiscountCentavos)
          ..add('deliveryCentavos', deliveryCentavos))
        .toString();
  }
}

class VendorEarningsBreakdownSalesBuilder
    implements
        Builder<VendorEarningsBreakdownSales,
            VendorEarningsBreakdownSalesBuilder> {
  _$VendorEarningsBreakdownSales? _$v;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  int? _materialsBeforeDiscountCentavos;
  int? get materialsBeforeDiscountCentavos =>
      _$this._materialsBeforeDiscountCentavos;
  set materialsBeforeDiscountCentavos(int? materialsBeforeDiscountCentavos) =>
      _$this._materialsBeforeDiscountCentavos = materialsBeforeDiscountCentavos;

  int? _vendorDiscountsCentavos;
  int? get vendorDiscountsCentavos => _$this._vendorDiscountsCentavos;
  set vendorDiscountsCentavos(int? vendorDiscountsCentavos) =>
      _$this._vendorDiscountsCentavos = vendorDiscountsCentavos;

  int? _materialsAfterDiscountCentavos;
  int? get materialsAfterDiscountCentavos =>
      _$this._materialsAfterDiscountCentavos;
  set materialsAfterDiscountCentavos(int? materialsAfterDiscountCentavos) =>
      _$this._materialsAfterDiscountCentavos = materialsAfterDiscountCentavos;

  int? _deliveryCentavos;
  int? get deliveryCentavos => _$this._deliveryCentavos;
  set deliveryCentavos(int? deliveryCentavos) =>
      _$this._deliveryCentavos = deliveryCentavos;

  VendorEarningsBreakdownSalesBuilder() {
    VendorEarningsBreakdownSales._defaults(this);
  }

  VendorEarningsBreakdownSalesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orders = $v.orders;
      _materialsBeforeDiscountCentavos = $v.materialsBeforeDiscountCentavos;
      _vendorDiscountsCentavos = $v.vendorDiscountsCentavos;
      _materialsAfterDiscountCentavos = $v.materialsAfterDiscountCentavos;
      _deliveryCentavos = $v.deliveryCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorEarningsBreakdownSales other) {
    _$v = other as _$VendorEarningsBreakdownSales;
  }

  @override
  void update(void Function(VendorEarningsBreakdownSalesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorEarningsBreakdownSales build() => _build();

  _$VendorEarningsBreakdownSales _build() {
    final _$result = _$v ??
        _$VendorEarningsBreakdownSales._(
          orders: BuiltValueNullFieldError.checkNotNull(
              orders, r'VendorEarningsBreakdownSales', 'orders'),
          materialsBeforeDiscountCentavos:
              BuiltValueNullFieldError.checkNotNull(
                  materialsBeforeDiscountCentavos,
                  r'VendorEarningsBreakdownSales',
                  'materialsBeforeDiscountCentavos'),
          vendorDiscountsCentavos: BuiltValueNullFieldError.checkNotNull(
              vendorDiscountsCentavos,
              r'VendorEarningsBreakdownSales',
              'vendorDiscountsCentavos'),
          materialsAfterDiscountCentavos: BuiltValueNullFieldError.checkNotNull(
              materialsAfterDiscountCentavos,
              r'VendorEarningsBreakdownSales',
              'materialsAfterDiscountCentavos'),
          deliveryCentavos: BuiltValueNullFieldError.checkNotNull(
              deliveryCentavos,
              r'VendorEarningsBreakdownSales',
              'deliveryCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
