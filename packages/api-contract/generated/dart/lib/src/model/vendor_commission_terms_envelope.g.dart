// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_commission_terms_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorCommissionTermsEnvelope extends VendorCommissionTermsEnvelope {
  @override
  final VendorCommissionTerms data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorCommissionTermsEnvelope(
          [void Function(VendorCommissionTermsEnvelopeBuilder)? updates]) =>
      (VendorCommissionTermsEnvelopeBuilder()..update(updates))._build();

  _$VendorCommissionTermsEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorCommissionTermsEnvelope rebuild(
          void Function(VendorCommissionTermsEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorCommissionTermsEnvelopeBuilder toBuilder() =>
      VendorCommissionTermsEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorCommissionTermsEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorCommissionTermsEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorCommissionTermsEnvelopeBuilder
    implements
        Builder<VendorCommissionTermsEnvelope,
            VendorCommissionTermsEnvelopeBuilder> {
  _$VendorCommissionTermsEnvelope? _$v;

  VendorCommissionTermsBuilder? _data;
  VendorCommissionTermsBuilder get data =>
      _$this._data ??= VendorCommissionTermsBuilder();
  set data(VendorCommissionTermsBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorCommissionTermsEnvelopeBuilder() {
    VendorCommissionTermsEnvelope._defaults(this);
  }

  VendorCommissionTermsEnvelopeBuilder get _$this {
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
  void replace(VendorCommissionTermsEnvelope other) {
    _$v = other as _$VendorCommissionTermsEnvelope;
  }

  @override
  void update(void Function(VendorCommissionTermsEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorCommissionTermsEnvelope build() => _build();

  _$VendorCommissionTermsEnvelope _build() {
    _$VendorCommissionTermsEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorCommissionTermsEnvelope._(
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
            r'VendorCommissionTermsEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
