// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_document_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDocumentListEnvelope extends VendorDocumentListEnvelope {
  @override
  final BuiltList<VendorDocument> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorDocumentListEnvelope(
          [void Function(VendorDocumentListEnvelopeBuilder)? updates]) =>
      (VendorDocumentListEnvelopeBuilder()..update(updates))._build();

  _$VendorDocumentListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorDocumentListEnvelope rebuild(
          void Function(VendorDocumentListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDocumentListEnvelopeBuilder toBuilder() =>
      VendorDocumentListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDocumentListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorDocumentListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorDocumentListEnvelopeBuilder
    implements
        Builder<VendorDocumentListEnvelope, VendorDocumentListEnvelopeBuilder> {
  _$VendorDocumentListEnvelope? _$v;

  ListBuilder<VendorDocument>? _data;
  ListBuilder<VendorDocument> get data =>
      _$this._data ??= ListBuilder<VendorDocument>();
  set data(ListBuilder<VendorDocument>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorDocumentListEnvelopeBuilder() {
    VendorDocumentListEnvelope._defaults(this);
  }

  VendorDocumentListEnvelopeBuilder get _$this {
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
  void replace(VendorDocumentListEnvelope other) {
    _$v = other as _$VendorDocumentListEnvelope;
  }

  @override
  void update(void Function(VendorDocumentListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDocumentListEnvelope build() => _build();

  _$VendorDocumentListEnvelope _build() {
    _$VendorDocumentListEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorDocumentListEnvelope._(
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
            r'VendorDocumentListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
