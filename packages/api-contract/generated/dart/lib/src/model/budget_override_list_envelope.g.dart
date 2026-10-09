// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_override_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BudgetOverrideListEnvelope extends BudgetOverrideListEnvelope {
  @override
  final BuiltList<BudgetOverrideRecord> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$BudgetOverrideListEnvelope(
          [void Function(BudgetOverrideListEnvelopeBuilder)? updates]) =>
      (BudgetOverrideListEnvelopeBuilder()..update(updates))._build();

  _$BudgetOverrideListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  BudgetOverrideListEnvelope rebuild(
          void Function(BudgetOverrideListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BudgetOverrideListEnvelopeBuilder toBuilder() =>
      BudgetOverrideListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BudgetOverrideListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'BudgetOverrideListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class BudgetOverrideListEnvelopeBuilder
    implements
        Builder<BudgetOverrideListEnvelope, BudgetOverrideListEnvelopeBuilder> {
  _$BudgetOverrideListEnvelope? _$v;

  ListBuilder<BudgetOverrideRecord>? _data;
  ListBuilder<BudgetOverrideRecord> get data =>
      _$this._data ??= ListBuilder<BudgetOverrideRecord>();
  set data(ListBuilder<BudgetOverrideRecord>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  BudgetOverrideListEnvelopeBuilder() {
    BudgetOverrideListEnvelope._defaults(this);
  }

  BudgetOverrideListEnvelopeBuilder get _$this {
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
  void replace(BudgetOverrideListEnvelope other) {
    _$v = other as _$BudgetOverrideListEnvelope;
  }

  @override
  void update(void Function(BudgetOverrideListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BudgetOverrideListEnvelope build() => _build();

  _$BudgetOverrideListEnvelope _build() {
    _$BudgetOverrideListEnvelope _$result;
    try {
      _$result = _$v ??
          _$BudgetOverrideListEnvelope._(
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
            r'BudgetOverrideListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
