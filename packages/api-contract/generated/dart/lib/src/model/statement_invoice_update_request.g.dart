// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statement_invoice_update_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StatementInvoiceUpdateRequest extends StatementInvoiceUpdateRequest {
  @override
  final int lockVersion;
  @override
  final String invoiceHeading;
  @override
  final String? invoiceMessage;

  factory _$StatementInvoiceUpdateRequest(
          [void Function(StatementInvoiceUpdateRequestBuilder)? updates]) =>
      (StatementInvoiceUpdateRequestBuilder()..update(updates))._build();

  _$StatementInvoiceUpdateRequest._(
      {required this.lockVersion,
      required this.invoiceHeading,
      this.invoiceMessage})
      : super._();
  @override
  StatementInvoiceUpdateRequest rebuild(
          void Function(StatementInvoiceUpdateRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatementInvoiceUpdateRequestBuilder toBuilder() =>
      StatementInvoiceUpdateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatementInvoiceUpdateRequest &&
        lockVersion == other.lockVersion &&
        invoiceHeading == other.invoiceHeading &&
        invoiceMessage == other.invoiceMessage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, invoiceHeading.hashCode);
    _$hash = $jc(_$hash, invoiceMessage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StatementInvoiceUpdateRequest')
          ..add('lockVersion', lockVersion)
          ..add('invoiceHeading', invoiceHeading)
          ..add('invoiceMessage', invoiceMessage))
        .toString();
  }
}

class StatementInvoiceUpdateRequestBuilder
    implements
        Builder<StatementInvoiceUpdateRequest,
            StatementInvoiceUpdateRequestBuilder> {
  _$StatementInvoiceUpdateRequest? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _invoiceHeading;
  String? get invoiceHeading => _$this._invoiceHeading;
  set invoiceHeading(String? invoiceHeading) =>
      _$this._invoiceHeading = invoiceHeading;

  String? _invoiceMessage;
  String? get invoiceMessage => _$this._invoiceMessage;
  set invoiceMessage(String? invoiceMessage) =>
      _$this._invoiceMessage = invoiceMessage;

  StatementInvoiceUpdateRequestBuilder() {
    StatementInvoiceUpdateRequest._defaults(this);
  }

  StatementInvoiceUpdateRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _invoiceHeading = $v.invoiceHeading;
      _invoiceMessage = $v.invoiceMessage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StatementInvoiceUpdateRequest other) {
    _$v = other as _$StatementInvoiceUpdateRequest;
  }

  @override
  void update(void Function(StatementInvoiceUpdateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatementInvoiceUpdateRequest build() => _build();

  _$StatementInvoiceUpdateRequest _build() {
    final _$result = _$v ??
        _$StatementInvoiceUpdateRequest._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'StatementInvoiceUpdateRequest', 'lockVersion'),
          invoiceHeading: BuiltValueNullFieldError.checkNotNull(invoiceHeading,
              r'StatementInvoiceUpdateRequest', 'invoiceHeading'),
          invoiceMessage: invoiceMessage,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
