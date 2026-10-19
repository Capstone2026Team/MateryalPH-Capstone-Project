// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_commission_monitoring_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorCommissionMonitoringEnvelope
    extends VendorCommissionMonitoringEnvelope {
  @override
  final VendorCommissionMonitoring data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorCommissionMonitoringEnvelope(
          [void Function(VendorCommissionMonitoringEnvelopeBuilder)?
              updates]) =>
      (VendorCommissionMonitoringEnvelopeBuilder()..update(updates))._build();

  _$VendorCommissionMonitoringEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorCommissionMonitoringEnvelope rebuild(
          void Function(VendorCommissionMonitoringEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorCommissionMonitoringEnvelopeBuilder toBuilder() =>
      VendorCommissionMonitoringEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorCommissionMonitoringEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorCommissionMonitoringEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorCommissionMonitoringEnvelopeBuilder
    implements
        Builder<VendorCommissionMonitoringEnvelope,
            VendorCommissionMonitoringEnvelopeBuilder> {
  _$VendorCommissionMonitoringEnvelope? _$v;

  VendorCommissionMonitoringBuilder? _data;
  VendorCommissionMonitoringBuilder get data =>
      _$this._data ??= VendorCommissionMonitoringBuilder();
  set data(VendorCommissionMonitoringBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorCommissionMonitoringEnvelopeBuilder() {
    VendorCommissionMonitoringEnvelope._defaults(this);
  }

  VendorCommissionMonitoringEnvelopeBuilder get _$this {
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
  void replace(VendorCommissionMonitoringEnvelope other) {
    _$v = other as _$VendorCommissionMonitoringEnvelope;
  }

  @override
  void update(
      void Function(VendorCommissionMonitoringEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorCommissionMonitoringEnvelope build() => _build();

  _$VendorCommissionMonitoringEnvelope _build() {
    _$VendorCommissionMonitoringEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorCommissionMonitoringEnvelope._(
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
            r'VendorCommissionMonitoringEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
