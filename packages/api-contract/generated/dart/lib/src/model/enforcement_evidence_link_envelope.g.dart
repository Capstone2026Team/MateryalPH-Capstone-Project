// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enforcement_evidence_link_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EnforcementEvidenceLinkEnvelope
    extends EnforcementEvidenceLinkEnvelope {
  @override
  final EnforcementEvidenceLinkEnvelopeData data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$EnforcementEvidenceLinkEnvelope(
          [void Function(EnforcementEvidenceLinkEnvelopeBuilder)? updates]) =>
      (EnforcementEvidenceLinkEnvelopeBuilder()..update(updates))._build();

  _$EnforcementEvidenceLinkEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  EnforcementEvidenceLinkEnvelope rebuild(
          void Function(EnforcementEvidenceLinkEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EnforcementEvidenceLinkEnvelopeBuilder toBuilder() =>
      EnforcementEvidenceLinkEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnforcementEvidenceLinkEnvelope &&
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
    return (newBuiltValueToStringHelper(r'EnforcementEvidenceLinkEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class EnforcementEvidenceLinkEnvelopeBuilder
    implements
        Builder<EnforcementEvidenceLinkEnvelope,
            EnforcementEvidenceLinkEnvelopeBuilder> {
  _$EnforcementEvidenceLinkEnvelope? _$v;

  EnforcementEvidenceLinkEnvelopeDataBuilder? _data;
  EnforcementEvidenceLinkEnvelopeDataBuilder get data =>
      _$this._data ??= EnforcementEvidenceLinkEnvelopeDataBuilder();
  set data(EnforcementEvidenceLinkEnvelopeDataBuilder? data) =>
      _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  EnforcementEvidenceLinkEnvelopeBuilder() {
    EnforcementEvidenceLinkEnvelope._defaults(this);
  }

  EnforcementEvidenceLinkEnvelopeBuilder get _$this {
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
  void replace(EnforcementEvidenceLinkEnvelope other) {
    _$v = other as _$EnforcementEvidenceLinkEnvelope;
  }

  @override
  void update(void Function(EnforcementEvidenceLinkEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnforcementEvidenceLinkEnvelope build() => _build();

  _$EnforcementEvidenceLinkEnvelope _build() {
    _$EnforcementEvidenceLinkEnvelope _$result;
    try {
      _$result = _$v ??
          _$EnforcementEvidenceLinkEnvelope._(
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
            r'EnforcementEvidenceLinkEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
