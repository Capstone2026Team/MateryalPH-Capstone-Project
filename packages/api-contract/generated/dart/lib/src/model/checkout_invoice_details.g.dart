// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_invoice_details.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckoutInvoiceDetails extends CheckoutInvoiceDetails {
  @override
  final String billingName;
  @override
  final String billingAddress;
  @override
  final String? tin;

  factory _$CheckoutInvoiceDetails(
          [void Function(CheckoutInvoiceDetailsBuilder)? updates]) =>
      (CheckoutInvoiceDetailsBuilder()..update(updates))._build();

  _$CheckoutInvoiceDetails._(
      {required this.billingName, required this.billingAddress, this.tin})
      : super._();
  @override
  CheckoutInvoiceDetails rebuild(
          void Function(CheckoutInvoiceDetailsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutInvoiceDetailsBuilder toBuilder() =>
      CheckoutInvoiceDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutInvoiceDetails &&
        billingName == other.billingName &&
        billingAddress == other.billingAddress &&
        tin == other.tin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, billingName.hashCode);
    _$hash = $jc(_$hash, billingAddress.hashCode);
    _$hash = $jc(_$hash, tin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckoutInvoiceDetails')
          ..add('billingName', billingName)
          ..add('billingAddress', billingAddress)
          ..add('tin', tin))
        .toString();
  }
}

class CheckoutInvoiceDetailsBuilder
    implements Builder<CheckoutInvoiceDetails, CheckoutInvoiceDetailsBuilder> {
  _$CheckoutInvoiceDetails? _$v;

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

  CheckoutInvoiceDetailsBuilder() {
    CheckoutInvoiceDetails._defaults(this);
  }

  CheckoutInvoiceDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _billingName = $v.billingName;
      _billingAddress = $v.billingAddress;
      _tin = $v.tin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutInvoiceDetails other) {
    _$v = other as _$CheckoutInvoiceDetails;
  }

  @override
  void update(void Function(CheckoutInvoiceDetailsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutInvoiceDetails build() => _build();

  _$CheckoutInvoiceDetails _build() {
    final _$result = _$v ??
        _$CheckoutInvoiceDetails._(
          billingName: BuiltValueNullFieldError.checkNotNull(
              billingName, r'CheckoutInvoiceDetails', 'billingName'),
          billingAddress: BuiltValueNullFieldError.checkNotNull(
              billingAddress, r'CheckoutInvoiceDetails', 'billingAddress'),
          tin: tin,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
