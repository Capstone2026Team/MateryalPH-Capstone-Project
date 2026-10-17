// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remittance_queue_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RemittanceQueueEnvelope extends RemittanceQueueEnvelope {
  @override
  final BuiltList<RemittanceQueueRow> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$RemittanceQueueEnvelope(
          [void Function(RemittanceQueueEnvelopeBuilder)? updates]) =>
      (RemittanceQueueEnvelopeBuilder()..update(updates))._build();

  _$RemittanceQueueEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  RemittanceQueueEnvelope rebuild(
          void Function(RemittanceQueueEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RemittanceQueueEnvelopeBuilder toBuilder() =>
      RemittanceQueueEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RemittanceQueueEnvelope &&
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
    return (newBuiltValueToStringHelper(r'RemittanceQueueEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class RemittanceQueueEnvelopeBuilder
    implements
        Builder<RemittanceQueueEnvelope, RemittanceQueueEnvelopeBuilder> {
  _$RemittanceQueueEnvelope? _$v;

  ListBuilder<RemittanceQueueRow>? _data;
  ListBuilder<RemittanceQueueRow> get data =>
      _$this._data ??= ListBuilder<RemittanceQueueRow>();
  set data(ListBuilder<RemittanceQueueRow>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  RemittanceQueueEnvelopeBuilder() {
    RemittanceQueueEnvelope._defaults(this);
  }

  RemittanceQueueEnvelopeBuilder get _$this {
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
  void replace(RemittanceQueueEnvelope other) {
    _$v = other as _$RemittanceQueueEnvelope;
  }

  @override
  void update(void Function(RemittanceQueueEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RemittanceQueueEnvelope build() => _build();

  _$RemittanceQueueEnvelope _build() {
    _$RemittanceQueueEnvelope _$result;
    try {
      _$result = _$v ??
          _$RemittanceQueueEnvelope._(
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
            r'RemittanceQueueEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
