// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_export_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeExportEnvelope extends DisputeExportEnvelope {
  @override
  final DisputeExport data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$DisputeExportEnvelope(
          [void Function(DisputeExportEnvelopeBuilder)? updates]) =>
      (DisputeExportEnvelopeBuilder()..update(updates))._build();

  _$DisputeExportEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  DisputeExportEnvelope rebuild(
          void Function(DisputeExportEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeExportEnvelopeBuilder toBuilder() =>
      DisputeExportEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeExportEnvelope &&
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
    return (newBuiltValueToStringHelper(r'DisputeExportEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class DisputeExportEnvelopeBuilder
    implements Builder<DisputeExportEnvelope, DisputeExportEnvelopeBuilder> {
  _$DisputeExportEnvelope? _$v;

  DisputeExportBuilder? _data;
  DisputeExportBuilder get data => _$this._data ??= DisputeExportBuilder();
  set data(DisputeExportBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  DisputeExportEnvelopeBuilder() {
    DisputeExportEnvelope._defaults(this);
  }

  DisputeExportEnvelopeBuilder get _$this {
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
  void replace(DisputeExportEnvelope other) {
    _$v = other as _$DisputeExportEnvelope;
  }

  @override
  void update(void Function(DisputeExportEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeExportEnvelope build() => _build();

  _$DisputeExportEnvelope _build() {
    _$DisputeExportEnvelope _$result;
    try {
      _$result = _$v ??
          _$DisputeExportEnvelope._(
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
            r'DisputeExportEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
