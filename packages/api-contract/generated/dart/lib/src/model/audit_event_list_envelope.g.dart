// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_event_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuditEventListEnvelope extends AuditEventListEnvelope {
  @override
  final BuiltList<AuditEvent> data;
  @override
  final AuditSearchMeta meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$AuditEventListEnvelope(
          [void Function(AuditEventListEnvelopeBuilder)? updates]) =>
      (AuditEventListEnvelopeBuilder()..update(updates))._build();

  _$AuditEventListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AuditEventListEnvelope rebuild(
          void Function(AuditEventListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuditEventListEnvelopeBuilder toBuilder() =>
      AuditEventListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuditEventListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AuditEventListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AuditEventListEnvelopeBuilder
    implements Builder<AuditEventListEnvelope, AuditEventListEnvelopeBuilder> {
  _$AuditEventListEnvelope? _$v;

  ListBuilder<AuditEvent>? _data;
  ListBuilder<AuditEvent> get data =>
      _$this._data ??= ListBuilder<AuditEvent>();
  set data(ListBuilder<AuditEvent>? data) => _$this._data = data;

  AuditSearchMetaBuilder? _meta;
  AuditSearchMetaBuilder get meta => _$this._meta ??= AuditSearchMetaBuilder();
  set meta(AuditSearchMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  AuditEventListEnvelopeBuilder() {
    AuditEventListEnvelope._defaults(this);
  }

  AuditEventListEnvelopeBuilder get _$this {
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
  void replace(AuditEventListEnvelope other) {
    _$v = other as _$AuditEventListEnvelope;
  }

  @override
  void update(void Function(AuditEventListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuditEventListEnvelope build() => _build();

  _$AuditEventListEnvelope _build() {
    _$AuditEventListEnvelope _$result;
    try {
      _$result = _$v ??
          _$AuditEventListEnvelope._(
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
            r'AuditEventListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
