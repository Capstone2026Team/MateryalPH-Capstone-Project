// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_setup_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorSetupEnvelope extends VendorSetupEnvelope {
  @override
  final VendorSetup data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorSetupEnvelope(
          [void Function(VendorSetupEnvelopeBuilder)? updates]) =>
      (VendorSetupEnvelopeBuilder()..update(updates))._build();

  _$VendorSetupEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorSetupEnvelope rebuild(
          void Function(VendorSetupEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorSetupEnvelopeBuilder toBuilder() =>
      VendorSetupEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorSetupEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorSetupEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorSetupEnvelopeBuilder
    implements Builder<VendorSetupEnvelope, VendorSetupEnvelopeBuilder> {
  _$VendorSetupEnvelope? _$v;

  VendorSetupBuilder? _data;
  VendorSetupBuilder get data => _$this._data ??= VendorSetupBuilder();
  set data(VendorSetupBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorSetupEnvelopeBuilder() {
    VendorSetupEnvelope._defaults(this);
  }

  VendorSetupEnvelopeBuilder get _$this {
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
  void replace(VendorSetupEnvelope other) {
    _$v = other as _$VendorSetupEnvelope;
  }

  @override
  void update(void Function(VendorSetupEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorSetupEnvelope build() => _build();

  _$VendorSetupEnvelope _build() {
    _$VendorSetupEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorSetupEnvelope._(
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
            r'VendorSetupEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
