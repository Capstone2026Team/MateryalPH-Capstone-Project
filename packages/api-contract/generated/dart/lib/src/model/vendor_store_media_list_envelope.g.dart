// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_store_media_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorStoreMediaListEnvelope extends VendorStoreMediaListEnvelope {
  @override
  final BuiltList<VendorStoreMedia> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorStoreMediaListEnvelope(
          [void Function(VendorStoreMediaListEnvelopeBuilder)? updates]) =>
      (VendorStoreMediaListEnvelopeBuilder()..update(updates))._build();

  _$VendorStoreMediaListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorStoreMediaListEnvelope rebuild(
          void Function(VendorStoreMediaListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorStoreMediaListEnvelopeBuilder toBuilder() =>
      VendorStoreMediaListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorStoreMediaListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorStoreMediaListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorStoreMediaListEnvelopeBuilder
    implements
        Builder<VendorStoreMediaListEnvelope,
            VendorStoreMediaListEnvelopeBuilder> {
  _$VendorStoreMediaListEnvelope? _$v;

  ListBuilder<VendorStoreMedia>? _data;
  ListBuilder<VendorStoreMedia> get data =>
      _$this._data ??= ListBuilder<VendorStoreMedia>();
  set data(ListBuilder<VendorStoreMedia>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorStoreMediaListEnvelopeBuilder() {
    VendorStoreMediaListEnvelope._defaults(this);
  }

  VendorStoreMediaListEnvelopeBuilder get _$this {
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
  void replace(VendorStoreMediaListEnvelope other) {
    _$v = other as _$VendorStoreMediaListEnvelope;
  }

  @override
  void update(void Function(VendorStoreMediaListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorStoreMediaListEnvelope build() => _build();

  _$VendorStoreMediaListEnvelope _build() {
    _$VendorStoreMediaListEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorStoreMediaListEnvelope._(
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
            r'VendorStoreMediaListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
