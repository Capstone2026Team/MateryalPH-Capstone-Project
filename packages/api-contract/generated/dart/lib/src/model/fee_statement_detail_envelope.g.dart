// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_statement_detail_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FeeStatementDetailEnvelope extends FeeStatementDetailEnvelope {
  @override
  final FeeStatementDetail data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$FeeStatementDetailEnvelope(
          [void Function(FeeStatementDetailEnvelopeBuilder)? updates]) =>
      (FeeStatementDetailEnvelopeBuilder()..update(updates))._build();

  _$FeeStatementDetailEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  FeeStatementDetailEnvelope rebuild(
          void Function(FeeStatementDetailEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FeeStatementDetailEnvelopeBuilder toBuilder() =>
      FeeStatementDetailEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FeeStatementDetailEnvelope &&
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
    return (newBuiltValueToStringHelper(r'FeeStatementDetailEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class FeeStatementDetailEnvelopeBuilder
    implements
        Builder<FeeStatementDetailEnvelope, FeeStatementDetailEnvelopeBuilder> {
  _$FeeStatementDetailEnvelope? _$v;

  FeeStatementDetailBuilder? _data;
  FeeStatementDetailBuilder get data =>
      _$this._data ??= FeeStatementDetailBuilder();
  set data(FeeStatementDetailBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  FeeStatementDetailEnvelopeBuilder() {
    FeeStatementDetailEnvelope._defaults(this);
  }

  FeeStatementDetailEnvelopeBuilder get _$this {
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
  void replace(FeeStatementDetailEnvelope other) {
    _$v = other as _$FeeStatementDetailEnvelope;
  }

  @override
  void update(void Function(FeeStatementDetailEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FeeStatementDetailEnvelope build() => _build();

  _$FeeStatementDetailEnvelope _build() {
    _$FeeStatementDetailEnvelope _$result;
    try {
      _$result = _$v ??
          _$FeeStatementDetailEnvelope._(
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
            r'FeeStatementDetailEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
