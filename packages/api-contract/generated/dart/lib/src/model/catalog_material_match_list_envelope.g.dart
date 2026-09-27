// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_material_match_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogMaterialMatchListEnvelope
    extends CatalogMaterialMatchListEnvelope {
  @override
  final BuiltList<CatalogMaterialMatch> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$CatalogMaterialMatchListEnvelope(
          [void Function(CatalogMaterialMatchListEnvelopeBuilder)? updates]) =>
      (CatalogMaterialMatchListEnvelopeBuilder()..update(updates))._build();

  _$CatalogMaterialMatchListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  CatalogMaterialMatchListEnvelope rebuild(
          void Function(CatalogMaterialMatchListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogMaterialMatchListEnvelopeBuilder toBuilder() =>
      CatalogMaterialMatchListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogMaterialMatchListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'CatalogMaterialMatchListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class CatalogMaterialMatchListEnvelopeBuilder
    implements
        Builder<CatalogMaterialMatchListEnvelope,
            CatalogMaterialMatchListEnvelopeBuilder> {
  _$CatalogMaterialMatchListEnvelope? _$v;

  ListBuilder<CatalogMaterialMatch>? _data;
  ListBuilder<CatalogMaterialMatch> get data =>
      _$this._data ??= ListBuilder<CatalogMaterialMatch>();
  set data(ListBuilder<CatalogMaterialMatch>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  CatalogMaterialMatchListEnvelopeBuilder() {
    CatalogMaterialMatchListEnvelope._defaults(this);
  }

  CatalogMaterialMatchListEnvelopeBuilder get _$this {
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
  void replace(CatalogMaterialMatchListEnvelope other) {
    _$v = other as _$CatalogMaterialMatchListEnvelope;
  }

  @override
  void update(void Function(CatalogMaterialMatchListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogMaterialMatchListEnvelope build() => _build();

  _$CatalogMaterialMatchListEnvelope _build() {
    _$CatalogMaterialMatchListEnvelope _$result;
    try {
      _$result = _$v ??
          _$CatalogMaterialMatchListEnvelope._(
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
            r'CatalogMaterialMatchListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
