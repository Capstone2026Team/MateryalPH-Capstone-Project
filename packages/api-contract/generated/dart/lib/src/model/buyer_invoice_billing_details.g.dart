// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_invoice_billing_details.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerInvoiceBillingDetails extends BuyerInvoiceBillingDetails {
  @override
  final String billingName;
  @override
  final String billingAddress;
  @override
  final String? tinMasked;
  @override
  final int lockVersion;

  factory _$BuyerInvoiceBillingDetails(
          [void Function(BuyerInvoiceBillingDetailsBuilder)? updates]) =>
      (BuyerInvoiceBillingDetailsBuilder()..update(updates))._build();

  _$BuyerInvoiceBillingDetails._(
      {required this.billingName,
      required this.billingAddress,
      this.tinMasked,
      required this.lockVersion})
      : super._();
  @override
  BuyerInvoiceBillingDetails rebuild(
          void Function(BuyerInvoiceBillingDetailsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerInvoiceBillingDetailsBuilder toBuilder() =>
      BuyerInvoiceBillingDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerInvoiceBillingDetails &&
        billingName == other.billingName &&
        billingAddress == other.billingAddress &&
        tinMasked == other.tinMasked &&
        lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, billingName.hashCode);
    _$hash = $jc(_$hash, billingAddress.hashCode);
    _$hash = $jc(_$hash, tinMasked.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerInvoiceBillingDetails')
          ..add('billingName', billingName)
          ..add('billingAddress', billingAddress)
          ..add('tinMasked', tinMasked)
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class BuyerInvoiceBillingDetailsBuilder
    implements
        Builder<BuyerInvoiceBillingDetails, BuyerInvoiceBillingDetailsBuilder> {
  _$BuyerInvoiceBillingDetails? _$v;

  String? _billingName;
  String? get billingName => _$this._billingName;
  set billingName(String? billingName) => _$this._billingName = billingName;

  String? _billingAddress;
  String? get billingAddress => _$this._billingAddress;
  set billingAddress(String? billingAddress) =>
      _$this._billingAddress = billingAddress;

  String? _tinMasked;
  String? get tinMasked => _$this._tinMasked;
  set tinMasked(String? tinMasked) => _$this._tinMasked = tinMasked;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  BuyerInvoiceBillingDetailsBuilder() {
    BuyerInvoiceBillingDetails._defaults(this);
  }

  BuyerInvoiceBillingDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _billingName = $v.billingName;
      _billingAddress = $v.billingAddress;
      _tinMasked = $v.tinMasked;
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerInvoiceBillingDetails other) {
    _$v = other as _$BuyerInvoiceBillingDetails;
  }

  @override
  void update(void Function(BuyerInvoiceBillingDetailsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerInvoiceBillingDetails build() => _build();

  _$BuyerInvoiceBillingDetails _build() {
    final _$result = _$v ??
        _$BuyerInvoiceBillingDetails._(
          billingName: BuiltValueNullFieldError.checkNotNull(
              billingName, r'BuyerInvoiceBillingDetails', 'billingName'),
          billingAddress: BuiltValueNullFieldError.checkNotNull(
              billingAddress, r'BuyerInvoiceBillingDetails', 'billingAddress'),
          tinMasked: tinMasked,
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'BuyerInvoiceBillingDetails', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
