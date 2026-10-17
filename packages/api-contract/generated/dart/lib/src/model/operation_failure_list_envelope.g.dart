// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_failure_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OperationFailureListEnvelope extends OperationFailureListEnvelope {
  @override
  final BuiltList<OperationFailure> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$OperationFailureListEnvelope(
          [void Function(OperationFailureListEnvelopeBuilder)? updates]) =>
      (OperationFailureListEnvelopeBuilder()..update(updates))._build();

  _$OperationFailureListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  OperationFailureListEnvelope rebuild(
          void Function(OperationFailureListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperationFailureListEnvelopeBuilder toBuilder() =>
      OperationFailureListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperationFailureListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'OperationFailureListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class OperationFailureListEnvelopeBuilder
    implements
        Builder<OperationFailureListEnvelope,
            OperationFailureListEnvelopeBuilder> {
  _$OperationFailureListEnvelope? _$v;

  ListBuilder<OperationFailure>? _data;
  ListBuilder<OperationFailure> get data =>
      _$this._data ??= ListBuilder<OperationFailure>();
  set data(ListBuilder<OperationFailure>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  OperationFailureListEnvelopeBuilder() {
    OperationFailureListEnvelope._defaults(this);
  }

  OperationFailureListEnvelopeBuilder get _$this {
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
  void replace(OperationFailureListEnvelope other) {
    _$v = other as _$OperationFailureListEnvelope;
  }

  @override
  void update(void Function(OperationFailureListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperationFailureListEnvelope build() => _build();

  _$OperationFailureListEnvelope _build() {
    _$OperationFailureListEnvelope _$result;
    try {
      _$result = _$v ??
          _$OperationFailureListEnvelope._(
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
            r'OperationFailureListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
