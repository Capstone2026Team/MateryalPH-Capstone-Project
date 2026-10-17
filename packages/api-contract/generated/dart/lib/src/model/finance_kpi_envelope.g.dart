// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_kpi_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FinanceKpiEnvelope extends FinanceKpiEnvelope {
  @override
  final FinanceKpis data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$FinanceKpiEnvelope(
          [void Function(FinanceKpiEnvelopeBuilder)? updates]) =>
      (FinanceKpiEnvelopeBuilder()..update(updates))._build();

  _$FinanceKpiEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  FinanceKpiEnvelope rebuild(
          void Function(FinanceKpiEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FinanceKpiEnvelopeBuilder toBuilder() =>
      FinanceKpiEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FinanceKpiEnvelope &&
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
    return (newBuiltValueToStringHelper(r'FinanceKpiEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class FinanceKpiEnvelopeBuilder
    implements Builder<FinanceKpiEnvelope, FinanceKpiEnvelopeBuilder> {
  _$FinanceKpiEnvelope? _$v;

  FinanceKpisBuilder? _data;
  FinanceKpisBuilder get data => _$this._data ??= FinanceKpisBuilder();
  set data(FinanceKpisBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  FinanceKpiEnvelopeBuilder() {
    FinanceKpiEnvelope._defaults(this);
  }

  FinanceKpiEnvelopeBuilder get _$this {
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
  void replace(FinanceKpiEnvelope other) {
    _$v = other as _$FinanceKpiEnvelope;
  }

  @override
  void update(void Function(FinanceKpiEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FinanceKpiEnvelope build() => _build();

  _$FinanceKpiEnvelope _build() {
    _$FinanceKpiEnvelope _$result;
    try {
      _$result = _$v ??
          _$FinanceKpiEnvelope._(
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
            r'FinanceKpiEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
