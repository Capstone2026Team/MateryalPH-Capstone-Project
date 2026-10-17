// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_detail_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeDetailEnvelope extends DisputeDetailEnvelope {
  @override
  final DisputeDetail data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$DisputeDetailEnvelope(
          [void Function(DisputeDetailEnvelopeBuilder)? updates]) =>
      (DisputeDetailEnvelopeBuilder()..update(updates))._build();

  _$DisputeDetailEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  DisputeDetailEnvelope rebuild(
          void Function(DisputeDetailEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeDetailEnvelopeBuilder toBuilder() =>
      DisputeDetailEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeDetailEnvelope &&
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
    return (newBuiltValueToStringHelper(r'DisputeDetailEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class DisputeDetailEnvelopeBuilder
    implements Builder<DisputeDetailEnvelope, DisputeDetailEnvelopeBuilder> {
  _$DisputeDetailEnvelope? _$v;

  DisputeDetailBuilder? _data;
  DisputeDetailBuilder get data => _$this._data ??= DisputeDetailBuilder();
  set data(DisputeDetailBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  DisputeDetailEnvelopeBuilder() {
    DisputeDetailEnvelope._defaults(this);
  }

  DisputeDetailEnvelopeBuilder get _$this {
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
  void replace(DisputeDetailEnvelope other) {
    _$v = other as _$DisputeDetailEnvelope;
  }

  @override
  void update(void Function(DisputeDetailEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeDetailEnvelope build() => _build();

  _$DisputeDetailEnvelope _build() {
    _$DisputeDetailEnvelope _$result;
    try {
      _$result = _$v ??
          _$DisputeDetailEnvelope._(
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
            r'DisputeDetailEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
