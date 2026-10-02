// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withholding_accumulator_detail_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WithholdingAccumulatorDetailEnvelope
    extends WithholdingAccumulatorDetailEnvelope {
  @override
  final WithholdingAccumulatorDetail data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$WithholdingAccumulatorDetailEnvelope(
          [void Function(WithholdingAccumulatorDetailEnvelopeBuilder)?
              updates]) =>
      (WithholdingAccumulatorDetailEnvelopeBuilder()..update(updates))._build();

  _$WithholdingAccumulatorDetailEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  WithholdingAccumulatorDetailEnvelope rebuild(
          void Function(WithholdingAccumulatorDetailEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WithholdingAccumulatorDetailEnvelopeBuilder toBuilder() =>
      WithholdingAccumulatorDetailEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WithholdingAccumulatorDetailEnvelope &&
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
    return (newBuiltValueToStringHelper(r'WithholdingAccumulatorDetailEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class WithholdingAccumulatorDetailEnvelopeBuilder
    implements
        Builder<WithholdingAccumulatorDetailEnvelope,
            WithholdingAccumulatorDetailEnvelopeBuilder> {
  _$WithholdingAccumulatorDetailEnvelope? _$v;

  WithholdingAccumulatorDetailBuilder? _data;
  WithholdingAccumulatorDetailBuilder get data =>
      _$this._data ??= WithholdingAccumulatorDetailBuilder();
  set data(WithholdingAccumulatorDetailBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  WithholdingAccumulatorDetailEnvelopeBuilder() {
    WithholdingAccumulatorDetailEnvelope._defaults(this);
  }

  WithholdingAccumulatorDetailEnvelopeBuilder get _$this {
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
  void replace(WithholdingAccumulatorDetailEnvelope other) {
    _$v = other as _$WithholdingAccumulatorDetailEnvelope;
  }

  @override
  void update(
      void Function(WithholdingAccumulatorDetailEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WithholdingAccumulatorDetailEnvelope build() => _build();

  _$WithholdingAccumulatorDetailEnvelope _build() {
    _$WithholdingAccumulatorDetailEnvelope _$result;
    try {
      _$result = _$v ??
          _$WithholdingAccumulatorDetailEnvelope._(
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
            r'WithholdingAccumulatorDetailEnvelope',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
