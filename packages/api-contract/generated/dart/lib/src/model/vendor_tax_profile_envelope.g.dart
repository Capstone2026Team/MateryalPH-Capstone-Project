// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_tax_profile_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTaxProfileEnvelope extends VendorTaxProfileEnvelope {
  @override
  final VendorTaxProfile data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorTaxProfileEnvelope(
          [void Function(VendorTaxProfileEnvelopeBuilder)? updates]) =>
      (VendorTaxProfileEnvelopeBuilder()..update(updates))._build();

  _$VendorTaxProfileEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorTaxProfileEnvelope rebuild(
          void Function(VendorTaxProfileEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTaxProfileEnvelopeBuilder toBuilder() =>
      VendorTaxProfileEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTaxProfileEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorTaxProfileEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorTaxProfileEnvelopeBuilder
    implements
        Builder<VendorTaxProfileEnvelope, VendorTaxProfileEnvelopeBuilder> {
  _$VendorTaxProfileEnvelope? _$v;

  VendorTaxProfileBuilder? _data;
  VendorTaxProfileBuilder get data =>
      _$this._data ??= VendorTaxProfileBuilder();
  set data(VendorTaxProfileBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorTaxProfileEnvelopeBuilder() {
    VendorTaxProfileEnvelope._defaults(this);
  }

  VendorTaxProfileEnvelopeBuilder get _$this {
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
  void replace(VendorTaxProfileEnvelope other) {
    _$v = other as _$VendorTaxProfileEnvelope;
  }

  @override
  void update(void Function(VendorTaxProfileEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTaxProfileEnvelope build() => _build();

  _$VendorTaxProfileEnvelope _build() {
    _$VendorTaxProfileEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorTaxProfileEnvelope._(
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
            r'VendorTaxProfileEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
