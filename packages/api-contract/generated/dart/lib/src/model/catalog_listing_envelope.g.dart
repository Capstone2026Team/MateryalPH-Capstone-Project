// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_listing_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogListingEnvelope extends CatalogListingEnvelope {
  @override
  final CatalogListing data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$CatalogListingEnvelope(
          [void Function(CatalogListingEnvelopeBuilder)? updates]) =>
      (CatalogListingEnvelopeBuilder()..update(updates))._build();

  _$CatalogListingEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  CatalogListingEnvelope rebuild(
          void Function(CatalogListingEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogListingEnvelopeBuilder toBuilder() =>
      CatalogListingEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogListingEnvelope &&
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
    return (newBuiltValueToStringHelper(r'CatalogListingEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class CatalogListingEnvelopeBuilder
    implements Builder<CatalogListingEnvelope, CatalogListingEnvelopeBuilder> {
  _$CatalogListingEnvelope? _$v;

  CatalogListingBuilder? _data;
  CatalogListingBuilder get data => _$this._data ??= CatalogListingBuilder();
  set data(CatalogListingBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  CatalogListingEnvelopeBuilder() {
    CatalogListingEnvelope._defaults(this);
  }

  CatalogListingEnvelopeBuilder get _$this {
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
  void replace(CatalogListingEnvelope other) {
    _$v = other as _$CatalogListingEnvelope;
  }

  @override
  void update(void Function(CatalogListingEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogListingEnvelope build() => _build();

  _$CatalogListingEnvelope _build() {
    _$CatalogListingEnvelope _$result;
    try {
      _$result = _$v ??
          _$CatalogListingEnvelope._(
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
            r'CatalogListingEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
