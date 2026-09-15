// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_document_upload_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDocumentUploadEnvelope extends VendorDocumentUploadEnvelope {
  @override
  final VendorDocumentUpload data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorDocumentUploadEnvelope(
          [void Function(VendorDocumentUploadEnvelopeBuilder)? updates]) =>
      (VendorDocumentUploadEnvelopeBuilder()..update(updates))._build();

  _$VendorDocumentUploadEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorDocumentUploadEnvelope rebuild(
          void Function(VendorDocumentUploadEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDocumentUploadEnvelopeBuilder toBuilder() =>
      VendorDocumentUploadEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDocumentUploadEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorDocumentUploadEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorDocumentUploadEnvelopeBuilder
    implements
        Builder<VendorDocumentUploadEnvelope,
            VendorDocumentUploadEnvelopeBuilder> {
  _$VendorDocumentUploadEnvelope? _$v;

  VendorDocumentUploadBuilder? _data;
  VendorDocumentUploadBuilder get data =>
      _$this._data ??= VendorDocumentUploadBuilder();
  set data(VendorDocumentUploadBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorDocumentUploadEnvelopeBuilder() {
    VendorDocumentUploadEnvelope._defaults(this);
  }

  VendorDocumentUploadEnvelopeBuilder get _$this {
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
  void replace(VendorDocumentUploadEnvelope other) {
    _$v = other as _$VendorDocumentUploadEnvelope;
  }

  @override
  void update(void Function(VendorDocumentUploadEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDocumentUploadEnvelope build() => _build();

  _$VendorDocumentUploadEnvelope _build() {
    _$VendorDocumentUploadEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorDocumentUploadEnvelope._(
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
            r'VendorDocumentUploadEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
