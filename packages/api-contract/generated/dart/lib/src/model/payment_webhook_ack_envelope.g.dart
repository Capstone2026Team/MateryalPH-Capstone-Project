// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_webhook_ack_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentWebhookAckEnvelope extends PaymentWebhookAckEnvelope {
  @override
  final PaymentWebhookAck data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$PaymentWebhookAckEnvelope(
          [void Function(PaymentWebhookAckEnvelopeBuilder)? updates]) =>
      (PaymentWebhookAckEnvelopeBuilder()..update(updates))._build();

  _$PaymentWebhookAckEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  PaymentWebhookAckEnvelope rebuild(
          void Function(PaymentWebhookAckEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentWebhookAckEnvelopeBuilder toBuilder() =>
      PaymentWebhookAckEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentWebhookAckEnvelope &&
        data == other.data &&
        meta == other.meta &&
        errors == other.errors;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, errors.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentWebhookAckEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class PaymentWebhookAckEnvelopeBuilder
    implements
        Builder<PaymentWebhookAckEnvelope, PaymentWebhookAckEnvelopeBuilder> {
  _$PaymentWebhookAckEnvelope? _$v;

  PaymentWebhookAckBuilder? _data;
  PaymentWebhookAckBuilder get data =>
      _$this._data ??= PaymentWebhookAckBuilder();
  set data(PaymentWebhookAckBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  PaymentWebhookAckEnvelopeBuilder() {
    PaymentWebhookAckEnvelope._defaults(this);
  }

  PaymentWebhookAckEnvelopeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _errors = $v.errors.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentWebhookAckEnvelope other) {
    _$v = other as _$PaymentWebhookAckEnvelope;
  }

  @override
  void update(void Function(PaymentWebhookAckEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentWebhookAckEnvelope build() => _build();

  _$PaymentWebhookAckEnvelope _build() {
    _$PaymentWebhookAckEnvelope _$result;
    try {
      _$result = _$v ??
          _$PaymentWebhookAckEnvelope._(
            data: data.build(),
            meta: meta.build(),
            errors: errors.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'errors';
        errors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PaymentWebhookAckEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
