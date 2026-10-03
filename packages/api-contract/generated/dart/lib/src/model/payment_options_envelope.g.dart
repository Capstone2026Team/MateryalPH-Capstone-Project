// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_options_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentOptionsEnvelope extends PaymentOptionsEnvelope {
  @override
  final PaymentOptions data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$PaymentOptionsEnvelope(
          [void Function(PaymentOptionsEnvelopeBuilder)? updates]) =>
      (PaymentOptionsEnvelopeBuilder()..update(updates))._build();

  _$PaymentOptionsEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  PaymentOptionsEnvelope rebuild(
          void Function(PaymentOptionsEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentOptionsEnvelopeBuilder toBuilder() =>
      PaymentOptionsEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentOptionsEnvelope &&
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
    return (newBuiltValueToStringHelper(r'PaymentOptionsEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class PaymentOptionsEnvelopeBuilder
    implements Builder<PaymentOptionsEnvelope, PaymentOptionsEnvelopeBuilder> {
  _$PaymentOptionsEnvelope? _$v;

  PaymentOptionsBuilder? _data;
  PaymentOptionsBuilder get data => _$this._data ??= PaymentOptionsBuilder();
  set data(PaymentOptionsBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  PaymentOptionsEnvelopeBuilder() {
    PaymentOptionsEnvelope._defaults(this);
  }

  PaymentOptionsEnvelopeBuilder get _$this {
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
  void replace(PaymentOptionsEnvelope other) {
    _$v = other as _$PaymentOptionsEnvelope;
  }

  @override
  void update(void Function(PaymentOptionsEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentOptionsEnvelope build() => _build();

  _$PaymentOptionsEnvelope _build() {
    _$PaymentOptionsEnvelope _$result;
    try {
      _$result = _$v ??
          _$PaymentOptionsEnvelope._(
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
            r'PaymentOptionsEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
