// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_adjustment_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TaxAdjustmentEnvelope extends TaxAdjustmentEnvelope {
  @override
  final TaxAdjustment data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$TaxAdjustmentEnvelope(
          [void Function(TaxAdjustmentEnvelopeBuilder)? updates]) =>
      (TaxAdjustmentEnvelopeBuilder()..update(updates))._build();

  _$TaxAdjustmentEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  TaxAdjustmentEnvelope rebuild(
          void Function(TaxAdjustmentEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaxAdjustmentEnvelopeBuilder toBuilder() =>
      TaxAdjustmentEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaxAdjustmentEnvelope &&
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
    return (newBuiltValueToStringHelper(r'TaxAdjustmentEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class TaxAdjustmentEnvelopeBuilder
    implements Builder<TaxAdjustmentEnvelope, TaxAdjustmentEnvelopeBuilder> {
  _$TaxAdjustmentEnvelope? _$v;

  TaxAdjustmentBuilder? _data;
  TaxAdjustmentBuilder get data => _$this._data ??= TaxAdjustmentBuilder();
  set data(TaxAdjustmentBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  TaxAdjustmentEnvelopeBuilder() {
    TaxAdjustmentEnvelope._defaults(this);
  }

  TaxAdjustmentEnvelopeBuilder get _$this {
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
  void replace(TaxAdjustmentEnvelope other) {
    _$v = other as _$TaxAdjustmentEnvelope;
  }

  @override
  void update(void Function(TaxAdjustmentEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaxAdjustmentEnvelope build() => _build();

  _$TaxAdjustmentEnvelope _build() {
    _$TaxAdjustmentEnvelope _$result;
    try {
      _$result = _$v ??
          _$TaxAdjustmentEnvelope._(
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
            r'TaxAdjustmentEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
