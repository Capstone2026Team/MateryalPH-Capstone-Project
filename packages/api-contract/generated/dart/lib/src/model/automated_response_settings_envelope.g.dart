// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automated_response_settings_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AutomatedResponseSettingsEnvelope
    extends AutomatedResponseSettingsEnvelope {
  @override
  final AutomatedResponseSettings data;
  @override
  final BuiltMap<String, JsonObject?>? meta;
  @override
  final BuiltList<ApiError>? errors;

  factory _$AutomatedResponseSettingsEnvelope(
          [void Function(AutomatedResponseSettingsEnvelopeBuilder)? updates]) =>
      (AutomatedResponseSettingsEnvelopeBuilder()..update(updates))._build();

  _$AutomatedResponseSettingsEnvelope._(
      {required this.data, this.meta, this.errors})
      : super._();
  @override
  AutomatedResponseSettingsEnvelope rebuild(
          void Function(AutomatedResponseSettingsEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutomatedResponseSettingsEnvelopeBuilder toBuilder() =>
      AutomatedResponseSettingsEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutomatedResponseSettingsEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AutomatedResponseSettingsEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AutomatedResponseSettingsEnvelopeBuilder
    implements
        Builder<AutomatedResponseSettingsEnvelope,
            AutomatedResponseSettingsEnvelopeBuilder> {
  _$AutomatedResponseSettingsEnvelope? _$v;

  AutomatedResponseSettingsBuilder? _data;
  AutomatedResponseSettingsBuilder get data =>
      _$this._data ??= AutomatedResponseSettingsBuilder();
  set data(AutomatedResponseSettingsBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  AutomatedResponseSettingsEnvelopeBuilder() {
    AutomatedResponseSettingsEnvelope._defaults(this);
  }

  AutomatedResponseSettingsEnvelopeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta?.toBuilder();
      _errors = $v.errors?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutomatedResponseSettingsEnvelope other) {
    _$v = other as _$AutomatedResponseSettingsEnvelope;
  }

  @override
  void update(
      void Function(AutomatedResponseSettingsEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutomatedResponseSettingsEnvelope build() => _build();

  _$AutomatedResponseSettingsEnvelope _build() {
    _$AutomatedResponseSettingsEnvelope _$result;
    try {
      _$result = _$v ??
          _$AutomatedResponseSettingsEnvelope._(
            data: data.build(),
            meta: _meta?.build(),
            errors: _errors?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'meta';
        _meta?.build();
        _$failedField = 'errors';
        _errors?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AutomatedResponseSettingsEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
