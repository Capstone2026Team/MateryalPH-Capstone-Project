// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_retry_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OperationRetryListEnvelope extends OperationRetryListEnvelope {
  @override
  final BuiltList<OperationRetryRecord> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$OperationRetryListEnvelope(
          [void Function(OperationRetryListEnvelopeBuilder)? updates]) =>
      (OperationRetryListEnvelopeBuilder()..update(updates))._build();

  _$OperationRetryListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  OperationRetryListEnvelope rebuild(
          void Function(OperationRetryListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperationRetryListEnvelopeBuilder toBuilder() =>
      OperationRetryListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperationRetryListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'OperationRetryListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class OperationRetryListEnvelopeBuilder
    implements
        Builder<OperationRetryListEnvelope, OperationRetryListEnvelopeBuilder> {
  _$OperationRetryListEnvelope? _$v;

  ListBuilder<OperationRetryRecord>? _data;
  ListBuilder<OperationRetryRecord> get data =>
      _$this._data ??= ListBuilder<OperationRetryRecord>();
  set data(ListBuilder<OperationRetryRecord>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  OperationRetryListEnvelopeBuilder() {
    OperationRetryListEnvelope._defaults(this);
  }

  OperationRetryListEnvelopeBuilder get _$this {
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
  void replace(OperationRetryListEnvelope other) {
    _$v = other as _$OperationRetryListEnvelope;
  }

  @override
  void update(void Function(OperationRetryListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperationRetryListEnvelope build() => _build();

  _$OperationRetryListEnvelope _build() {
    _$OperationRetryListEnvelope _$result;
    try {
      _$result = _$v ??
          _$OperationRetryListEnvelope._(
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
            r'OperationRetryListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
