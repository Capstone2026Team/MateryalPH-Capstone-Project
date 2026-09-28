// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_estimate_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RouteEstimateEnvelope extends RouteEstimateEnvelope {
  @override
  final RouteEstimate data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$RouteEstimateEnvelope(
          [void Function(RouteEstimateEnvelopeBuilder)? updates]) =>
      (RouteEstimateEnvelopeBuilder()..update(updates))._build();

  _$RouteEstimateEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  RouteEstimateEnvelope rebuild(
          void Function(RouteEstimateEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteEstimateEnvelopeBuilder toBuilder() =>
      RouteEstimateEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteEstimateEnvelope &&
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
    return (newBuiltValueToStringHelper(r'RouteEstimateEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class RouteEstimateEnvelopeBuilder
    implements Builder<RouteEstimateEnvelope, RouteEstimateEnvelopeBuilder> {
  _$RouteEstimateEnvelope? _$v;

  RouteEstimateBuilder? _data;
  RouteEstimateBuilder get data => _$this._data ??= RouteEstimateBuilder();
  set data(RouteEstimateBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  RouteEstimateEnvelopeBuilder() {
    RouteEstimateEnvelope._defaults(this);
  }

  RouteEstimateEnvelopeBuilder get _$this {
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
  void replace(RouteEstimateEnvelope other) {
    _$v = other as _$RouteEstimateEnvelope;
  }

  @override
  void update(void Function(RouteEstimateEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteEstimateEnvelope build() => _build();

  _$RouteEstimateEnvelope _build() {
    _$RouteEstimateEnvelope _$result;
    try {
      _$result = _$v ??
          _$RouteEstimateEnvelope._(
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
            r'RouteEstimateEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
