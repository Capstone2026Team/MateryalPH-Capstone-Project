// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_action_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuditActionListEnvelope extends AuditActionListEnvelope {
  @override
  final BuiltList<String> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$AuditActionListEnvelope(
          [void Function(AuditActionListEnvelopeBuilder)? updates]) =>
      (AuditActionListEnvelopeBuilder()..update(updates))._build();

  _$AuditActionListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AuditActionListEnvelope rebuild(
          void Function(AuditActionListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuditActionListEnvelopeBuilder toBuilder() =>
      AuditActionListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuditActionListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AuditActionListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AuditActionListEnvelopeBuilder
    implements
        Builder<AuditActionListEnvelope, AuditActionListEnvelopeBuilder> {
  _$AuditActionListEnvelope? _$v;

  ListBuilder<String>? _data;
  ListBuilder<String> get data => _$this._data ??= ListBuilder<String>();
  set data(ListBuilder<String>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  AuditActionListEnvelopeBuilder() {
    AuditActionListEnvelope._defaults(this);
  }

  AuditActionListEnvelopeBuilder get _$this {
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
  void replace(AuditActionListEnvelope other) {
    _$v = other as _$AuditActionListEnvelope;
  }

  @override
  void update(void Function(AuditActionListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuditActionListEnvelope build() => _build();

  _$AuditActionListEnvelope _build() {
    _$AuditActionListEnvelope _$result;
    try {
      _$result = _$v ??
          _$AuditActionListEnvelope._(
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
            r'AuditActionListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
