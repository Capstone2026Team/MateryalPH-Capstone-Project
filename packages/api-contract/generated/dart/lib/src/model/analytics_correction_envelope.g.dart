// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_correction_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AnalyticsCorrectionEnvelope extends AnalyticsCorrectionEnvelope {
  @override
  final AnalyticsCorrectionResult data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$AnalyticsCorrectionEnvelope(
          [void Function(AnalyticsCorrectionEnvelopeBuilder)? updates]) =>
      (AnalyticsCorrectionEnvelopeBuilder()..update(updates))._build();

  _$AnalyticsCorrectionEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AnalyticsCorrectionEnvelope rebuild(
          void Function(AnalyticsCorrectionEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnalyticsCorrectionEnvelopeBuilder toBuilder() =>
      AnalyticsCorrectionEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnalyticsCorrectionEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AnalyticsCorrectionEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AnalyticsCorrectionEnvelopeBuilder
    implements
        Builder<AnalyticsCorrectionEnvelope,
            AnalyticsCorrectionEnvelopeBuilder> {
  _$AnalyticsCorrectionEnvelope? _$v;

  AnalyticsCorrectionResultBuilder? _data;
  AnalyticsCorrectionResultBuilder get data =>
      _$this._data ??= AnalyticsCorrectionResultBuilder();
  set data(AnalyticsCorrectionResultBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  AnalyticsCorrectionEnvelopeBuilder() {
    AnalyticsCorrectionEnvelope._defaults(this);
  }

  AnalyticsCorrectionEnvelopeBuilder get _$this {
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
  void replace(AnalyticsCorrectionEnvelope other) {
    _$v = other as _$AnalyticsCorrectionEnvelope;
  }

  @override
  void update(void Function(AnalyticsCorrectionEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnalyticsCorrectionEnvelope build() => _build();

  _$AnalyticsCorrectionEnvelope _build() {
    _$AnalyticsCorrectionEnvelope _$result;
    try {
      _$result = _$v ??
          _$AnalyticsCorrectionEnvelope._(
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
            r'AnalyticsCorrectionEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
