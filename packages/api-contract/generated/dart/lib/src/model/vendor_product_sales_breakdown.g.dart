// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_sales_breakdown.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorProductSalesBreakdown extends VendorProductSalesBreakdown {
  @override
  final int productSalesCentavos;
  @override
  final int deliveryCentavos;
  @override
  final int refundsCentavos;
  @override
  final int netSalesCentavos;

  factory _$VendorProductSalesBreakdown(
          [void Function(VendorProductSalesBreakdownBuilder)? updates]) =>
      (VendorProductSalesBreakdownBuilder()..update(updates))._build();

  _$VendorProductSalesBreakdown._(
      {required this.productSalesCentavos,
      required this.deliveryCentavos,
      required this.refundsCentavos,
      required this.netSalesCentavos})
      : super._();
  @override
  VendorProductSalesBreakdown rebuild(
          void Function(VendorProductSalesBreakdownBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductSalesBreakdownBuilder toBuilder() =>
      VendorProductSalesBreakdownBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductSalesBreakdown &&
        productSalesCentavos == other.productSalesCentavos &&
        deliveryCentavos == other.deliveryCentavos &&
        refundsCentavos == other.refundsCentavos &&
        netSalesCentavos == other.netSalesCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productSalesCentavos.hashCode);
    _$hash = $jc(_$hash, deliveryCentavos.hashCode);
    _$hash = $jc(_$hash, refundsCentavos.hashCode);
    _$hash = $jc(_$hash, netSalesCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorProductSalesBreakdown')
          ..add('productSalesCentavos', productSalesCentavos)
          ..add('deliveryCentavos', deliveryCentavos)
          ..add('refundsCentavos', refundsCentavos)
          ..add('netSalesCentavos', netSalesCentavos))
        .toString();
  }
}

class VendorProductSalesBreakdownBuilder
    implements
        Builder<VendorProductSalesBreakdown,
            VendorProductSalesBreakdownBuilder> {
  _$VendorProductSalesBreakdown? _$v;

  int? _productSalesCentavos;
  int? get productSalesCentavos => _$this._productSalesCentavos;
  set productSalesCentavos(int? productSalesCentavos) =>
      _$this._productSalesCentavos = productSalesCentavos;

  int? _deliveryCentavos;
  int? get deliveryCentavos => _$this._deliveryCentavos;
  set deliveryCentavos(int? deliveryCentavos) =>
      _$this._deliveryCentavos = deliveryCentavos;

  int? _refundsCentavos;
  int? get refundsCentavos => _$this._refundsCentavos;
  set refundsCentavos(int? refundsCentavos) =>
      _$this._refundsCentavos = refundsCentavos;

  int? _netSalesCentavos;
  int? get netSalesCentavos => _$this._netSalesCentavos;
  set netSalesCentavos(int? netSalesCentavos) =>
      _$this._netSalesCentavos = netSalesCentavos;

  VendorProductSalesBreakdownBuilder() {
    VendorProductSalesBreakdown._defaults(this);
  }

  VendorProductSalesBreakdownBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productSalesCentavos = $v.productSalesCentavos;
      _deliveryCentavos = $v.deliveryCentavos;
      _refundsCentavos = $v.refundsCentavos;
      _netSalesCentavos = $v.netSalesCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorProductSalesBreakdown other) {
    _$v = other as _$VendorProductSalesBreakdown;
  }

  @override
  void update(void Function(VendorProductSalesBreakdownBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductSalesBreakdown build() => _build();

  _$VendorProductSalesBreakdown _build() {
    final _$result = _$v ??
        _$VendorProductSalesBreakdown._(
          productSalesCentavos: BuiltValueNullFieldError.checkNotNull(
              productSalesCentavos,
              r'VendorProductSalesBreakdown',
              'productSalesCentavos'),
          deliveryCentavos: BuiltValueNullFieldError.checkNotNull(
              deliveryCentavos,
              r'VendorProductSalesBreakdown',
              'deliveryCentavos'),
          refundsCentavos: BuiltValueNullFieldError.checkNotNull(
              refundsCentavos,
              r'VendorProductSalesBreakdown',
              'refundsCentavos'),
          netSalesCentavos: BuiltValueNullFieldError.checkNotNull(
              netSalesCentavos,
              r'VendorProductSalesBreakdown',
              'netSalesCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
