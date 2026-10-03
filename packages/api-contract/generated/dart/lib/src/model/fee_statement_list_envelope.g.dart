// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_statement_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FeeStatementListEnvelope extends FeeStatementListEnvelope {
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$FeeStatementListEnvelope(
          [void Function(FeeStatementListEnvelopeBuilder)? updates]) =>
      (FeeStatementListEnvelopeBuilder()..update(updates))._build();

  _$FeeStatementListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  FeeStatementListEnvelope rebuild(
          void Function(FeeStatementListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FeeStatementListEnvelopeBuilder toBuilder() =>
      FeeStatementListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FeeStatementListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'FeeStatementListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class FeeStatementListEnvelopeBuilder
    implements
        Builder<FeeStatementListEnvelope, FeeStatementListEnvelopeBuilder> {
  _$FeeStatementListEnvelope? _$v;

  ListBuilder<BuiltMap<String, JsonObject?>>? _data;
  ListBuilder<BuiltMap<String, JsonObject?>> get data =>
      _$this._data ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set data(ListBuilder<BuiltMap<String, JsonObject?>>? data) =>
      _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  FeeStatementListEnvelopeBuilder() {
    FeeStatementListEnvelope._defaults(this);
  }

  FeeStatementListEnvelopeBuilder get _$this {
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
  void replace(FeeStatementListEnvelope other) {
    _$v = other as _$FeeStatementListEnvelope;
  }

  @override
  void update(void Function(FeeStatementListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FeeStatementListEnvelope build() => _build();

  _$FeeStatementListEnvelope _build() {
    _$FeeStatementListEnvelope _$result;
    try {
      _$result = _$v ??
          _$FeeStatementListEnvelope._(
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
            r'FeeStatementListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
