// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_dashboard_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoDashboardEnvelope extends GeoDashboardEnvelope {
  @override
  final GeoDashboard data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$GeoDashboardEnvelope(
          [void Function(GeoDashboardEnvelopeBuilder)? updates]) =>
      (GeoDashboardEnvelopeBuilder()..update(updates))._build();

  _$GeoDashboardEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  GeoDashboardEnvelope rebuild(
          void Function(GeoDashboardEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoDashboardEnvelopeBuilder toBuilder() =>
      GeoDashboardEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoDashboardEnvelope &&
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
    return (newBuiltValueToStringHelper(r'GeoDashboardEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class GeoDashboardEnvelopeBuilder
    implements Builder<GeoDashboardEnvelope, GeoDashboardEnvelopeBuilder> {
  _$GeoDashboardEnvelope? _$v;

  GeoDashboardBuilder? _data;
  GeoDashboardBuilder get data => _$this._data ??= GeoDashboardBuilder();
  set data(GeoDashboardBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  GeoDashboardEnvelopeBuilder() {
    GeoDashboardEnvelope._defaults(this);
  }

  GeoDashboardEnvelopeBuilder get _$this {
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
  void replace(GeoDashboardEnvelope other) {
    _$v = other as _$GeoDashboardEnvelope;
  }

  @override
  void update(void Function(GeoDashboardEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoDashboardEnvelope build() => _build();

  _$GeoDashboardEnvelope _build() {
    _$GeoDashboardEnvelope _$result;
    try {
      _$result = _$v ??
          _$GeoDashboardEnvelope._(
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
            r'GeoDashboardEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
