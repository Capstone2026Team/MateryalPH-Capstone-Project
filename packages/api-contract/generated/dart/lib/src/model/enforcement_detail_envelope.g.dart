// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enforcement_detail_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EnforcementDetailEnvelope extends EnforcementDetailEnvelope {
  @override
  final EnforcementDetail data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$EnforcementDetailEnvelope(
          [void Function(EnforcementDetailEnvelopeBuilder)? updates]) =>
      (EnforcementDetailEnvelopeBuilder()..update(updates))._build();

  _$EnforcementDetailEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  EnforcementDetailEnvelope rebuild(
          void Function(EnforcementDetailEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EnforcementDetailEnvelopeBuilder toBuilder() =>
      EnforcementDetailEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnforcementDetailEnvelope &&
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
    return (newBuiltValueToStringHelper(r'EnforcementDetailEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class EnforcementDetailEnvelopeBuilder
    implements
        Builder<EnforcementDetailEnvelope, EnforcementDetailEnvelopeBuilder> {
  _$EnforcementDetailEnvelope? _$v;

  EnforcementDetailBuilder? _data;
  EnforcementDetailBuilder get data =>
      _$this._data ??= EnforcementDetailBuilder();
  set data(EnforcementDetailBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  EnforcementDetailEnvelopeBuilder() {
    EnforcementDetailEnvelope._defaults(this);
  }

  EnforcementDetailEnvelopeBuilder get _$this {
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
  void replace(EnforcementDetailEnvelope other) {
    _$v = other as _$EnforcementDetailEnvelope;
  }

  @override
  void update(void Function(EnforcementDetailEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnforcementDetailEnvelope build() => _build();

  _$EnforcementDetailEnvelope _build() {
    _$EnforcementDetailEnvelope _$result;
    try {
      _$result = _$v ??
          _$EnforcementDetailEnvelope._(
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
            r'EnforcementDetailEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
