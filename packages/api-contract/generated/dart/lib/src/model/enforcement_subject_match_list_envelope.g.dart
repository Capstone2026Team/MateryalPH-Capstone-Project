// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enforcement_subject_match_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EnforcementSubjectMatchListEnvelope
    extends EnforcementSubjectMatchListEnvelope {
  @override
  final BuiltList<EnforcementSubjectMatch> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$EnforcementSubjectMatchListEnvelope(
          [void Function(EnforcementSubjectMatchListEnvelopeBuilder)?
              updates]) =>
      (EnforcementSubjectMatchListEnvelopeBuilder()..update(updates))._build();

  _$EnforcementSubjectMatchListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  EnforcementSubjectMatchListEnvelope rebuild(
          void Function(EnforcementSubjectMatchListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EnforcementSubjectMatchListEnvelopeBuilder toBuilder() =>
      EnforcementSubjectMatchListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnforcementSubjectMatchListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'EnforcementSubjectMatchListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class EnforcementSubjectMatchListEnvelopeBuilder
    implements
        Builder<EnforcementSubjectMatchListEnvelope,
            EnforcementSubjectMatchListEnvelopeBuilder> {
  _$EnforcementSubjectMatchListEnvelope? _$v;

  ListBuilder<EnforcementSubjectMatch>? _data;
  ListBuilder<EnforcementSubjectMatch> get data =>
      _$this._data ??= ListBuilder<EnforcementSubjectMatch>();
  set data(ListBuilder<EnforcementSubjectMatch>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  EnforcementSubjectMatchListEnvelopeBuilder() {
    EnforcementSubjectMatchListEnvelope._defaults(this);
  }

  EnforcementSubjectMatchListEnvelopeBuilder get _$this {
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
  void replace(EnforcementSubjectMatchListEnvelope other) {
    _$v = other as _$EnforcementSubjectMatchListEnvelope;
  }

  @override
  void update(
      void Function(EnforcementSubjectMatchListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnforcementSubjectMatchListEnvelope build() => _build();

  _$EnforcementSubjectMatchListEnvelope _build() {
    _$EnforcementSubjectMatchListEnvelope _$result;
    try {
      _$result = _$v ??
          _$EnforcementSubjectMatchListEnvelope._(
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
        throw BuiltValueNestedFieldError(r'EnforcementSubjectMatchListEnvelope',
            _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
