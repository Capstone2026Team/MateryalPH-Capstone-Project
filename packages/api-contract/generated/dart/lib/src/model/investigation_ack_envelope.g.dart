// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investigation_ack_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InvestigationAckEnvelope extends InvestigationAckEnvelope {
  @override
  final BuiltMap<String, JsonObject?> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$InvestigationAckEnvelope(
          [void Function(InvestigationAckEnvelopeBuilder)? updates]) =>
      (InvestigationAckEnvelopeBuilder()..update(updates))._build();

  _$InvestigationAckEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  InvestigationAckEnvelope rebuild(
          void Function(InvestigationAckEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvestigationAckEnvelopeBuilder toBuilder() =>
      InvestigationAckEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvestigationAckEnvelope &&
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
    return (newBuiltValueToStringHelper(r'InvestigationAckEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class InvestigationAckEnvelopeBuilder
    implements
        Builder<InvestigationAckEnvelope, InvestigationAckEnvelopeBuilder> {
  _$InvestigationAckEnvelope? _$v;

  MapBuilder<String, JsonObject?>? _data;
  MapBuilder<String, JsonObject?> get data =>
      _$this._data ??= MapBuilder<String, JsonObject?>();
  set data(MapBuilder<String, JsonObject?>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  InvestigationAckEnvelopeBuilder() {
    InvestigationAckEnvelope._defaults(this);
  }

  InvestigationAckEnvelopeBuilder get _$this {
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
  void replace(InvestigationAckEnvelope other) {
    _$v = other as _$InvestigationAckEnvelope;
  }

  @override
  void update(void Function(InvestigationAckEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvestigationAckEnvelope build() => _build();

  _$InvestigationAckEnvelope _build() {
    _$InvestigationAckEnvelope _$result;
    try {
      _$result = _$v ??
          _$InvestigationAckEnvelope._(
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
            r'InvestigationAckEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
