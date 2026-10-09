// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_demand_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoDemandEnvelope extends GeoDemandEnvelope {
  @override
  final GeoDemand data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$GeoDemandEnvelope(
          [void Function(GeoDemandEnvelopeBuilder)? updates]) =>
      (GeoDemandEnvelopeBuilder()..update(updates))._build();

  _$GeoDemandEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  GeoDemandEnvelope rebuild(void Function(GeoDemandEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoDemandEnvelopeBuilder toBuilder() =>
      GeoDemandEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoDemandEnvelope &&
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
    return (newBuiltValueToStringHelper(r'GeoDemandEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class GeoDemandEnvelopeBuilder
    implements Builder<GeoDemandEnvelope, GeoDemandEnvelopeBuilder> {
  _$GeoDemandEnvelope? _$v;

  GeoDemandBuilder? _data;
  GeoDemandBuilder get data => _$this._data ??= GeoDemandBuilder();
  set data(GeoDemandBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  GeoDemandEnvelopeBuilder() {
    GeoDemandEnvelope._defaults(this);
  }

  GeoDemandEnvelopeBuilder get _$this {
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
  void replace(GeoDemandEnvelope other) {
    _$v = other as _$GeoDemandEnvelope;
  }

  @override
  void update(void Function(GeoDemandEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoDemandEnvelope build() => _build();

  _$GeoDemandEnvelope _build() {
    _$GeoDemandEnvelope _$result;
    try {
      _$result = _$v ??
          _$GeoDemandEnvelope._(
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
            r'GeoDemandEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
