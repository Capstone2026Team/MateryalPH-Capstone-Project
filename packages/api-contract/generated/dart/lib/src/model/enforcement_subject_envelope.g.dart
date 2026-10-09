// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enforcement_subject_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EnforcementSubjectEnvelope extends EnforcementSubjectEnvelope {
  @override
  final EnforcementSubjectEnvelopeData data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$EnforcementSubjectEnvelope(
          [void Function(EnforcementSubjectEnvelopeBuilder)? updates]) =>
      (EnforcementSubjectEnvelopeBuilder()..update(updates))._build();

  _$EnforcementSubjectEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  EnforcementSubjectEnvelope rebuild(
          void Function(EnforcementSubjectEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EnforcementSubjectEnvelopeBuilder toBuilder() =>
      EnforcementSubjectEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnforcementSubjectEnvelope &&
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
    return (newBuiltValueToStringHelper(r'EnforcementSubjectEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class EnforcementSubjectEnvelopeBuilder
    implements
        Builder<EnforcementSubjectEnvelope, EnforcementSubjectEnvelopeBuilder> {
  _$EnforcementSubjectEnvelope? _$v;

  EnforcementSubjectEnvelopeDataBuilder? _data;
  EnforcementSubjectEnvelopeDataBuilder get data =>
      _$this._data ??= EnforcementSubjectEnvelopeDataBuilder();
  set data(EnforcementSubjectEnvelopeDataBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  EnforcementSubjectEnvelopeBuilder() {
    EnforcementSubjectEnvelope._defaults(this);
  }

  EnforcementSubjectEnvelopeBuilder get _$this {
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
  void replace(EnforcementSubjectEnvelope other) {
    _$v = other as _$EnforcementSubjectEnvelope;
  }

  @override
  void update(void Function(EnforcementSubjectEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnforcementSubjectEnvelope build() => _build();

  _$EnforcementSubjectEnvelope _build() {
    _$EnforcementSubjectEnvelope _$result;
    try {
      _$result = _$v ??
          _$EnforcementSubjectEnvelope._(
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
            r'EnforcementSubjectEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
