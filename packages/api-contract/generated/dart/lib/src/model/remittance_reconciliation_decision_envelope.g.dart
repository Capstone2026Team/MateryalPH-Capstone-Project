// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remittance_reconciliation_decision_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RemittanceReconciliationDecisionEnvelope
    extends RemittanceReconciliationDecisionEnvelope {
  @override
  final RemittanceReconciliationDecision data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$RemittanceReconciliationDecisionEnvelope(
          [void Function(RemittanceReconciliationDecisionEnvelopeBuilder)?
              updates]) =>
      (RemittanceReconciliationDecisionEnvelopeBuilder()..update(updates))
          ._build();

  _$RemittanceReconciliationDecisionEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  RemittanceReconciliationDecisionEnvelope rebuild(
          void Function(RemittanceReconciliationDecisionEnvelopeBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RemittanceReconciliationDecisionEnvelopeBuilder toBuilder() =>
      RemittanceReconciliationDecisionEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RemittanceReconciliationDecisionEnvelope &&
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
    return (newBuiltValueToStringHelper(
            r'RemittanceReconciliationDecisionEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class RemittanceReconciliationDecisionEnvelopeBuilder
    implements
        Builder<RemittanceReconciliationDecisionEnvelope,
            RemittanceReconciliationDecisionEnvelopeBuilder> {
  _$RemittanceReconciliationDecisionEnvelope? _$v;

  RemittanceReconciliationDecisionBuilder? _data;
  RemittanceReconciliationDecisionBuilder get data =>
      _$this._data ??= RemittanceReconciliationDecisionBuilder();
  set data(RemittanceReconciliationDecisionBuilder? data) =>
      _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  RemittanceReconciliationDecisionEnvelopeBuilder() {
    RemittanceReconciliationDecisionEnvelope._defaults(this);
  }

  RemittanceReconciliationDecisionEnvelopeBuilder get _$this {
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
  void replace(RemittanceReconciliationDecisionEnvelope other) {
    _$v = other as _$RemittanceReconciliationDecisionEnvelope;
  }

  @override
  void update(
      void Function(RemittanceReconciliationDecisionEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RemittanceReconciliationDecisionEnvelope build() => _build();

  _$RemittanceReconciliationDecisionEnvelope _build() {
    _$RemittanceReconciliationDecisionEnvelope _$result;
    try {
      _$result = _$v ??
          _$RemittanceReconciliationDecisionEnvelope._(
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
            r'RemittanceReconciliationDecisionEnvelope',
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
