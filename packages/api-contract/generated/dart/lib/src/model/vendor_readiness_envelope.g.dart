// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_readiness_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorReadinessEnvelope extends VendorReadinessEnvelope {
  @override
  final VendorReadiness data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorReadinessEnvelope(
          [void Function(VendorReadinessEnvelopeBuilder)? updates]) =>
      (VendorReadinessEnvelopeBuilder()..update(updates))._build();

  _$VendorReadinessEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorReadinessEnvelope rebuild(
          void Function(VendorReadinessEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorReadinessEnvelopeBuilder toBuilder() =>
      VendorReadinessEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorReadinessEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorReadinessEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorReadinessEnvelopeBuilder
    implements
        Builder<VendorReadinessEnvelope, VendorReadinessEnvelopeBuilder> {
  _$VendorReadinessEnvelope? _$v;

  VendorReadinessBuilder? _data;
  VendorReadinessBuilder get data => _$this._data ??= VendorReadinessBuilder();
  set data(VendorReadinessBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorReadinessEnvelopeBuilder() {
    VendorReadinessEnvelope._defaults(this);
  }

  VendorReadinessEnvelopeBuilder get _$this {
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
  void replace(VendorReadinessEnvelope other) {
    _$v = other as _$VendorReadinessEnvelope;
  }

  @override
  void update(void Function(VendorReadinessEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorReadinessEnvelope build() => _build();

  _$VendorReadinessEnvelope _build() {
    _$VendorReadinessEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorReadinessEnvelope._(
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
            r'VendorReadinessEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
