// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_document_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDocumentEnvelope extends VendorDocumentEnvelope {
  @override
  final VendorDocument data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$VendorDocumentEnvelope(
          [void Function(VendorDocumentEnvelopeBuilder)? updates]) =>
      (VendorDocumentEnvelopeBuilder()..update(updates))._build();

  _$VendorDocumentEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorDocumentEnvelope rebuild(
          void Function(VendorDocumentEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDocumentEnvelopeBuilder toBuilder() =>
      VendorDocumentEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDocumentEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorDocumentEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorDocumentEnvelopeBuilder
    implements Builder<VendorDocumentEnvelope, VendorDocumentEnvelopeBuilder> {
  _$VendorDocumentEnvelope? _$v;

  VendorDocumentBuilder? _data;
  VendorDocumentBuilder get data => _$this._data ??= VendorDocumentBuilder();
  set data(VendorDocumentBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  VendorDocumentEnvelopeBuilder() {
    VendorDocumentEnvelope._defaults(this);
  }

  VendorDocumentEnvelopeBuilder get _$this {
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
  void replace(VendorDocumentEnvelope other) {
    _$v = other as _$VendorDocumentEnvelope;
  }

  @override
  void update(void Function(VendorDocumentEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDocumentEnvelope build() => _build();

  _$VendorDocumentEnvelope _build() {
    _$VendorDocumentEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorDocumentEnvelope._(
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
            r'VendorDocumentEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
