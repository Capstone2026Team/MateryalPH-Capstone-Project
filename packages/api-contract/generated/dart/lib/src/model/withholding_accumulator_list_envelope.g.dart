// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withholding_accumulator_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WithholdingAccumulatorListEnvelope
    extends WithholdingAccumulatorListEnvelope {
  @override
  final BuiltList<WithholdingAccumulatorView> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$WithholdingAccumulatorListEnvelope(
          [void Function(WithholdingAccumulatorListEnvelopeBuilder)?
              updates]) =>
      (WithholdingAccumulatorListEnvelopeBuilder()..update(updates))._build();

  _$WithholdingAccumulatorListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  WithholdingAccumulatorListEnvelope rebuild(
          void Function(WithholdingAccumulatorListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WithholdingAccumulatorListEnvelopeBuilder toBuilder() =>
      WithholdingAccumulatorListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WithholdingAccumulatorListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'WithholdingAccumulatorListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class WithholdingAccumulatorListEnvelopeBuilder
    implements
        Builder<WithholdingAccumulatorListEnvelope,
            WithholdingAccumulatorListEnvelopeBuilder> {
  _$WithholdingAccumulatorListEnvelope? _$v;

  ListBuilder<WithholdingAccumulatorView>? _data;
  ListBuilder<WithholdingAccumulatorView> get data =>
      _$this._data ??= ListBuilder<WithholdingAccumulatorView>();
  set data(ListBuilder<WithholdingAccumulatorView>? data) =>
      _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  WithholdingAccumulatorListEnvelopeBuilder() {
    WithholdingAccumulatorListEnvelope._defaults(this);
  }

  WithholdingAccumulatorListEnvelopeBuilder get _$this {
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
  void replace(WithholdingAccumulatorListEnvelope other) {
    _$v = other as _$WithholdingAccumulatorListEnvelope;
  }

  @override
  void update(
      void Function(WithholdingAccumulatorListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WithholdingAccumulatorListEnvelope build() => _build();

  _$WithholdingAccumulatorListEnvelope _build() {
    _$WithholdingAccumulatorListEnvelope _$result;
    try {
      _$result = _$v ??
          _$WithholdingAccumulatorListEnvelope._(
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
            r'WithholdingAccumulatorListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
