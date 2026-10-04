// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_export_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeExportListEnvelope extends DisputeExportListEnvelope {
  @override
  final BuiltList<DisputeExport> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$DisputeExportListEnvelope(
          [void Function(DisputeExportListEnvelopeBuilder)? updates]) =>
      (DisputeExportListEnvelopeBuilder()..update(updates))._build();

  _$DisputeExportListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  DisputeExportListEnvelope rebuild(
          void Function(DisputeExportListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeExportListEnvelopeBuilder toBuilder() =>
      DisputeExportListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeExportListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'DisputeExportListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class DisputeExportListEnvelopeBuilder
    implements
        Builder<DisputeExportListEnvelope, DisputeExportListEnvelopeBuilder> {
  _$DisputeExportListEnvelope? _$v;

  ListBuilder<DisputeExport>? _data;
  ListBuilder<DisputeExport> get data =>
      _$this._data ??= ListBuilder<DisputeExport>();
  set data(ListBuilder<DisputeExport>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  DisputeExportListEnvelopeBuilder() {
    DisputeExportListEnvelope._defaults(this);
  }

  DisputeExportListEnvelopeBuilder get _$this {
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
  void replace(DisputeExportListEnvelope other) {
    _$v = other as _$DisputeExportListEnvelope;
  }

  @override
  void update(void Function(DisputeExportListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeExportListEnvelope build() => _build();

  _$DisputeExportListEnvelope _build() {
    _$DisputeExportListEnvelope _$result;
    try {
      _$result = _$v ??
          _$DisputeExportListEnvelope._(
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
            r'DisputeExportListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
