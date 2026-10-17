// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_billing_details_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InvoiceBillingDetailsRequest extends InvoiceBillingDetailsRequest {
  @override
  final String billingName;
  @override
  final String billingAddress;
  @override
  final String? tin;
  @override
  final int? lockVersion;

  factory _$InvoiceBillingDetailsRequest(
          [void Function(InvoiceBillingDetailsRequestBuilder)? updates]) =>
      (InvoiceBillingDetailsRequestBuilder()..update(updates))._build();

  _$InvoiceBillingDetailsRequest._(
      {required this.billingName,
      required this.billingAddress,
      this.tin,
      this.lockVersion})
      : super._();
  @override
  InvoiceBillingDetailsRequest rebuild(
          void Function(InvoiceBillingDetailsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoiceBillingDetailsRequestBuilder toBuilder() =>
      InvoiceBillingDetailsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoiceBillingDetailsRequest &&
        billingName == other.billingName &&
        billingAddress == other.billingAddress &&
        tin == other.tin &&
        lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, billingName.hashCode);
    _$hash = $jc(_$hash, billingAddress.hashCode);
    _$hash = $jc(_$hash, tin.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvoiceBillingDetailsRequest')
          ..add('billingName', billingName)
          ..add('billingAddress', billingAddress)
          ..add('tin', tin)
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class InvoiceBillingDetailsRequestBuilder
    implements
        Builder<InvoiceBillingDetailsRequest,
            InvoiceBillingDetailsRequestBuilder> {
  _$InvoiceBillingDetailsRequest? _$v;

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

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  InvoiceBillingDetailsRequestBuilder() {
    InvoiceBillingDetailsRequest._defaults(this);
  }

  InvoiceBillingDetailsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _billingName = $v.billingName;
      _billingAddress = $v.billingAddress;
      _tin = $v.tin;
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvoiceBillingDetailsRequest other) {
    _$v = other as _$InvoiceBillingDetailsRequest;
  }

  @override
  void update(void Function(InvoiceBillingDetailsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoiceBillingDetailsRequest build() => _build();

  _$InvoiceBillingDetailsRequest _build() {
    final _$result = _$v ??
        _$InvoiceBillingDetailsRequest._(
          billingName: BuiltValueNullFieldError.checkNotNull(
              billingName, r'InvoiceBillingDetailsRequest', 'billingName'),
          billingAddress: BuiltValueNullFieldError.checkNotNull(billingAddress,
              r'InvoiceBillingDetailsRequest', 'billingAddress'),
          tin: tin,
          lockVersion: lockVersion,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
