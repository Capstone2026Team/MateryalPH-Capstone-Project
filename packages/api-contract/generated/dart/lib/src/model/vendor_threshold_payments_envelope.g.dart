// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_threshold_payments_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorThresholdPaymentsEnvelope
    extends VendorThresholdPaymentsEnvelope {
  @override
  final VendorThresholdPayments data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorThresholdPaymentsEnvelope(
          [void Function(VendorThresholdPaymentsEnvelopeBuilder)? updates]) =>
      (VendorThresholdPaymentsEnvelopeBuilder()..update(updates))._build();

  _$VendorThresholdPaymentsEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorThresholdPaymentsEnvelope rebuild(
          void Function(VendorThresholdPaymentsEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorThresholdPaymentsEnvelopeBuilder toBuilder() =>
      VendorThresholdPaymentsEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorThresholdPaymentsEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorThresholdPaymentsEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorThresholdPaymentsEnvelopeBuilder
    implements
        Builder<VendorThresholdPaymentsEnvelope,
            VendorThresholdPaymentsEnvelopeBuilder> {
  _$VendorThresholdPaymentsEnvelope? _$v;

  VendorThresholdPaymentsBuilder? _data;
  VendorThresholdPaymentsBuilder get data =>
      _$this._data ??= VendorThresholdPaymentsBuilder();
  set data(VendorThresholdPaymentsBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorThresholdPaymentsEnvelopeBuilder() {
    VendorThresholdPaymentsEnvelope._defaults(this);
  }

  VendorThresholdPaymentsEnvelopeBuilder get _$this {
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
  void replace(VendorThresholdPaymentsEnvelope other) {
    _$v = other as _$VendorThresholdPaymentsEnvelope;
  }

  @override
  void update(void Function(VendorThresholdPaymentsEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorThresholdPaymentsEnvelope build() => _build();

  _$VendorThresholdPaymentsEnvelope _build() {
    _$VendorThresholdPaymentsEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorThresholdPaymentsEnvelope._(
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
            r'VendorThresholdPaymentsEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
