// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_boundary_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoBoundaryEnvelope extends GeoBoundaryEnvelope {
  @override
  final GeoBoundaryCollection data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$GeoBoundaryEnvelope(
          [void Function(GeoBoundaryEnvelopeBuilder)? updates]) =>
      (GeoBoundaryEnvelopeBuilder()..update(updates))._build();

  _$GeoBoundaryEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  GeoBoundaryEnvelope rebuild(
          void Function(GeoBoundaryEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoBoundaryEnvelopeBuilder toBuilder() =>
      GeoBoundaryEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoBoundaryEnvelope &&
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
    return (newBuiltValueToStringHelper(r'GeoBoundaryEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class GeoBoundaryEnvelopeBuilder
    implements Builder<GeoBoundaryEnvelope, GeoBoundaryEnvelopeBuilder> {
  _$GeoBoundaryEnvelope? _$v;

  GeoBoundaryCollectionBuilder? _data;
  GeoBoundaryCollectionBuilder get data =>
      _$this._data ??= GeoBoundaryCollectionBuilder();
  set data(GeoBoundaryCollectionBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  GeoBoundaryEnvelopeBuilder() {
    GeoBoundaryEnvelope._defaults(this);
  }

  GeoBoundaryEnvelopeBuilder get _$this {
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
  void replace(GeoBoundaryEnvelope other) {
    _$v = other as _$GeoBoundaryEnvelope;
  }

  @override
  void update(void Function(GeoBoundaryEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoBoundaryEnvelope build() => _build();

  _$GeoBoundaryEnvelope _build() {
    _$GeoBoundaryEnvelope _$result;
    try {
      _$result = _$v ??
          _$GeoBoundaryEnvelope._(
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
            r'GeoBoundaryEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
