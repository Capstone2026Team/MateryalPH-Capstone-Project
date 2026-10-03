// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_statement_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FeeStatementEnvelope extends FeeStatementEnvelope {
  @override
  final FeeStatement data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$FeeStatementEnvelope(
          [void Function(FeeStatementEnvelopeBuilder)? updates]) =>
      (FeeStatementEnvelopeBuilder()..update(updates))._build();

  _$FeeStatementEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  FeeStatementEnvelope rebuild(
          void Function(FeeStatementEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FeeStatementEnvelopeBuilder toBuilder() =>
      FeeStatementEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FeeStatementEnvelope &&
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
    return (newBuiltValueToStringHelper(r'FeeStatementEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class FeeStatementEnvelopeBuilder
    implements Builder<FeeStatementEnvelope, FeeStatementEnvelopeBuilder> {
  _$FeeStatementEnvelope? _$v;

  FeeStatementBuilder? _data;
  FeeStatementBuilder get data => _$this._data ??= FeeStatementBuilder();
  set data(FeeStatementBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  FeeStatementEnvelopeBuilder() {
    FeeStatementEnvelope._defaults(this);
  }

  FeeStatementEnvelopeBuilder get _$this {
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
  void replace(FeeStatementEnvelope other) {
    _$v = other as _$FeeStatementEnvelope;
  }

  @override
  void update(void Function(FeeStatementEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FeeStatementEnvelope build() => _build();

  _$FeeStatementEnvelope _build() {
    _$FeeStatementEnvelope _$result;
    try {
      _$result = _$v ??
          _$FeeStatementEnvelope._(
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
            r'FeeStatementEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
