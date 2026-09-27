// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_material_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogMaterialEnvelope extends CatalogMaterialEnvelope {
  @override
  final CatalogMaterial data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$CatalogMaterialEnvelope(
          [void Function(CatalogMaterialEnvelopeBuilder)? updates]) =>
      (CatalogMaterialEnvelopeBuilder()..update(updates))._build();

  _$CatalogMaterialEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  CatalogMaterialEnvelope rebuild(
          void Function(CatalogMaterialEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogMaterialEnvelopeBuilder toBuilder() =>
      CatalogMaterialEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogMaterialEnvelope &&
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
    return (newBuiltValueToStringHelper(r'CatalogMaterialEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class CatalogMaterialEnvelopeBuilder
    implements
        Builder<CatalogMaterialEnvelope, CatalogMaterialEnvelopeBuilder> {
  _$CatalogMaterialEnvelope? _$v;

  CatalogMaterialBuilder? _data;
  CatalogMaterialBuilder get data => _$this._data ??= CatalogMaterialBuilder();
  set data(CatalogMaterialBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  CatalogMaterialEnvelopeBuilder() {
    CatalogMaterialEnvelope._defaults(this);
  }

  CatalogMaterialEnvelopeBuilder get _$this {
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
  void replace(CatalogMaterialEnvelope other) {
    _$v = other as _$CatalogMaterialEnvelope;
  }

  @override
  void update(void Function(CatalogMaterialEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogMaterialEnvelope build() => _build();

  _$CatalogMaterialEnvelope _build() {
    _$CatalogMaterialEnvelope _$result;
    try {
      _$result = _$v ??
          _$CatalogMaterialEnvelope._(
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
            r'CatalogMaterialEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
