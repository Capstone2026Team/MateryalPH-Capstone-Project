// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_run_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AnalyticsRunListEnvelope extends AnalyticsRunListEnvelope {
  @override
  final BuiltList<AnalyticsRun> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$AnalyticsRunListEnvelope(
          [void Function(AnalyticsRunListEnvelopeBuilder)? updates]) =>
      (AnalyticsRunListEnvelopeBuilder()..update(updates))._build();

  _$AnalyticsRunListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AnalyticsRunListEnvelope rebuild(
          void Function(AnalyticsRunListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnalyticsRunListEnvelopeBuilder toBuilder() =>
      AnalyticsRunListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnalyticsRunListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AnalyticsRunListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AnalyticsRunListEnvelopeBuilder
    implements
        Builder<AnalyticsRunListEnvelope, AnalyticsRunListEnvelopeBuilder> {
  _$AnalyticsRunListEnvelope? _$v;

  ListBuilder<AnalyticsRun>? _data;
  ListBuilder<AnalyticsRun> get data =>
      _$this._data ??= ListBuilder<AnalyticsRun>();
  set data(ListBuilder<AnalyticsRun>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  AnalyticsRunListEnvelopeBuilder() {
    AnalyticsRunListEnvelope._defaults(this);
  }

  AnalyticsRunListEnvelopeBuilder get _$this {
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
  void replace(AnalyticsRunListEnvelope other) {
    _$v = other as _$AnalyticsRunListEnvelope;
  }

  @override
  void update(void Function(AnalyticsRunListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnalyticsRunListEnvelope build() => _build();

  _$AnalyticsRunListEnvelope _build() {
    _$AnalyticsRunListEnvelope _$result;
    try {
      _$result = _$v ??
          _$AnalyticsRunListEnvelope._(
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
            r'AnalyticsRunListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
