// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_source_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AnalyticsSourceListEnvelope extends AnalyticsSourceListEnvelope {
  @override
  final BuiltList<AnalyticsSource> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$AnalyticsSourceListEnvelope(
          [void Function(AnalyticsSourceListEnvelopeBuilder)? updates]) =>
      (AnalyticsSourceListEnvelopeBuilder()..update(updates))._build();

  _$AnalyticsSourceListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AnalyticsSourceListEnvelope rebuild(
          void Function(AnalyticsSourceListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnalyticsSourceListEnvelopeBuilder toBuilder() =>
      AnalyticsSourceListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnalyticsSourceListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AnalyticsSourceListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AnalyticsSourceListEnvelopeBuilder
    implements
        Builder<AnalyticsSourceListEnvelope,
            AnalyticsSourceListEnvelopeBuilder> {
  _$AnalyticsSourceListEnvelope? _$v;

  ListBuilder<AnalyticsSource>? _data;
  ListBuilder<AnalyticsSource> get data =>
      _$this._data ??= ListBuilder<AnalyticsSource>();
  set data(ListBuilder<AnalyticsSource>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  AnalyticsSourceListEnvelopeBuilder() {
    AnalyticsSourceListEnvelope._defaults(this);
  }

  AnalyticsSourceListEnvelopeBuilder get _$this {
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
  void replace(AnalyticsSourceListEnvelope other) {
    _$v = other as _$AnalyticsSourceListEnvelope;
  }

  @override
  void update(void Function(AnalyticsSourceListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnalyticsSourceListEnvelope build() => _build();

  _$AnalyticsSourceListEnvelope _build() {
    _$AnalyticsSourceListEnvelope _$result;
    try {
      _$result = _$v ??
          _$AnalyticsSourceListEnvelope._(
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
            r'AnalyticsSourceListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
