// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'physical_payment_summary_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PhysicalPaymentSummaryEnvelope extends PhysicalPaymentSummaryEnvelope {
  @override
  final PhysicalPaymentSummary data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$PhysicalPaymentSummaryEnvelope(
          [void Function(PhysicalPaymentSummaryEnvelopeBuilder)? updates]) =>
      (PhysicalPaymentSummaryEnvelopeBuilder()..update(updates))._build();

  _$PhysicalPaymentSummaryEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  PhysicalPaymentSummaryEnvelope rebuild(
          void Function(PhysicalPaymentSummaryEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PhysicalPaymentSummaryEnvelopeBuilder toBuilder() =>
      PhysicalPaymentSummaryEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhysicalPaymentSummaryEnvelope &&
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
    return (newBuiltValueToStringHelper(r'PhysicalPaymentSummaryEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class PhysicalPaymentSummaryEnvelopeBuilder
    implements
        Builder<PhysicalPaymentSummaryEnvelope,
            PhysicalPaymentSummaryEnvelopeBuilder> {
  _$PhysicalPaymentSummaryEnvelope? _$v;

  PhysicalPaymentSummaryBuilder? _data;
  PhysicalPaymentSummaryBuilder get data =>
      _$this._data ??= PhysicalPaymentSummaryBuilder();
  set data(PhysicalPaymentSummaryBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  PhysicalPaymentSummaryEnvelopeBuilder() {
    PhysicalPaymentSummaryEnvelope._defaults(this);
  }

  PhysicalPaymentSummaryEnvelopeBuilder get _$this {
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
  void replace(PhysicalPaymentSummaryEnvelope other) {
    _$v = other as _$PhysicalPaymentSummaryEnvelope;
  }

  @override
  void update(void Function(PhysicalPaymentSummaryEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhysicalPaymentSummaryEnvelope build() => _build();

  _$PhysicalPaymentSummaryEnvelope _build() {
    _$PhysicalPaymentSummaryEnvelope _$result;
    try {
      _$result = _$v ??
          _$PhysicalPaymentSummaryEnvelope._(
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
            r'PhysicalPaymentSummaryEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
