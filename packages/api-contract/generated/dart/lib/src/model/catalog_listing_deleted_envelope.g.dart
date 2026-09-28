// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_listing_deleted_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogListingDeletedEnvelope extends CatalogListingDeletedEnvelope {
  @override
  final CatalogListingDeletedEnvelopeData data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$CatalogListingDeletedEnvelope(
          [void Function(CatalogListingDeletedEnvelopeBuilder)? updates]) =>
      (CatalogListingDeletedEnvelopeBuilder()..update(updates))._build();

  _$CatalogListingDeletedEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  CatalogListingDeletedEnvelope rebuild(
          void Function(CatalogListingDeletedEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogListingDeletedEnvelopeBuilder toBuilder() =>
      CatalogListingDeletedEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogListingDeletedEnvelope &&
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
    return (newBuiltValueToStringHelper(r'CatalogListingDeletedEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class CatalogListingDeletedEnvelopeBuilder
    implements
        Builder<CatalogListingDeletedEnvelope,
            CatalogListingDeletedEnvelopeBuilder> {
  _$CatalogListingDeletedEnvelope? _$v;

  CatalogListingDeletedEnvelopeDataBuilder? _data;
  CatalogListingDeletedEnvelopeDataBuilder get data =>
      _$this._data ??= CatalogListingDeletedEnvelopeDataBuilder();
  set data(CatalogListingDeletedEnvelopeDataBuilder? data) =>
      _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  CatalogListingDeletedEnvelopeBuilder() {
    CatalogListingDeletedEnvelope._defaults(this);
  }

  CatalogListingDeletedEnvelopeBuilder get _$this {
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
  void replace(CatalogListingDeletedEnvelope other) {
    _$v = other as _$CatalogListingDeletedEnvelope;
  }

  @override
  void update(void Function(CatalogListingDeletedEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogListingDeletedEnvelope build() => _build();

  _$CatalogListingDeletedEnvelope _build() {
    _$CatalogListingDeletedEnvelope _$result;
    try {
      _$result = _$v ??
          _$CatalogListingDeletedEnvelope._(
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
            r'CatalogListingDeletedEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
