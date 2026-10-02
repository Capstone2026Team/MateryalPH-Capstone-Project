// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statement_payment_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StatementPaymentRequest extends StatementPaymentRequest {
  @override
  final String channelCode;
  @override
  final int? amountCentavos;

  factory _$StatementPaymentRequest(
          [void Function(StatementPaymentRequestBuilder)? updates]) =>
      (StatementPaymentRequestBuilder()..update(updates))._build();

  _$StatementPaymentRequest._({required this.channelCode, this.amountCentavos})
      : super._();
  @override
  StatementPaymentRequest rebuild(
          void Function(StatementPaymentRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatementPaymentRequestBuilder toBuilder() =>
      StatementPaymentRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatementPaymentRequest &&
        channelCode == other.channelCode &&
        amountCentavos == other.amountCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, channelCode.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StatementPaymentRequest')
          ..add('channelCode', channelCode)
          ..add('amountCentavos', amountCentavos))
        .toString();
  }
}

class StatementPaymentRequestBuilder
    implements
        Builder<StatementPaymentRequest, StatementPaymentRequestBuilder> {
  _$StatementPaymentRequest? _$v;

  String? _channelCode;
  String? get channelCode => _$this._channelCode;
  set channelCode(String? channelCode) => _$this._channelCode = channelCode;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  StatementPaymentRequestBuilder() {
    StatementPaymentRequest._defaults(this);
  }

  StatementPaymentRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _channelCode = $v.channelCode;
      _amountCentavos = $v.amountCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StatementPaymentRequest other) {
    _$v = other as _$StatementPaymentRequest;
  }

  @override
  void update(void Function(StatementPaymentRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatementPaymentRequest build() => _build();

  _$StatementPaymentRequest _build() {
    final _$result = _$v ??
        _$StatementPaymentRequest._(
          channelCode: BuiltValueNullFieldError.checkNotNull(
              channelCode, r'StatementPaymentRequest', 'channelCode'),
          amountCentavos: amountCentavos,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
