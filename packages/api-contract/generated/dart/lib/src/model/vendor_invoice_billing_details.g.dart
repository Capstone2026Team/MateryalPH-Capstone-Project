// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_invoice_billing_details.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorInvoiceBillingDetails extends VendorInvoiceBillingDetails {
  @override
  final String billingName;
  @override
  final String billingAddress;
  @override
  final String? tin;
  @override
  final String? tinMasked;

  factory _$VendorInvoiceBillingDetails(
          [void Function(VendorInvoiceBillingDetailsBuilder)? updates]) =>
      (VendorInvoiceBillingDetailsBuilder()..update(updates))._build();

  _$VendorInvoiceBillingDetails._(
      {required this.billingName,
      required this.billingAddress,
      this.tin,
      this.tinMasked})
      : super._();
  @override
  VendorInvoiceBillingDetails rebuild(
          void Function(VendorInvoiceBillingDetailsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorInvoiceBillingDetailsBuilder toBuilder() =>
      VendorInvoiceBillingDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorInvoiceBillingDetails &&
        billingName == other.billingName &&
        billingAddress == other.billingAddress &&
        tin == other.tin &&
        tinMasked == other.tinMasked;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, billingName.hashCode);
    _$hash = $jc(_$hash, billingAddress.hashCode);
    _$hash = $jc(_$hash, tin.hashCode);
    _$hash = $jc(_$hash, tinMasked.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorInvoiceBillingDetails')
          ..add('billingName', billingName)
          ..add('billingAddress', billingAddress)
          ..add('tin', tin)
          ..add('tinMasked', tinMasked))
        .toString();
  }
}

class VendorInvoiceBillingDetailsBuilder
    implements
        Builder<VendorInvoiceBillingDetails,
            VendorInvoiceBillingDetailsBuilder> {
  _$VendorInvoiceBillingDetails? _$v;

  String? _billingName;
  String? get billingName => _$this._billingName;
  set billingName(String? billingName) => _$this._billingName = billingName;

  String? _billingAddress;
  String? get billingAddress => _$this._billingAddress;
  set billingAddress(String? billingAddress) =>
      _$this._billingAddress = billingAddress;

  String? _tin;
  String? get tin => _$this._tin;
  set tin(String? tin) => _$this._tin = tin;

  String? _tinMasked;
  String? get tinMasked => _$this._tinMasked;
  set tinMasked(String? tinMasked) => _$this._tinMasked = tinMasked;

  VendorInvoiceBillingDetailsBuilder() {
    VendorInvoiceBillingDetails._defaults(this);
  }

  VendorInvoiceBillingDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _billingName = $v.billingName;
      _billingAddress = $v.billingAddress;
      _tin = $v.tin;
      _tinMasked = $v.tinMasked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorInvoiceBillingDetails other) {
    _$v = other as _$VendorInvoiceBillingDetails;
  }

  @override
  void update(void Function(VendorInvoiceBillingDetailsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorInvoiceBillingDetails build() => _build();

  _$VendorInvoiceBillingDetails _build() {
    final _$result = _$v ??
        _$VendorInvoiceBillingDetails._(
          billingName: BuiltValueNullFieldError.checkNotNull(
              billingName, r'VendorInvoiceBillingDetails', 'billingName'),
          billingAddress: BuiltValueNullFieldError.checkNotNull(
              billingAddress, r'VendorInvoiceBillingDetails', 'billingAddress'),
          tin: tin,
          tinMasked: tinMasked,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
