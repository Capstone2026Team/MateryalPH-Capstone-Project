// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_event_detail_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuditEventDetailEnvelope extends AuditEventDetailEnvelope {
  @override
  final AuditEventDetail data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$AuditEventDetailEnvelope(
          [void Function(AuditEventDetailEnvelopeBuilder)? updates]) =>
      (AuditEventDetailEnvelopeBuilder()..update(updates))._build();

  _$AuditEventDetailEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AuditEventDetailEnvelope rebuild(
          void Function(AuditEventDetailEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuditEventDetailEnvelopeBuilder toBuilder() =>
      AuditEventDetailEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuditEventDetailEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AuditEventDetailEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AuditEventDetailEnvelopeBuilder
    implements
        Builder<AuditEventDetailEnvelope, AuditEventDetailEnvelopeBuilder> {
  _$AuditEventDetailEnvelope? _$v;

  AuditEventDetailBuilder? _data;
  AuditEventDetailBuilder get data =>
      _$this._data ??= AuditEventDetailBuilder();
  set data(AuditEventDetailBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  AuditEventDetailEnvelopeBuilder() {
    AuditEventDetailEnvelope._defaults(this);
  }

  AuditEventDetailEnvelopeBuilder get _$this {
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
  void replace(AuditEventDetailEnvelope other) {
    _$v = other as _$AuditEventDetailEnvelope;
  }

  @override
  void update(void Function(AuditEventDetailEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuditEventDetailEnvelope build() => _build();

  _$AuditEventDetailEnvelope _build() {
    _$AuditEventDetailEnvelope _$result;
    try {
      _$result = _$v ??
          _$AuditEventDetailEnvelope._(
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
            r'AuditEventDetailEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
