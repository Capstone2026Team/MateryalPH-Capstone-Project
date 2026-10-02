// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_create_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentCreateRequest extends PaymentCreateRequest {
  @override
  final String channelCode;
  @override
  final int expectedTotalCentavos;

  factory _$PaymentCreateRequest(
          [void Function(PaymentCreateRequestBuilder)? updates]) =>
      (PaymentCreateRequestBuilder()..update(updates))._build();

  _$PaymentCreateRequest._(
      {required this.channelCode, required this.expectedTotalCentavos})
      : super._();
  @override
  PaymentCreateRequest rebuild(
          void Function(PaymentCreateRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentCreateRequestBuilder toBuilder() =>
      PaymentCreateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentCreateRequest &&
        channelCode == other.channelCode &&
        expectedTotalCentavos == other.expectedTotalCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, channelCode.hashCode);
    _$hash = $jc(_$hash, expectedTotalCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentCreateRequest')
          ..add('channelCode', channelCode)
          ..add('expectedTotalCentavos', expectedTotalCentavos))
        .toString();
  }
}

class PaymentCreateRequestBuilder
    implements Builder<PaymentCreateRequest, PaymentCreateRequestBuilder> {
  _$PaymentCreateRequest? _$v;

  String? _channelCode;
  String? get channelCode => _$this._channelCode;
  set channelCode(String? channelCode) => _$this._channelCode = channelCode;

  int? _expectedTotalCentavos;
  int? get expectedTotalCentavos => _$this._expectedTotalCentavos;
  set expectedTotalCentavos(int? expectedTotalCentavos) =>
      _$this._expectedTotalCentavos = expectedTotalCentavos;

  PaymentCreateRequestBuilder() {
    PaymentCreateRequest._defaults(this);
  }

  PaymentCreateRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _channelCode = $v.channelCode;
      _expectedTotalCentavos = $v.expectedTotalCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentCreateRequest other) {
    _$v = other as _$PaymentCreateRequest;
  }

  @override
  void update(void Function(PaymentCreateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentCreateRequest build() => _build();

  _$PaymentCreateRequest _build() {
    final _$result = _$v ??
        _$PaymentCreateRequest._(
          channelCode: BuiltValueNullFieldError.checkNotNull(
              channelCode, r'PaymentCreateRequest', 'channelCode'),
          expectedTotalCentavos: BuiltValueNullFieldError.checkNotNull(
              expectedTotalCentavos,
              r'PaymentCreateRequest',
              'expectedTotalCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
