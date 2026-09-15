// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_download_link_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDownloadLinkEnvelope extends VendorDownloadLinkEnvelope {
  @override
  final VendorDownloadLink data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorDownloadLinkEnvelope(
          [void Function(VendorDownloadLinkEnvelopeBuilder)? updates]) =>
      (VendorDownloadLinkEnvelopeBuilder()..update(updates))._build();

  _$VendorDownloadLinkEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorDownloadLinkEnvelope rebuild(
          void Function(VendorDownloadLinkEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDownloadLinkEnvelopeBuilder toBuilder() =>
      VendorDownloadLinkEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDownloadLinkEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorDownloadLinkEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorDownloadLinkEnvelopeBuilder
    implements
        Builder<VendorDownloadLinkEnvelope, VendorDownloadLinkEnvelopeBuilder> {
  _$VendorDownloadLinkEnvelope? _$v;

  VendorDownloadLinkBuilder? _data;
  VendorDownloadLinkBuilder get data =>
      _$this._data ??= VendorDownloadLinkBuilder();
  set data(VendorDownloadLinkBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorDownloadLinkEnvelopeBuilder() {
    VendorDownloadLinkEnvelope._defaults(this);
  }

  VendorDownloadLinkEnvelopeBuilder get _$this {
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
  void replace(VendorDownloadLinkEnvelope other) {
    _$v = other as _$VendorDownloadLinkEnvelope;
  }

  @override
  void update(void Function(VendorDownloadLinkEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDownloadLinkEnvelope build() => _build();

  _$VendorDownloadLinkEnvelope _build() {
    _$VendorDownloadLinkEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorDownloadLinkEnvelope._(
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
            r'VendorDownloadLinkEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
