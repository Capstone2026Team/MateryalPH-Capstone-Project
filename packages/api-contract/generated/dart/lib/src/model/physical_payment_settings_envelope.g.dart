// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'physical_payment_settings_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PhysicalPaymentSettingsEnvelope
    extends PhysicalPaymentSettingsEnvelope {
  @override
  final PhysicalPaymentSettings data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$PhysicalPaymentSettingsEnvelope(
          [void Function(PhysicalPaymentSettingsEnvelopeBuilder)? updates]) =>
      (PhysicalPaymentSettingsEnvelopeBuilder()..update(updates))._build();

  _$PhysicalPaymentSettingsEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  PhysicalPaymentSettingsEnvelope rebuild(
          void Function(PhysicalPaymentSettingsEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PhysicalPaymentSettingsEnvelopeBuilder toBuilder() =>
      PhysicalPaymentSettingsEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhysicalPaymentSettingsEnvelope &&
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
    return (newBuiltValueToStringHelper(r'PhysicalPaymentSettingsEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class PhysicalPaymentSettingsEnvelopeBuilder
    implements
        Builder<PhysicalPaymentSettingsEnvelope,
            PhysicalPaymentSettingsEnvelopeBuilder> {
  _$PhysicalPaymentSettingsEnvelope? _$v;

  PhysicalPaymentSettingsBuilder? _data;
  PhysicalPaymentSettingsBuilder get data =>
      _$this._data ??= PhysicalPaymentSettingsBuilder();
  set data(PhysicalPaymentSettingsBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  PhysicalPaymentSettingsEnvelopeBuilder() {
    PhysicalPaymentSettingsEnvelope._defaults(this);
  }

  PhysicalPaymentSettingsEnvelopeBuilder get _$this {
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
  void replace(PhysicalPaymentSettingsEnvelope other) {
    _$v = other as _$PhysicalPaymentSettingsEnvelope;
  }

  @override
  void update(void Function(PhysicalPaymentSettingsEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhysicalPaymentSettingsEnvelope build() => _build();

  _$PhysicalPaymentSettingsEnvelope _build() {
    _$PhysicalPaymentSettingsEnvelope _$result;
    try {
      _$result = _$v ??
          _$PhysicalPaymentSettingsEnvelope._(
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
            r'PhysicalPaymentSettingsEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
