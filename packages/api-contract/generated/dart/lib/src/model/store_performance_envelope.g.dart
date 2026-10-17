// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_performance_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StorePerformanceEnvelope extends StorePerformanceEnvelope {
  @override
  final StorePerformance data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$StorePerformanceEnvelope(
          [void Function(StorePerformanceEnvelopeBuilder)? updates]) =>
      (StorePerformanceEnvelopeBuilder()..update(updates))._build();

  _$StorePerformanceEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  StorePerformanceEnvelope rebuild(
          void Function(StorePerformanceEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StorePerformanceEnvelopeBuilder toBuilder() =>
      StorePerformanceEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StorePerformanceEnvelope &&
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
    return (newBuiltValueToStringHelper(r'StorePerformanceEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class StorePerformanceEnvelopeBuilder
    implements
        Builder<StorePerformanceEnvelope, StorePerformanceEnvelopeBuilder> {
  _$StorePerformanceEnvelope? _$v;

  StorePerformanceBuilder? _data;
  StorePerformanceBuilder get data =>
      _$this._data ??= StorePerformanceBuilder();
  set data(StorePerformanceBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  StorePerformanceEnvelopeBuilder() {
    StorePerformanceEnvelope._defaults(this);
  }

  StorePerformanceEnvelopeBuilder get _$this {
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
  void replace(StorePerformanceEnvelope other) {
    _$v = other as _$StorePerformanceEnvelope;
  }

  @override
  void update(void Function(StorePerformanceEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StorePerformanceEnvelope build() => _build();

  _$StorePerformanceEnvelope _build() {
    _$StorePerformanceEnvelope _$result;
    try {
      _$result = _$v ??
          _$StorePerformanceEnvelope._(
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
            r'StorePerformanceEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
